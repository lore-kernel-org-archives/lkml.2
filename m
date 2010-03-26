Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753533Ab0CZCIJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 22:08:09 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:58204 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752190Ab0CZCIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 22:08:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=TpKQEso05knYm2sNMp5qaPUYuYC44J+l9bQCSX1gGiIfSbSJNv1F3+7JXJO7Wsynuv
         M7KeiFtRKlBtTHyA9KdpvR4iG4GYxYDqQi9U8wzPf46ph4u1ZgjKsaoRHavnlTD334Y5
         6ReAdDNf+797eqsyk6NBw65ZDho4rH3S2ZRtY=
MIME-Version: 1.0
In-Reply-To: <4BAAD5BB.7050101@samsung.com>
References: <4BAAD5BB.7050101@samsung.com>
Date: Fri, 26 Mar 2010 11:08:06 +0900
Message-ID: <1b68c6791003251908w299806cbm1443728ea08cfb72@mail.gmail.com>
Subject: Re: [PATCH v2] PL330: Add PL330 DMA controller driver
From: jassi brar <jassisinghbrar@gmail.com>
To: Joonyoung Shim <jy0922.shim@samsung.com>
Cc: dan.j.williams@intel.com, linus.ml.walleij@gmail.com,
       kyungmin.park@samsung.com, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 25, 2010 at 12:17 PM, Joonyoung Shim
<jy0922.shim@samsung.com> wrote:
> The PL330 is currently the dma controller using at the S5PC1XX arm SoC.
> This supports DMA_MEMCPY and DMA_SLAVE.
>
> The datasheet for the PL330 can find below url:
> http://infocenter.arm.com/help/topic/com.arm.doc.ddi0424a/DDI0424A_dmac_pl330_r0p0_trm.pdf
>
> Signed-off-by: Joonyoung Shim <jy0922.shim@samsung.com>
> ---
> Change log:
>
> v2: Convert into an amba_device driver.
>    Code clean and update from v1 patch review.

Here goes some quick technical feedback of the code.
Please remember that these issues are only secondary.
The primary drawback is the approach that this patch adopts,
as already explained in other posts.

[snip]

> +/* instruction set functions */
> +static inline int pl330_dmaaddh(u8 *desc_pool_virt, u16 imm, bool ra)
> +{
> +       u8 opcode = DMAADDH | (ra << 1);
> +
> +       writeb(opcode, desc_pool_virt++);
> +       writew(imm, desc_pool_virt);
> +       return 3;
> +}
> +
> +static inline int pl330_dmaend(u8 *desc_pool_virt)
> +{
> +       u8 opcode = DMAEND;
> +
> +       writeb(opcode, desc_pool_virt);
> +       return 1;
> +}
> +
> +static inline int pl330_dmaflushp(u8 *desc_pool_virt, u8 periph)
> +{
> +       u8 opcode = DMAFLUSHHP;
> +
> +       writeb(opcode, desc_pool_virt++);
> +       writeb(periph << 3, desc_pool_virt);
> +       return 2;
> +}
> +
> +static inline int pl330_dmald(u8 *desc_pool_virt)
> +{
> +       u8 opcode = DMALD;
> +
> +       writeb(opcode, desc_pool_virt);
> +       return 1;
> +}
> +
> +static inline int pl330_dmalds(u8 *desc_pool_virt)
> +{
> +       u8 opcode = DMALDS;
> +
> +       writeb(opcode, desc_pool_virt);
> +       return 1;
> +}
> +
> +static inline int pl330_dmaldb(u8 *desc_pool_virt)
> +{
> +       u8 opcode = DMALDB;
> +
> +       writeb(opcode, desc_pool_virt);
> +       return 1;
> +}
> +
> +static inline int pl330_dmaldps(u8 *desc_pool_virt, u8 periph)
> +{
> +       u8 opcode = DMALDPS;
> +
> +       writeb(opcode, desc_pool_virt++);
> +       writeb(periph << 3, desc_pool_virt);
> +       return 2;
> +}
> +
> +static inline int pl330_dmaldpb(u8 *desc_pool_virt, u8 periph)
> +{
> +       u8 opcode = DMALDPB;
> +
> +       writeb(opcode, desc_pool_virt++);
> +       writeb(periph << 3, desc_pool_virt);
> +       return 2;
> +}
> +
> +static inline int pl330_dmalp(u8 *desc_pool_virt, u8 iter, bool lc)
> +{
> +       u8 opcode = DMALP | (lc << 1);
> +
> +       writeb(opcode, desc_pool_virt++);
> +       writeb(iter, desc_pool_virt);
> +       return 2;
> +}
> +
> +static inline int pl330_dmalpend(u8 *desc_pool_virt, u8 backwards_jump, bool lc)
> +{
> +       u8 opcode = DMALPEND | (lc << 2);
> +
> +       writeb(opcode, desc_pool_virt++);
> +       writeb(backwards_jump, desc_pool_virt);
> +       return 2;
> +}
> +
> +static inline int pl330_dmalpends(u8 *desc_pool_virt, u8 backwards_jump,
> +               bool lc)
> +{
> +       u8 opcode = DMALPENDS | (lc << 2);
> +
> +       writeb(opcode, desc_pool_virt++);
> +       writeb(backwards_jump, desc_pool_virt);
> +       return 2;
> +}
> +
> +static inline int pl330_dmalpendb(u8 *desc_pool_virt, u8 backwards_jump,
> +               bool lc)
> +{
> +       u8 opcode = DMALPENDB | (lc << 2);
> +
> +       writeb(opcode, desc_pool_virt++);
> +       writeb(backwards_jump, desc_pool_virt);
> +       return 2;
> +}
> +
> +static inline int pl330_dmalpfe(u8 *desc_pool_virt, u8 backwards_jump, bool lc)
> +{
> +       u8 opcode = DMALPFE | (lc << 2);
> +
> +       writeb(opcode, desc_pool_virt++);
> +       writeb(backwards_jump, desc_pool_virt);
> +       return 2;
> +}
> +
> +static inline int pl330_dmakill(u8 *desc_pool_virt)
> +{
> +       u8 opcode = DMAKILL;
> +
> +       writeb(opcode, desc_pool_virt);
> +       return 1;
> +}
> +
> +static inline int pl330_dmamov(u8 *desc_pool_virt, u8 rd, u32 imm)
> +{
> +       u8 opcode = DMAMOV;
> +
> +       writeb(opcode, desc_pool_virt++);
> +       writeb(rd, desc_pool_virt++);
> +       writel(imm, desc_pool_virt);
> +       return 6;
> +}
> +
> +static inline int pl330_dmanop(u8 *desc_pool_virt)
> +{
> +       u8 opcode = DMANOP;
> +
> +       writeb(opcode, desc_pool_virt);
> +       return 1;
> +}
> +
> +static inline int pl330_dmarmb(u8 *desc_pool_virt)
> +{
> +       u8 opcode = DMARMB;
> +
> +       writeb(opcode, desc_pool_virt);
> +       return 1;
> +}
> +
> +static inline int pl330_dmasev(u8 *desc_pool_virt, u8 event_num)
> +{
> +       u8 opcode = DMASEV;
> +
> +       writeb(opcode, desc_pool_virt++);
> +       writeb(event_num << 3, desc_pool_virt);
> +       return 2;
> +}
> +
> +static inline int pl330_dmast(u8 *desc_pool_virt)
> +{
> +       u8 opcode = DMAST;
> +
> +       writeb(opcode, desc_pool_virt);
> +       return 1;
> +}
> +
> +static inline int pl330_dmasts(u8 *desc_pool_virt)
> +{
> +       u8 opcode = DMASTS;
> +
> +       writeb(opcode, desc_pool_virt);
> +       return 1;
> +}
> +
> +static inline int pl330_dmastb(u8 *desc_pool_virt)
> +{
> +       u8 opcode = DMASTB;
> +
> +       writeb(opcode, desc_pool_virt);
> +       return 1;
> +}
> +
> +static inline int pl330_dmastps(u8 *desc_pool_virt, u8 periph)
> +{
> +       u8 opcode = DMASTPS;
> +
> +       writeb(opcode, desc_pool_virt++);
> +       writeb(periph << 3, desc_pool_virt);
> +       return 2;
> +}
> +
> +static inline int pl330_dmastpb(u8 *desc_pool_virt, u8 periph)
> +{
> +       u8 opcode = DMASTPB;
> +
> +       writeb(opcode, desc_pool_virt++);
> +       writeb(periph << 3, desc_pool_virt);
> +       return 2;
> +}
> +
> +static inline int pl330_dmastz(u8 *desc_pool_virt)
> +{
> +       u8 opcode = DMASTZ;
> +
> +       writeb(opcode, desc_pool_virt);
> +       return 1;
> +}
> +
> +static inline int pl330_dmawfe(u8 *desc_pool_virt, u8 event_num, bool invalid)
> +{
> +       u8 opcode = DMAWFE;
> +
> +       writeb(opcode, desc_pool_virt++);
> +       writeb((event_num << 3) | (invalid << 1), desc_pool_virt);
> +       return 2;
> +}
> +
> +static inline int pl330_dmawfps(u8 *desc_pool_virt, u8 periph)
> +{
> +       u8 opcode = DMAWFPS;
> +
> +       writeb(opcode, desc_pool_virt++);
> +       writeb(periph << 3, desc_pool_virt);
> +       return 2;
> +}
> +
> +static inline int pl330_dmawfpb(u8 *desc_pool_virt, u8 periph)
> +{
> +       u8 opcode = DMAWFPB;
> +
> +       writeb(opcode, desc_pool_virt++);
> +       writeb(periph << 3, desc_pool_virt);
> +       return 2;
> +}
> +
> +static inline int pl330_dmawfpp(u8 *desc_pool_virt, u8 periph)
> +{
> +       u8 opcode = DMAWFPP;
> +
> +       writeb(opcode, desc_pool_virt++);
> +       writeb(periph << 3, desc_pool_virt);
> +       return 2;
> +}
> +
> +static inline int pl330_dmawmb(u8 *desc_pool_virt)
> +{
> +       u8 opcode = DMAWMB;
> +
> +       writeb(opcode, desc_pool_virt);
> +       return 1;
> +}
> +
> +static void pl330_dmago(struct pl330_chan *pl330_ch, struct pl330_desc *desc,
> +               bool ns)
> +{
> +       unsigned int val;
> +       u8 opcode = DMAGO | (ns << 1);
> +
> +       val = (pl330_ch->id << 24) | (opcode << 16) | (pl330_ch->id << 8);
> +       writel(val, pl330_ch->pl330_dev->reg_base + PL330_DBGINST0);
> +
> +       val = desc->async_tx.phys;
> +       writel(val, pl330_ch->pl330_dev->reg_base + PL330_DBGINST1);
> +
> +       writel(0, pl330_ch->pl330_dev->reg_base + PL330_DBGCMD);
> +}
As already mentioned by Marc, it doesn't have to be read/write.
PL330 specifies the microcode buffers to be on system memory and that
need not be treated like ioports.

[snip]

> +static struct pl330_desc *
> +pl330_alloc_descriptor(struct pl330_chan *pl330_ch, gfp_t flags)
> +{
> +       struct device *dev = pl330_ch->pl330_dev->common.dev;
> +       struct pl330_desc *desc;
> +       dma_addr_t phys;
> +
> +       desc = kzalloc(sizeof(*desc), flags);
> +       if (!desc)
> +               return NULL;
> +
> +       desc->desc_pool_virt = dma_alloc_coherent(dev, PL330_POOL_SIZE, &phys,
> +                       flags);
These allocations are inefficient and don't need to be done so often.
My implementation allocates a pool of such buffers(size specified by
DMA API driver)
and manage them by simple pointer manipulation.
Though the xfer requests for DMA API has to be managed in the DMA API driver.

> +       if (!desc->desc_pool_virt) {
> +               kfree(desc);
> +               return NULL;
> +       }
> +
> +       dma_async_tx_descriptor_init(&desc->async_tx, &pl330_ch->common);
> +       desc->async_tx.tx_submit = pl330_tx_submit;
> +       desc->async_tx.phys = phys;
> +
> +       return desc;
> +}
> +
> +static struct pl330_desc *pl330_get_descriptor(struct pl330_chan *pl330_ch)
> +{
> +       struct device *dev = pl330_ch->pl330_dev->common.dev;
> +       struct pl330_desc *desc;
> +
> +       if (!list_empty(&pl330_ch->free_desc)) {
> +               desc = to_pl330_desc(pl330_ch->free_desc.next);
> +               list_del(&desc->desc_node);
> +       } else {
> +               /* try to get another desc */
> +               desc = pl330_alloc_descriptor(pl330_ch, GFP_ATOMIC);
> +               if (!desc) {
> +                       dev_err(dev, "descriptor alloc failed\n");
> +                       return NULL;
> +               }
> +       }
> +
> +       return desc;
> +}
> +
> +static int pl330_alloc_chan_resources(struct dma_chan *chan)
> +{
> +       struct pl330_chan *pl330_ch = to_pl330_chan(chan);
> +       struct device *dev = pl330_ch->pl330_dev->common.dev;
> +       struct pl330_desc *desc;
> +       int i;
> +       LIST_HEAD(tmp_list);
> +
> +       /* have we already been set up? */
> +       if (!list_empty(&pl330_ch->free_desc))
> +               return pl330_ch->desc_num;
> +
> +       for (i = 0; i < PL330_DESC_NUM; i++) {
> +               desc = pl330_alloc_descriptor(pl330_ch, GFP_KERNEL);
> +               if (!desc) {
> +                       dev_err(dev, "Only %d initial descriptors\n", i);
> +                       break;
> +               }
> +               list_add_tail(&desc->desc_node, &tmp_list);
> +       }
> +
> +       pl330_ch->completed = chan->cookie = 1;
> +       pl330_ch->desc_num = i;
> +       list_splice(&tmp_list, &pl330_ch->free_desc);
> +
> +       return pl330_ch->desc_num;
> +}
> +

[snip]

> +static unsigned int pl330_make_instructions(struct pl330_chan *pl330_ch,
> +               struct pl330_desc *desc, dma_addr_t dest, dma_addr_t src,
> +               size_t len, unsigned int inst_size,
> +               enum dma_data_direction direction)
> +{
> +       struct device *dev = pl330_ch->pl330_dev->common.dev;
> +       void *buf = desc->desc_pool_virt;
> +       u32 control = *(u32 *)&pl330_ch->pl330_reg_cc;
> +       unsigned int loop_size;
> +       unsigned int loop_size_rest;
> +       unsigned int loop_count0;
> +       unsigned int loop_count1 = 0;
> +       unsigned int loop_count0_rest = 0;
> +       unsigned int loop_start0 = 0;
> +       unsigned int loop_start1 = 0;
> +
> +       dev_dbg(dev, "desc_pool_phys: 0x%x\n", desc->async_tx.phys);
> +       dev_dbg(dev, "control: 0x%x\n", control);
> +       dev_dbg(dev, "dest: 0x%x\n", dest);
> +       dev_dbg(dev, "src: 0x%x\n", src);
> +       dev_dbg(dev, "len: 0x%x\n", len);
> +
> +       /* calculate loop count */
> +       loop_size = (pl330_ch->pl330_reg_cc.src_burst_len + 1) *
> +               (1 << pl330_ch->pl330_reg_cc.src_burst_size);
> +       loop_count0 = (len / loop_size) - 1;
> +       loop_size_rest = len % loop_size;
> +
> +       dev_dbg(dev, "loop_size: 0x%x\n", loop_size);
> +       dev_dbg(dev, "loop_count0: 0x%x\n", loop_count0);
> +       dev_dbg(dev, "loop_size_rest: 0x%x\n", loop_size_rest);
> +
> +       if (loop_size_rest) {
> +               dev_err(dev, "Transfer length must be aligned to loop_size\n");
> +               return -EINVAL;
> +       }
This limit, though not serious, is unconditionally imposed by your design.
There are ways to get around this situation by smarter generation of
microcode.

> +       if (loop_count0 >= PL330_MAX_LOOPS) {
> +               loop_count1 = (loop_count0 / PL330_MAX_LOOPS) - 1;
> +               loop_count0_rest = (loop_count0 % PL330_MAX_LOOPS) + 1;
> +               loop_count0 = PL330_MAX_LOOPS - 1;
> +               dev_dbg(dev, "loop_count0: 0x%x\n", loop_count0);
> +               dev_dbg(dev, "loop_count0_rest: 0x%x\n", loop_count0_rest);
> +               dev_dbg(dev, "loop_count1: 0x%x\n", loop_count1);
> +
> +               if (loop_count1 >= PL330_MAX_LOOPS)
> +                       dev_dbg(dev, "loop_count1 overflow\n");
Again, the DMA API drivers will suffer just because someone didn't care
to generate microcode efficiently.
The microcode template for xfer takes only about 50 bytes and despite
having PL330_POOL_SIZE buffer, you have to drop xfer requests just because
the template is not properly designed.
My implementation is limited only by the microcode buffer size, which in turn
can be specified at startup by the DMA API driver.

> +       }
> +
> +       /* write instruction sets on buffer */
> +       inst_size += pl330_dmamov(buf + inst_size, RD_DAR, dest);
> +       inst_size += pl330_dmamov(buf + inst_size, RD_SAR, src);
> +       inst_size += pl330_dmamov(buf + inst_size, RD_CCR, control);
> +
> +       if (loop_count1) {
> +               inst_size += pl330_dmalp(buf + inst_size, loop_count1, LC_1);
> +               loop_start1 = inst_size;
> +       }
> +
> +       if (loop_count0) {
> +               inst_size += pl330_dmalp(buf + inst_size, loop_count0, LC_0);
> +               loop_start0 = inst_size;
> +       }
> +
> +       if (direction == DMA_TO_DEVICE) {
> +               struct pl330_dma_slave *dma_slave = pl330_ch->common.private;
> +               u8 periph = dma_slave->peri_num;
> +               inst_size += pl330_dmawfps(buf + inst_size, periph);
> +               inst_size += pl330_dmald(buf + inst_size);
> +               inst_size += pl330_dmastps(buf + inst_size, periph);
> +               inst_size += pl330_dmaflushp(buf + inst_size, periph);
> +       } else if (direction == DMA_FROM_DEVICE) {
> +               struct pl330_dma_slave *dma_slave = pl330_ch->common.private;
> +               u8 periph = dma_slave->peri_num;
> +               inst_size += pl330_dmawfps(buf + inst_size, periph);
> +               inst_size += pl330_dmaldps(buf + inst_size, periph);
> +               inst_size += pl330_dmast(buf + inst_size);
> +               inst_size += pl330_dmaflushp(buf + inst_size, periph);
> +       } else {
> +               inst_size += pl330_dmald(buf + inst_size);
> +               inst_size += pl330_dmarmb(buf + inst_size);
> +               inst_size += pl330_dmast(buf + inst_size);
> +               inst_size += pl330_dmawmb(buf + inst_size);
> +       }
> +
> +       if (loop_count0)
> +               inst_size += pl330_dmalpend(buf + inst_size,
> +                               inst_size - loop_start0, LC_0);
> +
> +       if (loop_count1)
> +               inst_size += pl330_dmalpend(buf + inst_size,
> +                               inst_size - loop_start1, LC_1);
> +
> +       if (loop_count0_rest) {
> +               inst_size += pl330_dmalp(buf + inst_size, loop_count0_rest - 1,
> +                               LC_0);
> +               loop_start0 = inst_size;
> +
> +               if (direction == DMA_TO_DEVICE) {
> +                       struct pl330_dma_slave *dma_slave =
> +                               pl330_ch->common.private;
> +                       u8 periph = dma_slave->peri_num;
> +                       inst_size += pl330_dmawfps(buf + inst_size, periph);
> +                       inst_size += pl330_dmald(buf + inst_size);
> +                       inst_size += pl330_dmastps(buf + inst_size, periph);
> +                       inst_size += pl330_dmaflushp(buf + inst_size, periph);
> +               } else if (direction == DMA_FROM_DEVICE) {
> +                       struct pl330_dma_slave *dma_slave =
> +                               pl330_ch->common.private;
> +                       u8 periph = dma_slave->peri_num;
> +                       inst_size += pl330_dmawfps(buf + inst_size, periph);
> +                       inst_size += pl330_dmaldps(buf + inst_size, periph);
> +                       inst_size += pl330_dmast(buf + inst_size);
> +                       inst_size += pl330_dmaflushp(buf + inst_size, periph);
> +               } else {
> +                       inst_size += pl330_dmald(buf + inst_size);
> +                       inst_size += pl330_dmarmb(buf + inst_size);
> +                       inst_size += pl330_dmast(buf + inst_size);
> +                       inst_size += pl330_dmawmb(buf + inst_size);
> +               }
> +
> +               inst_size += pl330_dmalpend(buf + inst_size,
> +                               inst_size - loop_start0, LC_0);
> +       }
> +
> +       inst_size += pl330_dmasev(buf + inst_size, pl330_ch->id);
> +       inst_size += pl330_dmaend(buf + inst_size);
> +
> +       return inst_size;
> +}
This instruction generation leaves no scope for Security permissions for xfers,
that is a feature of PL330.

[snip]

> +static void pl330_xfer_complete(struct pl330_chan *pl330_ch)
> +{
> +       struct pl330_desc *desc;
> +       dma_async_tx_callback callback;
> +       void *callback_param;
> +
> +       /* execute next desc */
> +       pl330_issue_pending(&pl330_ch->common);
> +
> +       if (list_empty(&pl330_ch->complete_desc))
> +               return;
> +
> +       desc = to_pl330_desc(pl330_ch->complete_desc.next);
> +       list_move_tail(&desc->desc_node, &pl330_ch->free_desc);
> +
> +       pl330_ch->completed = desc->async_tx.cookie;
> +
> +       callback = desc->async_tx.callback;
> +       callback_param = desc->async_tx.callback_param;
> +       if (callback)
> +               callback(callback_param);
> +}
> +
> +static void pl330_ch_tasklet(unsigned long data)
> +{
> +       struct pl330_chan *pl330_ch = (struct pl330_chan *)data;
> +       unsigned int val;
> +
> +       pl330_xfer_complete(pl330_ch);
> +
> +       /* enable channel interrupt */
> +       val = readl(pl330_ch->pl330_dev->reg_base + PL330_INTEN);
> +       val |= (1 << pl330_ch->id);
> +       writel(val, pl330_ch->pl330_dev->reg_base + PL330_INTEN);
> +}
> +
> +static irqreturn_t pl330_irq_handler(int irq, void *data)
> +{
> +       struct pl330_device *pl330_dev = data;
> +       struct pl330_chan *pl330_ch;
> +       unsigned int intstatus;
> +       unsigned int inten;
> +       int i;
> +
> +       intstatus = readl(pl330_dev->reg_base + PL330_INTSTATUS);
> +
> +       if (intstatus == 0)
> +               return IRQ_HANDLED;
> +
> +       inten = readl(pl330_dev->reg_base + PL330_INTEN);
> +       for (i = 0; i < PL330_MAX_CHANS; i++) {
> +               if (intstatus & (1 << i)) {
> +                       pl330_ch = &pl330_dev->pl330_ch[i];
> +                       writel(1 << i, pl330_dev->reg_base + PL330_INTCLR);
> +
> +                       /* disable channel interrupt */
> +                       inten &= ~(1 << i);
> +                       writel(inten, pl330_dev->reg_base + PL330_INTEN);
> +
> +                       tasklet_schedule(&pl330_ch->tasklet);
I think the DMA API already prohibits doing non-irq-context things(like enqueue)
in the callbacks, so why implement tasklets here?
This may still get you "audio working fine" with Samsung I2S controller,
but is likely to cause problems with more demanding peripherals like SPDIF
if they operate at best QOS(even 24bits/sample Stereo at 96000Hz) and has
shallow FIFO(8 samples deep and hence 84 usecs acceptable latency).
Remember that SPDIF usually goes with other system load like HDMI HD
playaback which only increases the interrupt latency.

Not to forget, the overall throughput hit taken by other dma clients,
like MMC over SPI that use 256/512 bytes DMA xfers, due to delayed
DMA-DONE notifications.

Also, using tasklet here may break any protocol that involves _time-bound_ ACK
via some register after the xfer has been done.

If some client needs to do sleepable-context stuff after DMA-Xfer-Done,
let that driver implement tasklet in it's callback rather than have every
client pay the price.

> +               }
> +       }
> +
> +       return IRQ_HANDLED;
> +}
> +

  [snip]

> +
> +static int __devinit pl330_probe(struct amba_device *adev, struct amba_id *id)
> +{
> +       struct pl330_device *pl330_dev;

  [snip]

> +
> +       for (i = 0; i < PL330_MAX_CHANS; i++) {
This whole code is designed around the assumption of every DMAC having
PL330_MAX_CHANS channels. That is dangerous, since PL330 is highly
configurable and some implementation may choose to implement less than
PL330_MAX_CHANS(i.e 8) channels.
As the PL330 spec says, most operations for non-existing channel result in
DMA Abort. Further, the IRQ handler assumes utopia and doesn't even
care to check
such conditions, as a result on non-s3c like implementations there are many
chances the system will just hang looping in DMA Abort irq or no irq at all
depending upon the cause.
Not to mention the unnecessary allocation for MAX possible resources, though
not very serious.

regards

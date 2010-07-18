Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756799Ab0GRRdP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jul 2010 13:33:15 -0400
Received: from exprod5og107.obsmtp.com ([64.18.0.184]:46728 "HELO
	exprod5og107.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756769Ab0GRRdM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jul 2010 13:33:12 -0400
From: Rupjyoti Sarmah <rsarmah@apm.com>
References: <201007061106.o66B631f013777@amcc.com> <4C41D174.2040907@ru.mvista.com>
In-Reply-To: <4C41D174.2040907@ru.mvista.com>
MIME-Version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: AcslyBGmKFSfJirnTXirJhcsHB6uFwA1vnbQ
Date: Sun, 18 Jul 2010 23:03:07 +0530
Message-ID: <0a24db24870a10fff89cfec07a179a78@mail.gmail.com>
Subject: RE: [PATCH v2]460EX on-chip SATA driver<resubmisison>
To: Sergei Shtylyov <sshtylyov@mvista.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, jgarzik@pobox.com,
        sr@denx.de, linuxppc-dev@ozlabs.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sergei,

Thanks for your suggestions.
I would look into them and submit a patch for style improvement some time
later.

Regards,
Rup


-----Original Message-----
From: Sergei Shtylyov [mailto:sshtylyov@mvista.com]
Sent: Saturday, July 17, 2010 9:21 PM
To: Rupjyoti Sarmah
Cc: linux-ide@vger.kernel.org; linux-kernel@vger.kernel.org;
rsarmah@apm.com; jgarzik@pobox.com; sr@denx.de; linuxppc-dev@ozlabs.org
Subject: Re: [PATCH v2]460EX on-chip SATA driver<resubmisison>

Hello.

Rupjyoti Sarmah wrote:

> This patch enables the on-chip DWC SATA controller of the AppliedMicro
processor 460EX.

    Too bad thius has already been applied but here's my (mostly
stylistic)
comments anyway:

> Signed-off-by: Rupjyoti Sarmah <rsarmah@appliedmicro.com>
> Signed-off-by: Mark Miesfeld <mmiesfeld@appliedmicro.com>
> Signed-off-by: Prodyut Hazarika <phazarika@appliedmicro.com>

[...]

> diff --git a/drivers/ata/sata_dwc_460ex.c b/drivers/ata/sata_dwc_460ex.c
> new file mode 100644
> index 0000000..ea24c1e
> --- /dev/null
> +++ b/drivers/ata/sata_dwc_460ex.c
> @@ -0,0 +1,1756 @@
> +/*
> + * drivers/ata/sata_dwc_460ex.c

    Filenames in the heading comments have long been frowned upon.

> +#ifdef CONFIG_SATA_DWC_DEBUG

    I don't see this option defined anywahere.

> +#define DEBUG
> +#endif
> +
> +#ifdef CONFIG_SATA_DWC_VDEBUG

    The same about this one.

> +#define VERBOSE_DEBUG
> +#define DEBUG_NCQ
> +#endif
[...]
> +/* SATA DMA driver Globals */
> +#define DMA_NUM_CHANS		1
> +#define DMA_NUM_CHAN_REGS	8
> +
> +/* SATA DMA Register definitions */
> +#define AHB_DMA_BRST_DFLT	64	/* 16 data items burst length*/

    Please put a space before */.

> +struct ahb_dma_regs {
> +	struct dma_chan_regs	chan_regs[DMA_NUM_CHAN_REGS];
> +	struct dma_interrupt_regs interrupt_raw;	/* Raw Interrupt
*/
> +	struct dma_interrupt_regs interrupt_status;	/* Interrupt
Status */
> +	struct dma_interrupt_regs interrupt_mask;	/* Interrupt Mask
*/
> +	struct dma_interrupt_regs interrupt_clear;	/* Interrupt Clear
*/
> +	struct dmareg		statusInt;	/* Interrupt combined*/

    No camelCase please, rename it to status_int.

> +#define	DMA_CTL_BLK_TS(size)	((size) & 0x000000FFF)	/* Blk
Transfer size */
> +#define DMA_CHANNEL(ch)		(0x00000001 << (ch))	/* Select
channel */
> +	/* Enable channel */
> +#define	DMA_ENABLE_CHAN(ch)	((0x00000001 << (ch)) |
\
> +				 ((0x000000001 << (ch)) << 8))
> +	/* Disable channel */
> +#define	DMA_DISABLE_CHAN(ch)	(0x00000000 | ((0x000000001 <<
(ch)) << 8))

    What's the point of OR'ing with zero?

> +/*
> + * Commonly used DWC SATA driver Macros
> + */
> +#define HSDEV_FROM_HOST(host)  ((struct sata_dwc_device *)\
> +					(host)->private_data)
> +#define HSDEV_FROM_AP(ap)  ((struct sata_dwc_device *)\
> +					(ap)->host->private_data)
> +#define HSDEVP_FROM_AP(ap)   ((struct sata_dwc_device_port *)\
> +					(ap)->private_data)
> +#define HSDEV_FROM_QC(qc)	((struct sata_dwc_device *)\
> +					(qc)->ap->host->private_data)
> +#define HSDEV_FROM_HSDEVP(p)	((struct sata_dwc_device *)\
> +						(hsdevp)->hsdev)

    Are you sure it's '(hsdevp)', not '(p)'?

> +struct sata_dwc_host_priv {
> +	void	__iomem	 *scr_addr_sstatus;
> +	u32	sata_dwc_sactive_issued ;
> +	u32	sata_dwc_sactive_queued ;

    Remove spaces befoer semicolons, please.

> +static void sata_dwc_tf_dump(struct ata_taskfile *tf)
> +{
> +	dev_vdbg(host_pvt.dwc_dev, "taskfile cmd: 0x%02x protocol: %s
flags:"
> +		"0x%lx device: %x\n", tf->command, ata_get_cmd_descript\

    There's no need to use \ outside macro defintions.

> +/*
> + * Function: get_burst_length_encode
> + * arguments: datalength: length in bytes of data
> + * returns value to be programmed in register corrresponding to data
length
> + * This value is effectively the log(base 2) of the length
> + */
> +static  int get_burst_length_encode(int datalength)
> +{
> +	int items = datalength >> 2;	/* div by 4 to get lword count */
> +
> +	if (items >= 64)
> +		return 5;
> +
> +	if (items >= 32)
> +		return 4;
> +
> +	if (items >= 16)
> +		return 3;
> +
> +	if (items >= 8)
> +		return 2;
> +
> +	if (items >= 4)
> +		return 1;
> +
> +	return 0;
> +}

    Hmm, there should be a function in the kernel to calculate 2^n order
from
size, something like get_count_order()...

> +/*
> + * Function: dma_dwc_interrupt
> + * arguments: irq, dev_id, pt_regs
> + * returns channel number if available else -1
> + * Interrupt Handler for DW AHB SATA DMA
> + */
> +static irqreturn_t dma_dwc_interrupt(int irq, void *hsdev_instance)
> +{
> +	int chan;
> +	u32 tfr_reg, err_reg;
> +	unsigned long flags;
> +	struct sata_dwc_device *hsdev =
> +		(struct sata_dwc_device *)hsdev_instance;
> +	struct ata_host *host = (struct ata_host *)hsdev->host;
> +	struct ata_port *ap;
> +	struct sata_dwc_device_port *hsdevp;
> +	u8 tag = 0;
> +	unsigned int port = 0;
> +
> +	spin_lock_irqsave(&host->lock, flags);
> +	ap = host->ports[port];
> +	hsdevp = HSDEVP_FROM_AP(ap);
> +	tag = ap->link.active_tag;
> +
> +	tfr_reg = in_le32(&(host_pvt.sata_dma_regs->interrupt_status.tfr\

    There's no need to use \ outside macro defintions.

> +			.low));
> +	err_reg =
in_le32(&(host_pvt.sata_dma_regs->interrupt_status.error\

    Same comment here...

> +	for (chan = 0; chan < DMA_NUM_CHANS; chan++) {
> +		/* Check for end-of-transfer interrupt. */
> +		if (tfr_reg & DMA_CHANNEL(chan)) {
> +			/*
> +			 * Each DMA command produces 2 interrupts.  Only
> +			 * complete the command after both interrupts have
been
> +			 * seen. (See sata_dwc_isr())
> +			 */
> +			host_pvt.dma_interrupt_count++;
> +			sata_dwc_clear_dmacr(hsdevp, tag);
> +
> +			if (hsdevp->dma_pending[tag] ==
> +			    SATA_DWC_DMA_PENDING_NONE) {
> +				dev_err(ap->dev, "DMA not pending
eot=0x%08x "
> +					"err=0x%08x tag=0x%02x
pending=%d\n",
> +					tfr_reg, err_reg, tag,
> +					hsdevp->dma_pending[tag]);
> +			}
> +
> +			if ((host_pvt.dma_interrupt_count % 2) == 0)

    Prens around % operation not necessary.

> +				sata_dwc_dma_xfer_complete(ap, 1);
> +
> +			/* Clear the interrupt */
> +
out_le32(&(host_pvt.sata_dma_regs->interrupt_clear\

    \ not needed.

> +			/* Clear the interrupt. */
> +
out_le32(&(host_pvt.sata_dma_regs->interrupt_clear\

    \ not needed.

> +/*
> + * Function: map_sg_to_lli
> + * The Synopsis driver has a comment proposing that better performance
> + * is possible by only enabling interrupts on the last item in the
linked list.
> + * However, it seems that could be a problem if an error happened on
one of the
> + * first items.  The transfer would halt, but no error interrupt would
occur.
> + * Currently this function sets interrupts enabled for each linked list
item:
> + * DMA_CTL_INT_EN.
> + */
> +static int map_sg_to_lli(struct scatterlist *sg, int num_elems,
> +			struct lli *lli, dma_addr_t dma_lli,
> +			void __iomem *dmadr_addr, int dir)
> +{
[...]
> +			/* Program the LLI CTL high register */
> +			lli[idx].ctl.high = cpu_to_le32(DMA_CTL_BLK_TS\

    \ not needed.

> +						(len / 4));
> +
> +			/* Program the next pointer.  The next pointer
must be
> +			 * the physical address, not the virtual address.
> +			 */
> +			next_llp = (dma_lli + ((idx + 1) * sizeof(struct \

    Same here...

> +static int dma_dwc_xfer_setup(struct scatterlist *sg, int num_elems,
> +			      struct lli *lli, dma_addr_t dma_lli,
> +			      void __iomem *addr, int dir)
> +{
> +	int dma_ch;
> +	int num_lli;

    There should be an empty line here.

> +/*
> + * Function: dma_dwc_init
> + * arguments: hsdev
> + * returns status
> + * This function initializes the SATA DMA driver
> + */
> +static int dma_dwc_init(struct sata_dwc_device *hsdev, int irq)
> +{
> +	int err;
> +
> +	err = dma_request_interrupts(hsdev, irq);

    Could be initilaizer...

> +	dev_notice(host_pvt.dwc_dev, "DMA initialized\n");
> +	dev_dbg(host_pvt.dwc_dev, "SATA DMA registers=0x%p\n", host_pvt.\

    \ not needed.

> +static u32 core_scr_read(unsigned int scr)
> +{
> +	return in_le32((void __iomem *)(host_pvt.scr_addr_sstatus) +\

    Not needed.

> +static void clear_serror(void)
> +{
> +	u32 val;

    Empty line needed here.

> +	val = core_scr_read(SCR_ERROR);

    This could be an initilaizer.

> +/* See ahci.c */
> +static void sata_dwc_error_intr(struct ata_port *ap,
> +				struct sata_dwc_device *hsdev, uint intpr)
> +{
> +	struct sata_dwc_device_port *hsdevp = HSDEVP_FROM_AP(ap);
> +	struct ata_eh_info *ehi = &ap->link.eh_info;
> +	unsigned int err_mask = 0, action = 0;
> +	struct ata_queued_cmd *qc;
> +	u32 serror;
> +	u8 status, tag;
> +	u32 err_reg;
> +
> +	ata_ehi_clear_desc(ehi);
> +
> +	serror = core_scr_read(SCR_ERROR);
> +	status = ap->ops->sff_check_status(ap);

    Why not call ata_sff_check_status() directly?

> +	err_reg =
in_le32(&(host_pvt.sata_dma_regs->interrupt_status.error.\

    \ not neeeded.

> +/*
> + * Function : sata_dwc_isr
> + * arguments : irq, void *dev_instance, struct pt_regs *regs
> + * Return value : irqreturn_t - status of IRQ
> + * This Interrupt handler called via port ops registered function.
> + * .irq_handler = sata_dwc_isr
> + */
> +static irqreturn_t sata_dwc_isr(int irq, void *dev_instance)
> +{
> +	struct ata_host *host = (struct ata_host *)dev_instance;
> +	struct sata_dwc_device *hsdev = HSDEV_FROM_HOST(host);
> +	struct ata_port *ap;
> +	struct ata_queued_cmd *qc;
> +	unsigned long flags;
> +	u8 status, tag;
> +	int handled, num_processed, port = 0;
> +	uint intpr, sactive, sactive2, tag_mask;
> +	struct sata_dwc_device_port *hsdevp;
> +	host_pvt.sata_dwc_sactive_issued = 0;
[...]
> +	sactive = core_scr_read(SCR_ACTIVE);
> +	tag_mask = (host_pvt.sata_dwc_sactive_issued | sactive) ^ sactive;

    Isn't it the same as 'host_pvt.sata_dwc_sactive_issued & ~sactive'?

> +	/* If no sactive issued and tag_mask is zero then this is not NCQ
*/
> +	if (host_pvt.sata_dwc_sactive_issued == 0 && tag_mask == 0) {
> +		if (ap->link.active_tag == ATA_TAG_POISON)
> +			tag = 0;
> +		else
> +			tag = ap->link.active_tag;
> +		qc = ata_qc_from_tag(ap, tag);
> +
> +		/* DEV interrupt w/ no active qc? */
> +		if (unlikely(!qc || (qc->tf.flags & ATA_TFLAG_POLLING))) {
> +			dev_err(ap->dev, "%s interrupt with no active qc "
> +				"qc=%p\n", __func__, qc);
> +			ap->ops->sff_check_status(ap);

    Call ata_sff_check_status() directly...

> +			handled = 1;
> +			goto DONE;
> +		}
> +		status = ap->ops->sff_check_status(ap);

    Here too...

> +DRVSTILLBUSY:
> +		if (ata_is_dma(qc->tf.protocol)) {
> +			/*
> +			 * Each DMA transaction produces 2 interrupts. The
DMAC
> +			 * transfer complete interrupt and the SATA
controller
> +			 * operation done interrupt. The command should be
> +			 * completed only after both interrupts are seen.
> +			 */
> +			host_pvt.dma_interrupt_count++;
> +			if (hsdevp->dma_pending[tag] == \
> +					SATA_DWC_DMA_PENDING_NONE) {
> +				dev_err(ap->dev, "%s: DMA not pending "
> +					"intpr=0x%08x status=0x%08x
pending"
> +					"=%d\n", __func__, intpr, status,
> +					hsdevp->dma_pending[tag]);
> +			}

    Curly brace not needed here. I assume you haven't run the patch thru
scripts/checkpatch.pl?

> +	/*
> +	 * This is a NCQ command. At this point we need to figure out for
which
> +	 * tags we have gotten a completion interrupt.  One interrupt may
serve
> +	 * as completion for more than one operation when commands are
queued
> +	 * (NCQ).  We need to process each completed command.
> +	 */
> +
> +	 /* process completed commands */
> +	sactive = core_scr_read(SCR_ACTIVE);
> +	tag_mask = (host_pvt.sata_dwc_sactive_issued | sactive) ^ sactive;

    Isn't it the same as 'host_pvt.sata_dwc_sactive_issued & ~sactive'?

> +	if (sactive != 0 || (host_pvt.sata_dwc_sactive_issued) > 1 || \

    Useless parens around 'host_pvt.sata_dwc_sactive_issued' + \ not
needed.

> +							tag_mask > 1) {
> +		dev_dbg(ap->dev, "%s NCQ:sactive=0x%08x
sactive_issued=0x%08x"
> +			"tag_mask=0x%08x\n", __func__, sactive,
> +			host_pvt.sata_dwc_sactive_issued, tag_mask);
> +	}

    Curly braces not needed here.

> +	if ((tag_mask | (host_pvt.sata_dwc_sactive_issued)) != \
> +
(host_pvt.sata_dwc_sactive_issued)) {

    Useless parens around 'host_pvt.sata_dwc_sactive_issued'.

> +		dev_warn(ap->dev, "Bad tag mask?  sactive=0x%08x "
> +			 "(host_pvt.sata_dwc_sactive_issued)=0x%08x
tag_mask"
> +			 "=0x%08x\n", sactive,
host_pvt.sata_dwc_sactive_issued,
> +			  tag_mask);
> +	}

    Curly braces not needed around single statement.

> +
> +	/* read just to clear ... not bad if currently still busy */
> +	status = ap->ops->sff_check_status(ap);

    Call ata_sff_check_status() directly.

> +	dev_dbg(ap->dev, "%s ATA status register=0x%x\n", __func__,
status);
> +
> +	tag = 0;
> +	num_processed = 0;
> +	while (tag_mask) {
> +		num_processed++;
> +		while (!(tag_mask & 0x00000001)) {
> +			tag++;
> +			tag_mask <<= 1;
> +		}
> +
> +		tag_mask &= (~0x00000001);

    Useless parens.

> +		/* Process completed command */
> +		dev_dbg(ap->dev, "%s NCQ command, protocol: %s\n",
__func__,
> +			ata_get_cmd_descript(qc->tf.protocol));
> +		if (ata_is_dma(qc->tf.protocol)) {
> +			host_pvt.dma_interrupt_count++;
> +			if (hsdevp->dma_pending[tag] == \

    \ not needed.

> +					SATA_DWC_DMA_PENDING_NONE)
> +				dev_warn(ap->dev, "%s: DMA not
pending?\n",
> +					__func__);
> +			if ((host_pvt.dma_interrupt_count % 2) == 0)

    Parens not needed around % operation.

> +				sata_dwc_dma_xfer_complete(ap, 1);
> +		} else {
> +		if (unlikely(sata_dwc_qc_complete(ap, qc, 1)))
> +				goto STILLBUSY;
> +		}

    You should write:

		} else if (unlikely(sata_dwc_qc_complete(ap, qc, 1))) {
			goto STILLBUSY;
		}

> +	/*
> +	 * Check to see if any commands completed while we were processing
our
> +	 * initial set of completed commands (read status clears
interrupts,
> +	 * so we might miss a completed command interrupt if one came in
while
> +	 * we were processing --we read status as part of processing a
completed
> +	 * command).
> +	 */
> +	sactive2 = core_scr_read(SCR_ACTIVE);
> +	if (sactive2 != sactive) {

    {} not needed here.

> +static void sata_dwc_dma_xfer_complete(struct ata_port *ap, u32
check_status)
> +{
> +	struct ata_queued_cmd *qc;
> +	struct sata_dwc_device_port *hsdevp = HSDEVP_FROM_AP(ap);
> +	struct sata_dwc_device *hsdev = HSDEV_FROM_AP(ap);
> +	u8 tag = 0;
> +
> +	tag = ap->link.active_tag;
> +	qc = ata_qc_from_tag(ap, tag);
> +	if (!qc) {
> +		dev_err(ap->dev, "failed to get qc");
> +		return;
> +	}
> +
> +#ifdef DEBUG_NCQ
> +	if (tag > 0) {

    Curly braces not needed around single statement.

> +		dev_info(ap->dev, "%s tag=%u cmd=0x%02x dma dir=%s
proto=%s "
> +			 "dmacr=0x%08x\n", __func__, qc->tag,
qc->tf.command,
> +			 ata_get_cmd_descript(qc->dma_dir),
> +			 ata_get_cmd_descript(qc->tf.protocol),
> +			 in_le32(&(hsdev->sata_dwc_regs->dmacr)));
> +	}
> +#endif
> +
> +	if (ata_is_dma(qc->tf.protocol)) {
> +		if (hsdevp->dma_pending[tag] == SATA_DWC_DMA_PENDING_NONE)
{

    Curly braces not needed around single statement.

> +static int sata_dwc_qc_complete(struct ata_port *ap, struct
ata_queued_cmd *qc,
> +				u32 check_status)
> +{
> +	u8 status = 0;
> +	u32 mask = 0x0;
> +	u8 tag = qc->tag;
> +	struct sata_dwc_device_port *hsdevp = HSDEVP_FROM_AP(ap);

    There should be an empty line here.

> +	host_pvt.sata_dwc_sactive_queued = 0;
> +	dev_dbg(ap->dev, "%s checkstatus? %x\n", __func__, check_status);
> +
> +	if (hsdevp->dma_pending[tag] == SATA_DWC_DMA_PENDING_TX)
> +		dev_err(ap->dev, "TX DMA PENDING\n");
> +	else if (hsdevp->dma_pending[tag] == SATA_DWC_DMA_PENDING_RX)
> +		dev_err(ap->dev, "RX DMA PENDING\n");
> +	dev_dbg(ap->dev, "QC complete cmd=0x%02x status=0x%02x ata%u:"
> +		" protocol=%d\n", qc->tf.command, status, ap->print_id,
> +		 qc->tf.protocol);
> +
> +	/* clear active bit */
> +	mask = (~(qcmd_tag_to_mask(tag)));

    Useless parens.

> +	host_pvt.sata_dwc_sactive_queued =
(host_pvt.sata_dwc_sactive_queued) \
> +						& mask;
> +	host_pvt.sata_dwc_sactive_issued =
(host_pvt.sata_dwc_sactive_issued) \

    \ not needed.

> +static void sata_dwc_port_stop(struct ata_port *ap)
> +{
> +	int i;
> +	struct sata_dwc_device *hsdev = HSDEV_FROM_AP(ap);
> +	struct sata_dwc_device_port *hsdevp = HSDEVP_FROM_AP(ap);
> +
> +	dev_dbg(ap->dev, "%s: ap->id = %d\n", __func__, ap->print_id);
> +
> +	if (hsdevp && hsdev) {
> +		/* deallocate LLI table */
> +		for (i = 0; i < SATA_DWC_QCMD_MAX; i++) {

    Curly braces not needed.

> +			dma_free_coherent(ap->host->dev,
> +					  SATA_DWC_DMAC_LLI_TBL_SZ,
> +					 hsdevp->llit[i],
hsdevp->llit_dma[i]);

    Should be indented on the same level as above line

> +static void sata_dwc_bmdma_setup(struct ata_queued_cmd *qc)
> +{
> +	u8 tag = qc->tag;
> +
> +	if (ata_is_ncq(qc->tf.protocol)) {
> +		dev_dbg(qc->ap->dev, "%s: ap->link.sactive=0x%08x
tag=%d\n",
> +			__func__, qc->ap->link.sactive, tag);
> +	} else {
> +		tag = 0;
> +	}

    Curly braces not needed around single statements.

> +static void sata_dwc_bmdma_start_by_tag(struct ata_queued_cmd *qc, u8
tag)
> +{
> +	int start_dma;
> +	u32 reg, dma_chan;
> +	struct sata_dwc_device *hsdev = HSDEV_FROM_QC(qc);
> +	struct ata_port *ap = qc->ap;
> +	struct sata_dwc_device_port *hsdevp = HSDEVP_FROM_AP(ap);
> +	int dir = qc->dma_dir;

    There should be an empty line here.

> +	if (start_dma) {
> +		reg = core_scr_read(SCR_ERROR);
> +		if (reg & SATA_DWC_SERROR_ERR_BITS) {

    Curly braces not needed here.

> +static void sata_dwc_bmdma_start(struct ata_queued_cmd *qc)
> +{
> +	u8 tag = qc->tag;
> +
> +	if (ata_is_ncq(qc->tf.protocol)) {
> +		dev_dbg(qc->ap->dev, "%s: ap->link.sactive=0x%08x
tag=%d\n",
> +			__func__, qc->ap->link.sactive, tag);
> +	} else {
> +		tag = 0;
> +	}

    Curly braces not needed around single statements.

> +/*
> + * Function : sata_dwc_qc_prep_by_tag
> + * arguments : ata_queued_cmd *qc, u8 tag
> + * Return value : None
> + * qc_prep for a particular queued command based on tag
> + */
> +static void sata_dwc_qc_prep_by_tag(struct ata_queued_cmd *qc, u8 tag)
> +{
[...]
> +	dma_chan = dma_dwc_xfer_setup(sg, qc->n_elem, hsdevp->llit[tag],
> +				      hsdevp->llit_dma[tag],
> +				      (void
*__iomem)(&hsdev->sata_dwc_regs->\

    \ not needed.

> +static unsigned int sata_dwc_qc_issue(struct ata_queued_cmd *qc)
> +{
> +	u32 sactive;
> +	u8 tag = qc->tag;
> +	struct ata_port *ap = qc->ap;
[...]
> +
> +	if (ata_is_ncq(qc->tf.protocol)) {
> +		sactive = core_scr_read(SCR_ACTIVE);
> +		sactive |= (0x00000001 << tag);

    Parens not needed.

> +		core_scr_write(SCR_ACTIVE, sactive);
> +
> +		dev_dbg(qc->ap->dev, "%s: tag=%d ap->link.sactive = 0x%08x
"
> +			"sactive=0x%08x\n", __func__, tag,
qc->ap->link.sactive,
> +			sactive);
> +
> +		ap->ops->sff_tf_load(ap, &qc->tf);

    Why not call ata_sff_tf_load() directly?

> +/*
> + * Function : sata_dwc_qc_prep
> + * arguments : ata_queued_cmd *qc
> + * Return value : None
> + * qc_prep for a particular queued command
> + */
> +
> +static void sata_dwc_qc_prep(struct ata_queued_cmd *qc)
> +{
> +	if ((qc->dma_dir == DMA_NONE) || (qc->tf.protocol ==
ATA_PROT_PIO))

    Parens not needed arounf == operation.

> +		return;
> +
> +#ifdef DEBUG_NCQ
> +	if (qc->tag > 0)
> +		dev_info(qc->ap->dev, "%s: qc->tag=%d
ap->active_tag=0x%08x\n",
> +			 __func__, tag, qc->ap->link.active_tag);
> +
> +	return ;

    Remove spade before semicolon please.

> +static const struct ata_port_info sata_dwc_port_info[] = {
> +	{
> +		.flags		= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY |
> +				  ATA_FLAG_MMIO | ATA_FLAG_NCQ,
> +		.pio_mask	= 0x1f,	/* pio 0-4 */

    Replace 0x1f with ATA_PIO4, please.

> +static int sata_dwc_probe(struct of_device *ofdev,
> +			const struct of_device_id *match)

    Shouldn't this function be '__init' or '__devinit'?

> +{
> +	struct sata_dwc_device *hsdev;
> +	u32 idr, versionr;
> +	char *ver = (char *)&versionr;
> +	u8 *base = NULL;
> +	int err = 0;
> +	int irq, rc;
> +	struct ata_host *host;
> +	struct ata_port_info pi = sata_dwc_port_info[0];
> +	const struct ata_port_info *ppi[] = { &pi, NULL };
> +
> +	/* Allocate DWC SATA device */
> +	hsdev = kmalloc(sizeof(*hsdev), GFP_KERNEL);
> +	if (hsdev == NULL) {
> +		dev_err(&ofdev->dev, "kmalloc failed for hsdev\n");
> +		err = -ENOMEM;
> +		goto error_out;
> +	}
> +	memset(hsdev, 0, sizeof(*hsdev));

    Use kzalloc() instead iof kmalloc()/memset().

> +	/* Get physical SATA DMA register base address */
> +	host_pvt.sata_dma_regs = of_iomap(ofdev->dev.of_node, 1);
> +	if (!(host_pvt.sata_dma_regs)) {

    Parens not needed around 'host_pvt.sata_dma_regs'.

> +	/*
> +	 * Now, register with libATA core, this will also initiate the
> +	 * device discovery process, invoking our port_start() handler &
> +	 * error_handler() to execute a dummy Softreset EH session
> +	 */
> +	rc = ata_host_activate(host, irq, sata_dwc_isr, 0, &sata_dwc_sht);
> +

    I think that empty line here is not needed.

> +	if (rc != 0)
> +		dev_err(&ofdev->dev, "failed to activate host");
> +
> +	dev_set_drvdata(&ofdev->dev, host);
> +	return 0;
> +
> +error_out:
> +	/* Free SATA DMA resources */
> +	dma_dwc_exit(hsdev);
> +
> +	if (base)
> +		iounmap(base);

    What about freeing 'hsdev' and 'host' and unmapping
'host_pvt.sata_dma_regs'? And does iounmap() really pair with of_iomap()?

> +static int sata_dwc_remove(struct of_device *ofdev)

    Shouldn't this be '__exit' or '__devexit'?

> +{
> +	struct device *dev = &ofdev->dev;
> +	struct ata_host *host = dev_get_drvdata(dev);
> +	struct sata_dwc_device *hsdev = host->private_data;
> +
> +	ata_host_detach(host);
> +	dev_set_drvdata(dev, NULL);
> +
> +	/* Free SATA DMA resources */
> +	dma_dwc_exit(hsdev);
> +
> +	iounmap(hsdev->reg_base);

    What about unmapping 'host_pvt.sata_dma_regs'?

> +	kfree(hsdev);
> +	kfree(host);

    Does kfree() really pair with ata_host_alloc_pinfo()?

MBR, Sergei

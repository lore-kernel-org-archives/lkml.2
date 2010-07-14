Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753158Ab0GND6M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 23:58:12 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:34994 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121Ab0GND6H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 23:58:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=hIFlnYEQm2dv0OnTH4EMwzg/qeYWA/lSyrSxt23yixovhQBvpCsnhqr9t6bcl+ux6V
         HiQH0dsoFCqNt8FpQ4lBR/EShwNQKvXyWpR3JKNyr2bKEP9/lcFdCB0yWbio5gsiSaew
         mXwhKCFKIcap5YNSr2YX9czJPXRBlN/hxDdTY=
MIME-Version: 1.0
In-Reply-To: <1260977698-4076-1-git-send-email-Vishnu@freescale.com>
References: <1260977698-4076-1-git-send-email-Vishnu@freescale.com>
Date: Wed, 14 Jul 2010 11:58:00 +0800
Message-ID: <AANLkTinfOy_oJkX99Jqz2uJPLSN-goVqAl7hHv5u2FZN@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] Crypto: Talitos: Support for Async_tx XOR offload
From: hank peng <pengxihan@gmail.com>
To: Vishnu Suresh <Vishnu@freescale.com>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, dan.j.williams@intel.com,
        linux-crypto@vger.kernel.org, herbert@gondor.hengli.com.au,
        B04825@freescale.com, R58472@freescale.com,
        Kim Phillips <kim.phillips@freescale.com>,
        Dipen Dudhat <Dipen.Dudhat@freescale.com>,
        Maneesh Gupta <Maneesh.Gupta@freescale.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi:
I used your patch and test it on MPC8548 board. Today, I found a
problem when doing raid5 recovering.

talitos e0030000.crypto: master data transfer error
talitos e0030000.crypto: xor operation: talitos error -22
------------[ cut here ]------------
Kernel BUG at c02dcb6c [verbose debug info unavailable]
Oops: Exception in kernel mode, sig: 5 [#1]
MPC85xx CDS
Modules linked in: iscsi_trgt
NIP: c02dcb6c LR: c02dcb6c CTR: c023e7a8
REGS: e8b8d820 TRAP: 0700   Not tainted  (2.6.31.6)
MSR: 00029000 <EE,ME,CE>  CR: 22008022  XER: 20000000
TASK = ef8cb2e0[1897] 'md2_raid5' THREAD: e8b8c000
GPR00: c02dcb6c e8b8d8d0 ef8cb2e0 00000040 00007c99 ffffffff c023bccc 00007c5f
GPR08: c04a5c60 c049b5fc 00007c99 00004000 80008022 00000000 3fff5700 c3374754
GPR16: c337474c 00000000 00000000 ffffffea 00000001 00000000 000186a0 00000000
GPR24: ffffffea ffffffea ef81f850 0000000c 00029000 ffffffea ef81f850 efb1d580
NIP [c02dcb6c] talitos_release_xor+0xfc/0x104
LR [c02dcb6c] talitos_release_xor+0xfc/0x104
Call Trace:
[e8b8d8d0] [c02dcb6c] talitos_release_xor+0xfc/0x104 (unreliable)
[e8b8d8f0] [c02db928] flush_channel+0x11c/0x178
[e8b8d920] [c02dd344] talitos_interrupt+0x320/0x9e8
[e8b8d970] [c0060b3c] handle_IRQ_event+0x5c/0x140
[e8b8d990] [c006280c] handle_fasteoi_irq+0x68/0x118
[e8b8d9a0] [c0004f08] do_IRQ+0x94/0xb0
[e8b8d9c0] [c000fe00] ret_from_except+0x0/0x18
[e8b8da80] [c02b47a0] release_stripe+0x24/0x3c
[e8b8da90] [c02ba4ec] raid5_end_read_request+0x160/0x3f8
[e8b8dae0] [c00ba36c] bio_endio+0x48/0x6c
[e8b8daf0] [c01f80e0] req_bio_endio+0xa4/0x128
[e8b8db10] [c01f81f0] blk_update_request+0x8c/0x43c
[e8b8db40] [c01f85c0] blk_update_bidi_request+0x20/0x88
[e8b8db60] [c01f92c4] blk_end_bidi_request+0x1c/0x58
[e8b8db80] [c01f9314] blk_end_request+0x14/0x24
[e8b8db90] [c025ece0] scsi_io_completion+0x8c/0x4ac
[e8b8dbd0] [c0257fd0] scsi_finish_command+0xd0/0xf4
[e8b8dbf0] [c025f1c8] scsi_softirq_done+0xc8/0x150
[e8b8dc10] [c01fe114] blk_done_softirq+0x80/0xa0
[e8b8dc30] [c003a0d8] __do_softirq+0xa8/0x128
[e8b8dc70] [c0004e70] do_softirq+0x54/0x58
[e8b8dc80] [c0039f4c] irq_exit+0x94/0x98
[e8b8dc90] [c0004f0c] do_IRQ+0x98/0xb0
[e8b8dcb0] [c000fe00] ret_from_except+0x0/0x18
[e8b8dd70] [c00679c8] mempool_alloc_slab+0x1c/0x2c
[e8b8ddb0] [c02b6814] ops_run_io+0x1ac/0x2b8
[e8b8ddf0] [c02b93e4] handle_stripe5+0xa80/0x15c0
[e8b8de70] [c02bb408] handle_stripe+0x34/0x12d4
[e8b8df10] [c02bc8ec] raid5d+0x244/0x458
[e8b8df70] [c02c9624] md_thread+0x5c/0x124
[e8b8dfc0] [c004ab24] kthread+0x78/0x7c
[e8b8dff0] [c000f52c] kernel_thread+0x4c/0x68
Instruction dump:
bb61000c 38210020 7c0803a6 4bffefac 4bf63bc9 80be0008 7c641b78 3c60c042
7fa6eb78 38631ccc 4cc63182 4bd58b9d <0fe00000> 48000000 9421ffd0 7c0802a6
Kernel panic - not syncing: Fatal exception in interrupt
Rebooting in 1 seconds..
------------[ cut here ]------------
Badness at c0223124 [verbose debug info unavailable]
NIP: c0223124 LR: c0223308 CTR: 00000000
REGS: e8b8d580 TRAP: 0700   Tainted: G      D     (2.6.31.6)
MSR: 00021000 <ME,CE>  CR: 82008088  XER: 20000000
TASK = ef8cb2e0[1897] 'md2_raid5' THREAD: e8b8c000
GPR00: 00000001 e8b8d630 ef8cb2e0 e84f1d60 00000000 e84f1d60 e84f1d7c c04a1364
GPR08: c04a5c60 e8b8c000 0000873b e8b8d650 82008088 00000000 3fff5700 c3374754
GPR16: c337474c 00000000 00000000 ffffffea 00000001 00000000 000186a0 00000000
GPR24: ffffffea ffffffea 00000000 ffffffff ffffffff 00000000 00001106 e84f1d60
NIP [c0223124] pci_get_dev_by_id+0x34/0x98
LR [c0223308] pci_get_subsys+0x64/0xa4
Call Trace:
[e8b8d630] [c021e378] no_pci_devices+0x34/0x50 (unreliable)
[e8b8d650] [c0223308] pci_get_subsys+0x64/0xa4
[e8b8d670] [c0017be0] mpc85xx_cds_restart+0x24/0x90
[e8b8d690] [c000e7d0] machine_restart+0x34/0x4c
[e8b8d6a0] [c00447e0] emergency_restart+0x14/0x24
[e8b8d6b0] [c003473c] panic+0x118/0x158
[e8b8d700] [c000cf24] die+0x160/0x16c
[e8b8d720] [c000d1b0] _exception+0x12c/0x154
[e8b8d810] [c000fdb4] ret_from_except_full+0x0/0x4c
[e8b8d8d0] [c02dcb6c] talitos_release_xor+0xfc/0x104
[e8b8d8f0] [c02db928] flush_channel+0x11c/0x178
[e8b8d920] [c02dd344] talitos_interrupt+0x320/0x9e8
[e8b8d970] [c0060b3c] handle_IRQ_event+0x5c/0x140
[e8b8d990] [c006280c] handle_fasteoi_irq+0x68/0x118
[e8b8d9a0] [c0004f08] do_IRQ+0x94/0xb0
[e8b8d9c0] [c000fe00] ret_from_except+0x0/0x18
[e8b8da80] [c02b47a0] release_stripe+0x24/0x3c
[e8b8da90] [c02ba4ec] raid5_end_read_request+0x160/0x3f8
[e8b8dae0] [c00ba36c] bio_endio+0x48/0x6c
[e8b8daf0] [c01f80e0] req_bio_endio+0xa4/0x128
[e8b8db10] [c01f81f0] blk_update_request+0x8c/0x43c
[e8b8db40] [c01f85c0] blk_update_bidi_request+0x20/0x88
[e8b8db60] [c01f92c4] blk_end_bidi_request+0x1c/0x58
[e8b8db80] [c01f9314] blk_end_request+0x14/0x24
[e8b8db90] [c025ece0] scsi_io_completion+0x8c/0x4ac
[e8b8dbd0] [c0257fd0] scsi_finish_command+0xd0/0xf4
[e8b8dbf0] [c025f1c8] scsi_softirq_done+0xc8/0x150
[e8b8dc10] [c01fe114] blk_done_softirq+0x80/0xa0
[e8b8dc30] [c003a0d8] __do_softirq+0xa8/0x128
[e8b8dc70] [c0004e70] do_softirq+0x54/0x58
[e8b8dc80] [c0039f4c] irq_exit+0x94/0x98
[e8b8dc90] [c0004f0c] do_IRQ+0x98/0xb0
[e8b8dcb0] [c000fe00] ret_from_except+0x0/0x18
[e8b8dd70] [c00679c8] mempool_alloc_slab+0x1c/0x2c
[e8b8ddb0] [c02b6814] ops_run_io+0x1ac/0x2b8
[e8b8ddf0] [c02b93e4] handle_stripe5+0xa80/0x15c0
[e8b8de70] [c02bb408] handle_stripe+0x34/0x12d4
[e8b8df10] [c02bc8ec] raid5d+0x244/0x458
[e8b8df70] [c02c9624] md_thread+0x5c/0x124
[e8b8dfc0] [c004ab24] kthread+0x78/0x7c
[e8b8dff0] [c000f52c] kernel_thread+0x4c/0x68
Instruction dump:
7c0802a6 7d800026 7c651b78 bf810010 54290024 90010024 7c9d2378 9181000c
8009000c 5400016e 7c0000d0 54000ffe <0f000000> 3b800000 2e040000 3cc0c022


This oops is invoked by the following code:

static void talitos_release_xor(struct device *dev, struct talitos_desc *hwdesc,
                               void *context, int error)
{
       struct talitos_xor_desc *desc = context;
       struct talitos_xor_chan *xor_chan;
       dma_async_tx_callback callback;
       void *callback_param;

       if (unlikely(error)) {
               dev_err(dev, "xor operation: talitos error %d\n", error);
               BUG();
<-----------------------------------------------------------------
here
       }

I wonder here why a tailitos error occured, BUG is invoked? I think we
can do something to error recovery other than invoking BUG.

2009/12/16 Vishnu Suresh <Vishnu@freescale.com>:
> Expose Talitos's XOR functionality to be used for
> RAID Parity calculation via the Async_tx layer.
>
> Known Issue:
> When used with fsldma, random crashes are observed
> on some platforms. Hence, inter-operability with fsldma
> is currently disabled
>
> Thanks to Surender Kumar and Lee Nipper for their help in
> realising this driver
>
> Signed-off-by: Kim Phillips <kim.phillips@freescale.com>
> Signed-off-by: Dipen Dudhat <Dipen.Dudhat@freescale.com>
> Signed-off-by: Maneesh Gupta <Maneesh.Gupta@freescale.com>
> Signed-off-by: Vishnu Suresh <Vishnu@freescale.com>
> ---
> Changes with respect to v1 as per comments received
> o. Rebased to linux-next as of 20091216
> o. The selection is based exclusive of fsldma
> o. Intoduced a new Kernel Configuration variable
>   *. This enables selecting the Cryptographic functionality
>      of Talitos along with fsldma.
>   *. Disables the XOR parity calculation offload, if fsldma enabled
>      either as kernel in-built or as a module
>   *. Once the inter-operability with fsldma is resolved, this option
>      can be removed
>
>  drivers/crypto/Kconfig   |    9 +
>  drivers/crypto/talitos.c |  402 +++++++++++++++++++++++++++++++++++++++++++++-
>  drivers/crypto/talitos.h |    2 +
>  3 files changed, 412 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
> index b08403d..f8a6376 100644
> --- a/drivers/crypto/Kconfig
> +++ b/drivers/crypto/Kconfig
> @@ -203,6 +203,15 @@ config CRYPTO_DEV_TALITOS
>          To compile this driver as a module, choose M here: the module
>          will be called talitos.
>
> +config CRYPTO_DEV_TALITOS_RAIDXOR
> +       bool "Talitos RAID5 XOR Calculation Offload"
> +       select DMA_ENGINE
> +       depends on CRYPTO_DEV_TALITOS
> +       depends on FSL_DMA=n
> +       help
> +         Say 'Y' here to use the Freescale Security Engine (SEC) to
> +         offload RAID XOR parity Calculation
> +
>  config CRYPTO_DEV_IXP4XX
>        tristate "Driver for IXP4xx crypto hardware acceleration"
>        depends on ARCH_IXP4XX
> diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
> index c47ffe8..e63b25a 100644
> --- a/drivers/crypto/talitos.c
> +++ b/drivers/crypto/talitos.c
> @@ -1,7 +1,7 @@
>  /*
>  * talitos - Freescale Integrated Security Engine (SEC) device driver
>  *
> - * Copyright (c) 2008 Freescale Semiconductor, Inc.
> + * Copyright (c) 2008-2009 Freescale Semiconductor, Inc.
>  *
>  * Scatterlist Crypto API glue code copied from files with the following:
>  * Copyright (c) 2006-2007 Herbert Xu <herbert@gondor.apana.org.au>
> @@ -37,6 +37,8 @@
>  #include <linux/io.h>
>  #include <linux/spinlock.h>
>  #include <linux/rtnetlink.h>
> +#include <linux/dmaengine.h>
> +#include <linux/raid/xor.h>
>
>  #include <crypto/algapi.h>
>  #include <crypto/aes.h>
> @@ -140,6 +142,10 @@ struct talitos_private {
>
>        /* hwrng device */
>        struct hwrng rng;
> +#ifdef CONFIG_CRYPTO_DEV_TALITOS_RAIDXOR
> +       /* XOR Device */
> +       struct dma_device dma_dev_common;
> +#endif /* CONFIG_CRYPTO_DEV_TALITOS_RAIDXOR */
>  };
>
>  /* .features flag */
> @@ -684,6 +690,375 @@ static void talitos_unregister_rng(struct device *dev)
>        hwrng_unregister(&priv->rng);
>  }
>
> +#ifdef CONFIG_CRYPTO_DEV_TALITOS_RAIDXOR
> +/*
> + * async_tx interface for XOR-capable SECs
> + *
> + * Dipen Dudhat <Dipen.Dudhat@freescale.com>
> + * Maneesh Gupta <Maneesh.Gupta@freescale.com>
> + * Vishnu Suresh <Vishnu@freescale.com>
> + */
> +
> +/**
> + * talitos_xor_chan - context management for the async_tx channel
> + * @completed_cookie: the last completed cookie
> + * @desc_lock: lock for tx queue
> + * @total_desc: number of descriptors allocated
> + * @submit_q: queue of submitted descriptors
> + * @pending_q: queue of pending descriptors
> + * @in_progress_q: queue of descriptors in progress
> + * @free_desc: queue of unused descriptors
> + * @dev: talitos device implementing this channel
> + * @common: the corresponding xor channel in async_tx
> + */
> +struct talitos_xor_chan {
> +       dma_cookie_t completed_cookie;
> +       spinlock_t desc_lock;
> +       unsigned int total_desc;
> +       struct list_head submit_q;
> +       struct list_head pending_q;
> +       struct list_head in_progress_q;
> +       struct list_head free_desc;
> +       struct device *dev;
> +       struct dma_chan common;
> +};
> +
> +/**
> + * talitos_xor_desc - software xor descriptor
> + * @async_tx: the referring async_tx descriptor
> + * @node:
> + * @hwdesc: h/w descriptor
> + */
> +struct talitos_xor_desc {
> +       struct dma_async_tx_descriptor async_tx;
> +       struct list_head tx_list;
> +       struct list_head node;
> +       struct talitos_desc hwdesc;
> +};
> +
> +static enum dma_status talitos_is_tx_complete(struct dma_chan *chan,
> +                                             dma_cookie_t cookie,
> +                                             dma_cookie_t *done,
> +                                             dma_cookie_t *used)
> +{
> +       struct talitos_xor_chan *xor_chan;
> +       dma_cookie_t last_used;
> +       dma_cookie_t last_complete;
> +
> +       xor_chan = container_of(chan, struct talitos_xor_chan, common);
> +
> +       last_used = chan->cookie;
> +       last_complete = xor_chan->completed_cookie;
> +
> +       if (done)
> +               *done = last_complete;
> +
> +       if (used)
> +               *used = last_used;
> +
> +       return dma_async_is_complete(cookie, last_complete, last_used);
> +}
> +
> +static void talitos_release_xor(struct device *dev, struct talitos_desc *hwdesc,
> +                               void *context, int error)
> +{
> +       struct talitos_xor_desc *desc = context;
> +       struct talitos_xor_chan *xor_chan;
> +       dma_async_tx_callback callback;
> +       void *callback_param;
> +
> +       if (unlikely(error)) {
> +               dev_err(dev, "xor operation: talitos error %d\n", error);
> +               BUG();
> +       }
> +
> +       xor_chan = container_of(desc->async_tx.chan, struct talitos_xor_chan,
> +                               common);
> +       spin_lock_bh(&xor_chan->desc_lock);
> +       if (xor_chan->completed_cookie < desc->async_tx.cookie)
> +               xor_chan->completed_cookie = desc->async_tx.cookie;
> +
> +       callback = desc->async_tx.callback;
> +       callback_param = desc->async_tx.callback_param;
> +       list_del(&desc->node);
> +       list_add_tail(&desc->node, &xor_chan->free_desc);
> +       spin_unlock_bh(&xor_chan->desc_lock);
> +
> +       if (callback)
> +               callback(callback_param);
> +
> +       /* run dependent operations */
> +       dma_run_dependencies(&desc->async_tx);
> +}
> +
> +static void talitos_process_pending(struct talitos_xor_chan *xor_chan)
> +{
> +       struct talitos_xor_desc *desc, *_desc;
> +
> +       spin_lock_bh(&xor_chan->desc_lock);
> +       list_for_each_entry_safe(desc, _desc, &xor_chan->pending_q, node) {
> +               if (talitos_submit(xor_chan->dev, &desc->hwdesc,
> +                                  talitos_release_xor, desc) != -EINPROGRESS)
> +                       break;
> +
> +               list_del(&desc->node);
> +               list_add_tail(&desc->node, &xor_chan->in_progress_q);
> +       }
> +       spin_unlock_bh(&xor_chan->desc_lock);
> +}
> +
> +/**
> + * talitos_issue_pending - move the descriptors in submit
> + * queue to pending queue and submit them for processing
> + * @chan: DMA channel
> + */
> +static void talitos_issue_pending(struct dma_chan *chan)
> +{
> +       struct talitos_xor_chan *xor_chan;
> +
> +       xor_chan = container_of(chan, struct talitos_xor_chan, common);
> +       spin_lock_bh(&xor_chan->desc_lock);
> +       list_splice_tail_init(&xor_chan->submit_q,
> +                                &xor_chan->pending_q);
> +       spin_unlock_bh(&xor_chan->desc_lock);
> +       talitos_process_pending(xor_chan);
> +}
> +
> +static dma_cookie_t talitos_async_tx_submit(struct dma_async_tx_descriptor *tx)
> +{
> +       struct talitos_xor_desc *desc;
> +       struct talitos_xor_chan *xor_chan;
> +       dma_cookie_t cookie;
> +
> +       desc = container_of(tx, struct talitos_xor_desc, async_tx);
> +       xor_chan = container_of(tx->chan, struct talitos_xor_chan, common);
> +
> +       cookie = xor_chan->common.cookie + 1;
> +       if (cookie < 0)
> +               cookie = 1;
> +
> +       desc->async_tx.cookie = cookie;
> +       xor_chan->common.cookie = desc->async_tx.cookie;
> +
> +       list_splice_tail_init(&desc->tx_list,
> +                                &xor_chan->submit_q);
> +
> +       return cookie;
> +}
> +
> +static struct talitos_xor_desc *talitos_xor_alloc_descriptor(
> +                               struct talitos_xor_chan *xor_chan, gfp_t flags)
> +{
> +       struct talitos_xor_desc *desc;
> +
> +       desc = kmalloc(sizeof(*desc), flags);
> +       if (desc) {
> +               xor_chan->total_desc++;
> +               memset(desc, 0, sizeof(*desc));
> +               dma_async_tx_descriptor_init(&desc->async_tx, &xor_chan->common);
> +               desc->async_tx.tx_submit = talitos_async_tx_submit;
> +               INIT_LIST_HEAD(&desc->node);
> +               INIT_LIST_HEAD(&desc->tx_list);
> +       }
> +
> +       return desc;
> +}
> +
> +static void talitos_free_chan_resources(struct dma_chan *chan)
> +{
> +       struct talitos_xor_chan *xor_chan;
> +       struct talitos_xor_desc *desc, *_desc;
> +
> +       xor_chan = container_of(chan, struct talitos_xor_chan, common);
> +
> +       list_for_each_entry_safe(desc, _desc, &xor_chan->submit_q, node) {
> +               list_del(&desc->node);
> +               xor_chan->total_desc--;
> +               kfree(desc);
> +       }
> +       list_for_each_entry_safe(desc, _desc, &xor_chan->pending_q, node) {
> +               list_del(&desc->node);
> +               xor_chan->total_desc--;
> +               kfree(desc);
> +       }
> +       list_for_each_entry_safe(desc, _desc, &xor_chan->in_progress_q, node) {
> +               list_del(&desc->node);
> +               xor_chan->total_desc--;
> +               kfree(desc);
> +       }
> +       list_for_each_entry_safe(desc, _desc, &xor_chan->free_desc, node) {
> +               list_del(&desc->node);
> +               xor_chan->total_desc--;
> +               kfree(desc);
> +       }
> +       BUG_ON(unlikely(xor_chan->total_desc)); /* Some descriptor not freed? */
> +}
> +
> +static int talitos_alloc_chan_resources(struct dma_chan *chan)
> +{
> +       struct talitos_xor_chan *xor_chan;
> +       struct talitos_xor_desc *desc;
> +       LIST_HEAD(tmp_list);
> +       int i;
> +
> +       xor_chan = container_of(chan, struct talitos_xor_chan, common);
> +
> +       if (!list_empty(&xor_chan->free_desc))
> +               return xor_chan->total_desc;
> +
> +       /* 256 initial descriptors */
> +       for (i = 0; i < 256; i++) {
> +               desc = talitos_xor_alloc_descriptor(xor_chan, GFP_KERNEL);
> +               if (!desc) {
> +                       dev_err(xor_chan->common.device->dev,
> +                               "Only %d initial descriptors\n", i);
> +                       break;
> +               }
> +               list_add_tail(&desc->node, &tmp_list);
> +       }
> +
> +       if (!i)
> +               return -ENOMEM;
> +
> +       /* At least one desc is allocated */
> +       list_splice_init(&tmp_list, &xor_chan->free_desc);
> +
> +       return xor_chan->total_desc;
> +}
> +
> +static struct dma_async_tx_descriptor * talitos_prep_dma_xor(
> +                       struct dma_chan *chan, dma_addr_t dest, dma_addr_t *src,
> +                       unsigned int src_cnt, size_t len, unsigned long flags)
> +{
> +       struct talitos_xor_chan *xor_chan;
> +       struct talitos_xor_desc *new;
> +       struct talitos_desc *desc;
> +       int i, j;
> +
> +       BUG_ON(unlikely(len > TALITOS_MAX_DATA_LEN));
> +
> +       xor_chan = container_of(chan, struct talitos_xor_chan, common);
> +
> +       if (!list_empty(&xor_chan->free_desc)) {
> +               new = container_of(xor_chan->free_desc.next,
> +                                  struct talitos_xor_desc, node);
> +               list_del(&new->node);
> +       } else {
> +               new = talitos_xor_alloc_descriptor(xor_chan, GFP_KERNEL);
> +       }
> +
> +       if (!new) {
> +               dev_err(xor_chan->common.device->dev,
> +                       "No free memory for XOR DMA descriptor\n");
> +               return NULL;
> +       }
> +
> +       desc = &new->hwdesc;
> +       /* Set destination: Last pointer pair */
> +       to_talitos_ptr(&desc->ptr[6], dest);
> +       desc->ptr[6].len = cpu_to_be16(len);
> +       desc->ptr[6].j_extent = 0;
> +
> +       /* Set Sources: End loading from second-last pointer pair */
> +       for (i = 5, j = 0; (j < src_cnt) && (i > 0); i--, j++) {
> +               to_talitos_ptr(&desc->ptr[i], src[j]);
> +               desc->ptr[i].len = cpu_to_be16(len);
> +               desc->ptr[i].j_extent = 0;
> +       }
> +
> +       /*
> +        * documentation states first 0 ptr/len combo marks end of sources
> +        * yet device produces scatter boundary error unless all subsequent
> +        * sources are zeroed out
> +        */
> +       for (; i >= 0; i--) {
> +               to_talitos_ptr(&desc->ptr[i], 0);
> +               desc->ptr[i].len = 0;
> +               desc->ptr[i].j_extent = 0;
> +       }
> +
> +       desc->hdr = DESC_HDR_SEL0_AESU | DESC_HDR_MODE0_AESU_XOR
> +                   | DESC_HDR_TYPE_RAID_XOR;
> +
> +       list_add_tail(&new->node, &new->tx_list);
> +
> +       new->async_tx.flags = flags;
> +       new->async_tx.cookie = -EBUSY;
> +
> +       return &new->async_tx;
> +}
> +
> +static void talitos_unregister_async_xor(struct device *dev)
> +{
> +       struct talitos_private *priv = dev_get_drvdata(dev);
> +       struct talitos_xor_chan *xor_chan;
> +       struct dma_chan *chan;
> +
> +       if (priv->dma_dev_common.chancnt)
> +               dma_async_device_unregister(&priv->dma_dev_common);
> +
> +       list_for_each_entry(chan, &priv->dma_dev_common.channels, device_node) {
> +               xor_chan = container_of(chan, struct talitos_xor_chan, common);
> +               list_del(&chan->device_node);
> +               priv->dma_dev_common.chancnt--;
> +               kfree(xor_chan);
> +       }
> +}
> +
> +/**
> + * talitos_register_dma_async - Initialize the Freescale XOR ADMA device
> + * It is registered as a DMA device with the capability to perform
> + * XOR operation with the Async_tx layer.
> + * The various queues and channel resources are also allocated.
> + */
> +static int talitos_register_async_tx(struct device *dev, int max_xor_srcs)
> +{
> +       struct talitos_private *priv = dev_get_drvdata(dev);
> +       struct dma_device *dma_dev = &priv->dma_dev_common;
> +       struct talitos_xor_chan *xor_chan;
> +       int err;
> +
> +       xor_chan = kzalloc(sizeof(struct talitos_xor_chan), GFP_KERNEL);
> +       if (!xor_chan) {
> +               dev_err(dev, "unable to allocate xor channel\n");
> +               return -ENOMEM;
> +       }
> +
> +       dma_dev->dev = dev;
> +       dma_dev->device_alloc_chan_resources = talitos_alloc_chan_resources;
> +       dma_dev->device_free_chan_resources = talitos_free_chan_resources;
> +       dma_dev->device_prep_dma_xor = talitos_prep_dma_xor;
> +       dma_dev->max_xor = max_xor_srcs;
> +       dma_dev->device_is_tx_complete = talitos_is_tx_complete;
> +       dma_dev->device_issue_pending = talitos_issue_pending;
> +       INIT_LIST_HEAD(&dma_dev->channels);
> +       dma_cap_set(DMA_XOR, dma_dev->cap_mask);
> +
> +       xor_chan->dev = dev;
> +       xor_chan->common.device = dma_dev;
> +       xor_chan->total_desc = 0;
> +       INIT_LIST_HEAD(&xor_chan->submit_q);
> +       INIT_LIST_HEAD(&xor_chan->pending_q);
> +       INIT_LIST_HEAD(&xor_chan->in_progress_q);
> +       INIT_LIST_HEAD(&xor_chan->free_desc);
> +       spin_lock_init(&xor_chan->desc_lock);
> +
> +       list_add_tail(&xor_chan->common.device_node, &dma_dev->channels);
> +       dma_dev->chancnt++;
> +
> +       err = dma_async_device_register(dma_dev);
> +       if (err) {
> +               dev_err(dev, "Unable to register XOR with Async_tx\n");
> +               goto err_out;
> +       }
> +
> +       return err;
> +
> +err_out:
> +       talitos_unregister_async_xor(dev);
> +       return err;
> +}
> +#endif /* CONFIG_CRYPTO_DEV_TALITOS_RAIDXOR */
>  /*
>  * crypto alg
>  */
> @@ -1768,6 +2143,10 @@ static int talitos_remove(struct of_device *ofdev)
>        tasklet_kill(&priv->done_task);
>
>        iounmap(priv->reg);
> +#ifdef CONFIG_CRYPTO_DEV_TALITOS_RAIDXOR
> +       if (priv->dma_dev_common.chancnt)
> +               talitos_unregister_async_xor(dev);
> +#endif /* CONFIG_CRYPTO_DEV_TALITOS_RAIDXOR */
>
>        dev_set_drvdata(dev, NULL);
>
> @@ -1926,6 +2305,27 @@ static int talitos_probe(struct of_device *ofdev,
>                        dev_info(dev, "hwrng\n");
>        }
>
> +#ifdef CONFIG_CRYPTO_DEV_TALITOS_RAIDXOR
> +       /*
> +        * register with async_tx xor, if capable
> +        * SEC 2.x support up to 3 RAID sources,
> +        * SEC 3.x support up to 6
> +        */
> +       if (hw_supports(dev, DESC_HDR_SEL0_AESU | DESC_HDR_TYPE_RAID_XOR)) {
> +               int max_xor_srcs = 3;
> +               if (of_device_is_compatible(np, "fsl,sec3.0"))
> +                       max_xor_srcs = 6;
> +
> +               err = talitos_register_async_tx(dev, max_xor_srcs);
> +               if (err) {
> +                       dev_err(dev, "failed to register async_tx xor: %d\n",
> +                               err);
> +                       goto err_out;
> +               }
> +               dev_info(dev, "max_xor_srcs %d\n", max_xor_srcs);
> +       }
> +#endif /* CONFIG_CRYPTO_DEV_TALITOS_RAIDXOR */
> +
>        /* register crypto algorithms the device supports */
>        for (i = 0; i < ARRAY_SIZE(driver_algs); i++) {
>                if (hw_supports(dev, driver_algs[i].desc_hdr_template)) {
> diff --git a/drivers/crypto/talitos.h b/drivers/crypto/talitos.h
> index ff5a145..b6197bc 100644
> --- a/drivers/crypto/talitos.h
> +++ b/drivers/crypto/talitos.h
> @@ -155,6 +155,7 @@
>  /* primary execution unit mode (MODE0) and derivatives */
>  #define        DESC_HDR_MODE0_ENCRYPT          cpu_to_be32(0x00100000)
>  #define        DESC_HDR_MODE0_AESU_CBC         cpu_to_be32(0x00200000)
> +#define        DESC_HDR_MODE0_AESU_XOR         cpu_to_be32(0x0c600000)
>  #define        DESC_HDR_MODE0_DEU_CBC          cpu_to_be32(0x00400000)
>  #define        DESC_HDR_MODE0_DEU_3DES         cpu_to_be32(0x00200000)
>  #define        DESC_HDR_MODE0_MDEU_INIT        cpu_to_be32(0x01000000)
> @@ -202,6 +203,7 @@
>  #define DESC_HDR_TYPE_IPSEC_ESP                        cpu_to_be32(1 << 3)
>  #define DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU  cpu_to_be32(2 << 3)
>  #define DESC_HDR_TYPE_HMAC_SNOOP_NO_AFEU       cpu_to_be32(4 << 3)
> +#define DESC_HDR_TYPE_RAID_XOR                 cpu_to_be32(21 << 3)
>
>  /* link table extent field bits */
>  #define DESC_PTR_LNKTBL_JUMP                   0x80
> --
> 1.6.4.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
The simplest is not all best but the best is surely the simplest!

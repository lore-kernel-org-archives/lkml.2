Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753360Ab1ARUZn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 15:25:43 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:46495 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753284Ab1ARUZm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 15:25:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=UwVwVIgi9Mn03WIkr3dZg24qiZcjNkj+bOHlke6SUBALYP1BZUfy5RR5IcjTqbofFL
         +5bx/EUP1Otgc/aYlZ7ZOknzv9jfeN+Tl579l+Q7uWJLb0SJxvmWOFdTnc1ZH09pan6N
         E1Tedjh6r/SLE0vx6ufji3q4WqR9IynCe3MME=
MIME-Version: 1.0
In-Reply-To: <AANLkTi=HsE+h9GU8rM6zW2BVtoayEGfKOmPCsrrNHiz5@mail.gmail.com>
References: <AANLkTi=HsE+h9GU8rM6zW2BVtoayEGfKOmPCsrrNHiz5@mail.gmail.com>
Date: Tue, 18 Jan 2011 23:25:41 +0300
Message-ID: <AANLkTi=-4k0hbM9gESLBfzJW_reonqX_GMiVzXzRJFqu@mail.gmail.com>
Subject: Re: WARNING in module rt2870sta stable kernel 2.6.37
From: Denis Kirjanov <kirjanov@gmail.com>
To: Giangiacomo Mariotti <gg.mariotti@gmail.com>
Cc: Greg KH <gregkh@suse.de>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have sent a patch to fix this problem: https://lkml.org/lkml/2011/1/10/329
It also fixes a bug #26472: https://bugzilla.kernel.org/show_bug.cgi?id=26472

On Tue, Jan 18, 2011 at 11:16 PM, Giangiacomo Mariotti
<gg.mariotti@gmail.com> wrote:
> Hi, the following message was logged on a 2.6.37 kernel(it says
> tainted, but it's actually a micro patch I wrote and applied on top of
> current 2.6.37 vanilla, patch appended, but it should be irrelevant, I
> just shut up a bunch of useless debug output for this staging driver):
>
> [   31.747937] ------------[ cut here ]------------
> [   31.747958] WARNING: at include/linux/netdevice.h:1557
> netif_stop_queue.clone.3+0x1a/0x36 [rt2870sta]()
> [   31.747961] Hardware name: EX58-UD5
> [   31.747963] Modules linked in: rt2870sta(C+) i2c_i801 shpchp
> i7core_edac edac_core snd_hwdep i2c_core snd_pcm pci_hotplug pcspkr
> evdev snd_seq snd_timer snd_seq_device snd tpm_tis tpm tpm_bios
> crc_ccitt soundcore snd_page_alloc processor thermal_sys wmi button
> crc32c_intel sg sr_mod usbhid firewire_ohci sd_mod hid cdrom
> ata_generic crc_t10dif usb_storage uas uhci_hcd ehci_hcd ahci
> firewire_core usbcore r8169 libahci pata_jmicron crc_itu_t mii
> nls_base floppy [last unloaded: scsi_wait_scan]
> [   31.747999] Pid: 669, comm: modprobe Tainted: G         C  2.6.37-my001+ #1
> [   31.748002] Call Trace:
> [   31.748010]  [<ffffffff8103b961>] ? warn_slowpath_common+0x78/0x8c
> [   31.748029]  [<ffffffffa03e5b0f>] ?
> netif_stop_queue.clone.3+0x1a/0x36 [rt2870sta]
> [   31.748048]  [<ffffffffa03e60d2>] ? RtmpPhyNetDevInit+0x6d/0x75 [rt2870sta]
> [   31.748065]  [<ffffffffa03f5034>] ? rtusb_probe+0x28c/0x36e [rt2870sta]
> [   31.748071]  [<ffffffffa0035572>] ? usb_probe_interface+0xfc/0x16f [usbcore]
> [   31.748075]  [<ffffffff812a5b61>] ? driver_probe_device+0xb2/0x142
> [   31.748077]  [<ffffffff812a5c40>] ? __driver_attach+0x4f/0x6f
> [   31.748079]  [<ffffffff812a5bf1>] ? __driver_attach+0x0/0x6f
> [   31.748082]  [<ffffffff812a4e05>] ? bus_for_each_dev+0x47/0x72
> [   31.748084]  [<ffffffff812a54dd>] ? bus_add_driver+0xa2/0x1f2
> [   31.748086]  [<ffffffff812a5e64>] ? driver_register+0x8d/0xf5
> [   31.748091]  [<ffffffffa003473a>] ? usb_register_driver+0x80/0x128 [usbcore]
> [   31.748097]  [<ffffffffa0412000>] ? init_module+0x0/0x30 [rt2870sta]
> [   31.748100]  [<ffffffff810002eb>] ? do_one_initcall+0x78/0x129
> [   31.748104]  [<ffffffff81069c68>] ? sys_init_module+0x9c/0x1d7
> [   31.748106]  [<ffffffff8100293b>] ? system_call_fastpath+0x16/0x1b
> [   31.748108] ---[ end trace 285f31f0bc9e54ab ]---
> [   31.748109] netif_stop_queue() cannot be called before register_netdev()
> [   31.748533] usbcore: registered new interface driver rt2870
>
>
> My micro patch:
>
> >From a7335c70ec821221b79b7607765d2a7de5fc78e3 Mon Sep 17 00:00:00 2001
> From: Giangiacomo Mariotti <giangiacomo.mariotti@gmail.com>
> Date: Tue, 11 Jan 2011 04:57:58 +0100
> Subject: 0001-make-debug-output-standard-compliant-in-rt2870.patch
>
>
> Signed-off-by: Giangiacomo Mariotti <giangiacomo.mariotti@gmail.com>
> ---
>  drivers/staging/rt2860/chip/mac_usb.h        |    3 ++-
>  drivers/staging/rt2860/common/cmm_data_usb.c |    6 +++---
>  drivers/staging/rt2860/sta_ioctl.c           |   12 ++++++------
>  drivers/staging/rt2860/usb_main_dev.c        |    2 +-
>  4 files changed, 12 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/staging/rt2860/chip/mac_usb.h
> b/drivers/staging/rt2860/chip/mac_usb.h
> index ed0c0b4..e2310dc 100644
> --- a/drivers/staging/rt2860/chip/mac_usb.h
> +++ b/drivers/staging/rt2860/chip/mac_usb.h
> @@ -37,6 +37,7 @@
>  #ifndef __MAC_USB_H__
>  #define __MAC_USB_H__
>
> +#include <linux/kernel.h>
>  #include "../rtmp_type.h"
>  #include "rtmp_mac.h"
>  #include "rtmp_phy.h"
> @@ -224,7 +225,7 @@ struct rt_rx_context {
>                                RTMP_IRQ_LOCK(&pAd->DeQueueLock[QueIdx], irqFlags);             \
>                                if (pAd->DeQueueRunning[QueIdx]) {                                              \
>                                        RTMP_IRQ_UNLOCK(&pAd->DeQueueLock[QueIdx], irqFlags); \
> -                                       DBGPRINT(RT_DEBUG_OFF, ("DeQueueRunning[%d]= TRUE!\n", QueIdx));                \
> +                                       pr_debug("DeQueueRunning[%d]= TRUE!\n", QueIdx);                \
>                                        continue;                                                                                       \
>                                } else {                                                                                                \
>                                        pAd->DeQueueRunning[QueIdx] = TRUE;                                     \
> diff --git a/drivers/staging/rt2860/common/cmm_data_usb.c
> b/drivers/staging/rt2860/common/cmm_data_usb.c
> index 7c56c2f..be930ae 100644
> --- a/drivers/staging/rt2860/common/cmm_data_usb.c
> +++ b/drivers/staging/rt2860/common/cmm_data_usb.c
> @@ -51,16 +51,16 @@ static inline int RtmpUSBCanDoWrite(struct
> rt_rtmp_adapter *pAd,
>             pHTTXContext->NextBulkOutPosition)
>            && (pHTTXContext->CurWritePosition + LOCAL_TXBUF_SIZE) >
>            pHTTXContext->NextBulkOutPosition) {
> -               DBGPRINT(RT_DEBUG_ERROR, ("RtmpUSBCanDoWrite c1!\n"));
> +               pr_debug("RtmpUSBCanDoWrite c1!\n");
>                RTUSB_SET_BULK_FLAG(pAd,
>                                    (fRTUSB_BULK_OUT_DATA_NORMAL << QueIdx));
>        } else if ((pHTTXContext->CurWritePosition == 8)
>                   && (pHTTXContext->NextBulkOutPosition < LOCAL_TXBUF_SIZE)) {
> -               DBGPRINT(RT_DEBUG_ERROR, ("RtmpUSBCanDoWrite c2!\n"));
> +               pr_debug("RtmpUSBCanDoWrite c2!\n");
>                RTUSB_SET_BULK_FLAG(pAd,
>                                    (fRTUSB_BULK_OUT_DATA_NORMAL << QueIdx));
>        } else if (pHTTXContext->bCurWriting == TRUE) {
> -               DBGPRINT(RT_DEBUG_ERROR, ("RtmpUSBCanDoWrite c3!\n"));
> +               pr_debug("RtmpUSBCanDoWrite c3!\n");
>        } else {
>                canWrite = NDIS_STATUS_SUCCESS;
>        }
> diff --git a/drivers/staging/rt2860/sta_ioctl.c
> b/drivers/staging/rt2860/sta_ioctl.c
> index e095a44..00fe666 100644
> --- a/drivers/staging/rt2860/sta_ioctl.c
> +++ b/drivers/staging/rt2860/sta_ioctl.c
> @@ -394,9 +394,9 @@ int rt_ioctl_siwfreq(struct net_device *dev,
>
>        if (ChannelSanity(pAdapter, chan) == TRUE) {
>                pAdapter->CommonCfg.Channel = chan;
> -               DBGPRINT(RT_DEBUG_ERROR,
> -                        ("==>rt_ioctl_siwfreq::SIOCSIWFREQ[cmd=0x%x] (Channel=%d)\n",
> -                         SIOCSIWFREQ, pAdapter->CommonCfg.Channel));
> +               netdev_dbg(dev,
> +                       "==>rt_ioctl_siwfreq::SIOCSIWFREQ[cmd=0x%x] (Channel=%d)\n",
> +                       SIOCSIWFREQ, pAdapter->CommonCfg.Channel);
>        } else
>                return -EINVAL;
>
> @@ -1113,9 +1113,9 @@ int rt_ioctl_giwscan(struct net_device *dev,
>
>        data->length = current_ev - extra;
>        pAdapter->StaCfg.bScanReqIsFromWebUI = FALSE;
> -       DBGPRINT(RT_DEBUG_ERROR,
> -                ("===>rt_ioctl_giwscan. %d(%d) BSS returned, data->length = %d\n",
> -                 i, pAdapter->ScanTab.BssNr, data->length));
> +       netdev_dbg(dev,
> +               "===>rt_ioctl_giwscan. %d(%d) BSS returned, data->length = %d\n",
> +               i, pAdapter->ScanTab.BssNr, data->length);
>        return 0;
>  }
>
> diff --git a/drivers/staging/rt2860/usb_main_dev.c
> b/drivers/staging/rt2860/usb_main_dev.c
> index cd15daa..5b0dfc0 100644
> --- a/drivers/staging/rt2860/usb_main_dev.c
> +++ b/drivers/staging/rt2860/usb_main_dev.c
> @@ -715,7 +715,7 @@ void RTUSBWatchDog(struct rt_rtmp_adapter *pAd)
>                                RTMP_IRQ_UNLOCK(&pAd->BulkOutLock[idx],
>                                                irqFlags);
>
> -                               printk(KERN_INFO "%d:%lu LTL=%d , TL=%d L:%d\n",
> +                               pr_debug("%d:%lu LTL=%d , TL=%d L:%d\n",
>                                       idx, pAd->watchDogTxPendingCnt[idx],
>                                       pAd->TransferedLength[idx],
>                                       actual_length, transfer_buffer_length);
> --
> 1.7.2.3
>
> --
> Giangiacomo
> _______________________________________________
> devel mailing list
> devel@linuxdriverproject.org
> http://driverdev.linuxdriverproject.org/mailman/listinfo/devel
>



-- 
Regards,
Denis

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753313Ab0CYNjU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 09:39:20 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:57070 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751493Ab0CYNjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 09:39:18 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jiri Kosina <jkosina@suse.cz>
Subject: Re: [GIT, RFC] Killing the Big Kernel Lock
Date: Thu, 25 Mar 2010 14:38:58 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; x86_64; ; )
Cc: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       Matthew Wilcox <matthew@wil.cx>, Thomas Gleixner <tglx@linutronix.de>,
       jblunck@suse.de, Alan Cox <alan@linux.intel.com>,
       Ingo Molnar <mingo@elte.hu>, John Kacur <jkacur@redhat.com>
References: <201003242240.54907.arnd@arndb.de> <alpine.LRH.2.00.1003251354200.16443@twin.jikos.cz> <201003251406.10177.arnd@arndb.de>
In-Reply-To: <201003251406.10177.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201003251438.59062.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+83VcZu2+V8wgdng/4BBS5UDpUhNkYKilZ8lU
 VKkLw0+p0cYUCxv0CECgJZ64KrdhdGvDSFE8YMPaXp7/sPguQ6
 vJ4B1n4Bl06XlPHftPXPg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 25 March 2010, Arnd Bergmann wrote:
> On Thursday 25 March 2010, Jiri Kosina wrote:
> >         config USB
> >                 tristate "Support for Host-side USB"
> >                 depends on USB_ARCH_HAS_HCD && BKL
> > 
> > Well, that's very interesting definition of "obscure" :)
> > 
> 
> That's why I said /mostly/ obscure modules. There are soundcore, usb-core, drm,
> vfat and a few other very common ones, along with many obscure ones.

FWIW, this is the full list of 148 modules that require the BKL in an x86 allmodconfig,
which is probably the configuration with the largest code coverage.

	Arnd

sound/soundcore.ko
sound/soc/snd-soc-core.ko
sound/oss/sound.ko
sound/oss/msnd_pinnacle.ko
sound/oss/msnd_classic.ko
sound/core/snd.ko
sound/core/snd-pcm.ko
sound/core/seq/snd-seq.ko
sound/core/oss/snd-pcm-oss.ko
net/x25/x25.ko
net/wanrouter/wanrouter.ko
net/sunrpc/sunrpc.ko
net/irda/irnet/irnet.ko
net/irda/irda.ko
net/ipx/ipx.ko
net/appletalk/appletalk.ko
fs/ufs/ufs.ko
fs/udf/udf.ko
fs/squashfs/squashfs.ko
fs/smbfs/smbfs.ko
fs/reiserfs/reiserfs.ko
fs/qnx4/qnx4.ko
fs/ocfs2/ocfs2_stack_user.ko
fs/ocfs2/ocfs2.ko
fs/nfsd/nfsd.ko
fs/nfs/nfs.ko
fs/ncpfs/ncpfs.ko
fs/lockd/lockd.ko
fs/jffs2/jffs2.ko
fs/isofs/isofs.ko
fs/hpfs/hpfs.ko
fs/hfsplus/hfsplus.ko
fs/freevxfs/freevxfs.ko
fs/fat/vfat.ko
fs/fat/msdos.ko
fs/fat/fat.ko
fs/ecryptfs/ecryptfs.ko
fs/coda/coda.ko
fs/autofs4/autofs4.ko
fs/autofs/autofs.ko
fs/afs/kafs.ko
fs/adfs/adfs.ko
drivers/usb/misc/usblcd.ko
drivers/usb/misc/sisusbvga/sisusbvga.ko
drivers/usb/misc/rio500.ko
drivers/usb/misc/iowarrior.ko
drivers/usb/misc/idmouse.ko
drivers/usb/host/uhci-hcd.ko
drivers/usb/gadget/gadgetfs.ko
drivers/usb/gadget/g_printer.ko
drivers/usb/core/usbcore.ko
drivers/usb/class/usblp.ko
drivers/telephony/ixj.ko
drivers/scsi/st.ko
drivers/scsi/scsi_tgt.ko
drivers/scsi/pmcraid.ko
drivers/scsi/osst.ko
drivers/scsi/osd/osd.ko
drivers/scsi/mpt2sas/mpt2sas.ko
drivers/scsi/megaraid/megaraid_sas.ko
drivers/scsi/megaraid/megaraid_mm.ko
drivers/scsi/megaraid.ko
drivers/scsi/gdth.ko
drivers/scsi/dpt_i2o.ko
drivers/scsi/ch.ko
drivers/scsi/aacraid/aacraid.ko
drivers/scsi/3w-xxxx.ko
drivers/scsi/3w-sas.ko
drivers/scsi/3w-9xxx.ko
drivers/rtc/rtc-m41t80.ko
drivers/pci/hotplug/cpqphp.ko
drivers/net/wireless/ray_cs.ko
drivers/net/wireless/airo.ko
drivers/net/wan/cosa.ko
drivers/net/ppp_generic.ko
drivers/mtd/ubi/ubi.ko
drivers/mtd/mtdchar.ko
drivers/misc/phantom.ko
drivers/message/i2o/i2o_config.ko
drivers/message/fusion/mptctl.ko
drivers/media/video/zoran/zr36067.ko
drivers/media/video/videodev.ko
drivers/media/video/usbvision/usbvision.ko
drivers/media/video/usbvideo/vicam.ko
drivers/media/video/tlg2300/poseidon.ko
drivers/media/video/stv680.ko
drivers/media/video/stradis.ko
drivers/media/video/stkwebcam.ko
drivers/media/video/se401.ko
drivers/media/video/s2255drv.ko
drivers/media/video/pwc/pwc.ko
drivers/media/video/dabusb.ko
drivers/media/video/cx88/cx8800.ko
drivers/media/video/cx88/cx88-blackbird.ko
drivers/media/video/cx23885/cx23885.ko
drivers/media/video/cpia.ko
drivers/media/video/bt8xx/bttv.ko
drivers/media/radio/si470x/radio-usb-si470x.ko
drivers/media/dvb/ttpci/dvb-ttpci.ko
drivers/media/dvb/firewire/firedtv.ko
drivers/media/dvb/dvb-core/dvb-core.ko
drivers/media/dvb/bt8xx/dst_ca.ko
drivers/isdn/mISDN/mISDN_core.ko
drivers/isdn/i4l/isdn.ko
drivers/isdn/hysdn/hysdn.ko
drivers/isdn/hardware/eicon/divas.ko
drivers/isdn/hardware/eicon/diva_mnt.ko
drivers/isdn/hardware/eicon/diva_idi.ko
drivers/isdn/divert/dss1_divert.ko
drivers/isdn/capi/capifs.ko
drivers/isdn/capi/capi.ko
drivers/input/serio/serio_raw.ko
drivers/input/misc/uinput.ko
drivers/infiniband/core/rdma_ucm.ko
drivers/infiniband/core/ib_uverbs.ko
drivers/infiniband/core/ib_umad.ko
drivers/infiniband/core/ib_ucm.ko
drivers/ieee1394/video1394.ko
drivers/ieee1394/raw1394.ko
drivers/ieee1394/dv1394.ko
drivers/ide/ide-tape.ko
drivers/hwmon/fschmd.ko
drivers/hid/usbhid/usbhid.ko
drivers/hid/hid.ko
drivers/gpu/drm/i830/i830.ko
drivers/gpu/drm/i810/i810.ko
drivers/gpu/drm/drm.ko
drivers/firewire/firewire-core.ko
drivers/char/toshiba.ko
drivers/char/tlclk.ko
drivers/char/stallion.ko
drivers/char/raw.ko
drivers/char/ppdev.ko
drivers/char/pcmcia/cm4040_cs.ko
drivers/char/pcmcia/cm4000_cs.ko
drivers/char/mwave/mwave.ko
drivers/char/lp.ko
drivers/char/istallion.ko
drivers/char/ipmi/ipmi_watchdog.ko
drivers/char/ipmi/ipmi_devintf.ko
drivers/char/ip2/ip2.ko
drivers/char/i8k.ko
drivers/char/dtlk.ko
drivers/char/applicom.ko
drivers/block/pktcdvd.ko
drivers/block/paride/pt.ko
drivers/block/paride/pg.ko
drivers/block/DAC960.ko

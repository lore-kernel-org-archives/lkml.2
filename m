Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756763Ab2JITfN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 15:35:13 -0400
Received: from mga02.intel.com ([134.134.136.20]:18239 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755675Ab2JITfK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 15:35:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,561,1344236400"; 
   d="scan'208";a="224464912"
Date: Tue, 9 Oct 2012 12:35:09 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: WANG Siyuan <wangsiyuanbuaa@gmail.com>
Cc: Daniel Mack <zonque@gmail.com>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: usb 3.0 hard drive doesn't work
Message-ID: <20121009193509.GA14107@xanatos>
References: <CAKhuMP=DB2WGzNN2dXoFuJtSRCneBrToUb43KjU_OsQCrJP_UA@mail.gmail.com>
 <5071F4C5.6000104@gmail.com>
 <CAKhuMP=wkE910qXgmDX-_hqJtV_FMgBA6TRP3hSLy42sWru7Bg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKhuMP=wkE910qXgmDX-_hqJtV_FMgBA6TRP3hSLy42sWru7Bg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is probably a known issue.  Other Western Digital hard drives had
issues with the Link PM feature that went into 3.5.  Can you please test
with this branch:

git clone git://git.kernel.org/pub/scm/linux/kernel/git/sarah/xhci.git -b for-usb-linus-pending

In particular, I think this patch will help you, if you want to just try
that:

http://git.kernel.org/?p=linux/kernel/git/sarah/xhci.git;a=commit;h=ae8963adb4ad8c5f2a89ca1d99fb7bb721e7599f

Sarah Sharp

On Tue, Oct 09, 2012 at 09:51:55AM +0800, WANG Siyuan wrote:
> hi, Daniel
> my usb 3.0 hard drive doesn't have external power. this is a "western
> digital" usb hard drive: WDBACY5000AWT
> here is a Product Specifications:
> http://www.wdc.com/wdproducts/library/AAG/ENG/4178-705131.pdf
> 
> i start my laptop with ubuntu, the usb3.0 port could use the usb3.0
> hard drive. but the write speed is only 50MB/s (test with dd)
> but archlinux cannot recognize the hard drive.
> 
> thank you for replaying.
> 
> On Mon, Oct 8, 2012 at 5:31 AM, Daniel Mack <zonque@gmail.com> wrote:
> > (cc linux-usb)
> >
> > On 07.10.2012 10:48, 王思源 wrote:
> >> hi,
> >> i have a usb 3.0 hard drive and a laptop with usb 3.0 port.
> >> when the hard drive is connected to the usb 3.0 port, the drive could
> >> not be found.
> >> the dmesg output is listed below.
> >> additinal info:
> >> 1) the usb 3.0 hard drive can be found when connected to usb 2.0 port.
> >> 2) the usb 2.0 hard drive can be found when connected to usb 3.0 port.
> >> 3) mouse works when connected to the usb 3.0 port.
> >> 4) it is archlinux and kernel version is 3.5.5-1-ARCH
> >> it seems that it is not the linux driver's problem, because the mouse
> >> could work and the hard drive is found due to the dmesg.
> >> is this a bug?
> >> would someone help me?
> >> thank you!
> >>
> >> dmesg out put when usb 3.0 hard drive is conneted to usb 3.0 port:
> >> [  646.077385] usb 2-2: new SuperSpeed USB device number 2 using xhci_hcd
> >> [  646.171319] usbcore: registered new interface driver uas
> >> [  646.175313] Initializing USB Mass Storage driver...
> >> [  646.175501] scsi4 : usb-storage 2-2:1.0
> >> [  646.175665] usbcore: registered new interface driver usb-storage
> >> [  646.175667] USB Mass Storage support registered.
> >> [  657.149403] scsi 4:0:0:0: Direct-Access     WD       My Passport
> >> 0730 1016 PQ: 0 ANSI: 6
> >> [  657.149974] sd 4:0:0:0: [sdb] 976707584 512-byte logical blocks:
> >> (500 GB/465 GiB)
> >> [  657.150223] sd 4:0:0:0: [sdb] Write Protect is off
> >> [  657.150232] sd 4:0:0:0: [sdb] Mode Sense: 47 00 10 08
> >> [  657.150456] sd 4:0:0:0: [sdb] No Caching mode page present
> >> [  657.150462] sd 4:0:0:0: [sdb] Assuming drive cache: write through
> >> [  657.151436] sd 4:0:0:0: [sdb] No Caching mode page present
> >> [  657.151440] sd 4:0:0:0: [sdb] Assuming drive cache: write through
> >> [  657.159907]  sdb: sdb1
> >> [  657.160852] sd 4:0:0:0: [sdb] No Caching mode page present
> >> [  657.160858] sd 4:0:0:0: [sdb] Assuming drive cache: write through
> >> [  657.160861] sd 4:0:0:0: [sdb] Attached SCSI disk
> >> [  657.268875] usb 2-2: Device not responding to set address.
> >> [  657.471456] usb 2-2: Device not responding to set address.
> >> [  657.674211] usb 2-2: device not accepting address 2, error -71
> >> [  657.780745] usb 2-2: Device not responding to set address.
> >> [  657.983519] usb 2-2: Device not responding to set address.
> >> [  658.186214] usb 2-2: device not accepting address 2, error -71
> >> [  658.292717] usb 2-2: Device not responding to set address.
> >> [  658.495537] usb 2-2: Device not responding to set address.
> >
> > From the logs, this smells like a power supply problem. Can you connect
> > an external supply or do you have a powered USB3 hub? It's possible that
> > it draws less power in USB2.0 mode, so that would explain what you describe.
> >
> > But I could be wrong alltogether :)
> >
> >
> > Daniel
> >
> 
> 
> 
> -- 
> 王思源
> --
> To unsubscribe from this list: send the line "unsubscribe linux-usb" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752249Ab0C0KVS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Mar 2010 06:21:18 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:59333 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751878Ab0C0KVP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Mar 2010 06:21:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:message-id:content-type:content-transfer-encoding;
        b=ic5jyDuGGEmSxONI8AdTxzgBS+euN+cUm6x3vmubQHvvr0fSuq4R8uDt3qH4amv88b
         2JcHdZz7873H3fUQ4LySwM5QqWupN5x4tfSOhRxMKwPHk6+KuRD7Lf4DYIDH/5M6u2eu
         LZHTgOkUJBQSw/tQRHxtAPtDoF/BgZT/FfUfw=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: David Fries <david@fries.net>
Subject: Re: 2.6.34-rc2 breaks via82cxxx Host Protected Area
Date: Sat, 27 Mar 2010 11:19:53 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33-0.1-desktop; KDE/4.3.5; x86_64; ; )
Cc: Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
References: <20100326232104.GA10769@spacedout.fries.net> <4BAD5472.9050303@garzik.org> <20100327020934.GA8224@spacedout.fries.net>
In-Reply-To: <20100327020934.GA8224@spacedout.fries.net>
MIME-Version: 1.0
Message-Id: <201003271119.53757.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 27 March 2010 03:09:35 am David Fries wrote:
> On Fri, Mar 26, 2010 at 08:42:26PM -0400, Jeff Garzik wrote:
> > On 03/26/2010 08:36 PM, David Fries wrote:
> >> On Fri, Mar 26, 2010 at 08:12:26PM -0400, Jeff Garzik wrote:
> >>> On 03/26/2010 07:21 PM, David Fries wrote:
> >>>> The kernel fails to see the entire disk with 2.6.34-rc2 with VIA
> >>>> vt82c586b chipset.  I tracked it down to commit
> >>>> f931a5d5785d7b7c44871bd7ad2762e29dfddf29 "via82cxxx: workaround h/w
> >>>> bugs" and reverting just that one solves the problem, or just
> >>>> commenting out just one outb write in that change.
> >>>>
> >>>> via82cxxx 0000:00:07.1: VIA vt82c586b (rev 41) IDE UDMA33
> >>>> via82cxxx 0000:00:07.1: IDE controller (0x1106:0x0571 rev 0x06)
> >>>> via82cxxx 0000:00:07.1: not 100% native mode: will probe irqs later
> >>>>
> >>>> Note the kernel panic is intentional as I'm given the test kernel an
> >>>> invalid root device, so that I can suspend to disk, try a kernel,
> >>>> resume and pick up where I left off.  It does have a side benefit of
> >>>> dumping the size of all partitions.
> >>>>
> >>>> 2.6.34-rc2 unmodified, fails and sees 30985416 KiB for the last
> >>>> partition.
> >>>> ide-gd driver 1.18
> >>>> hda: max request size: 128KiB
> >>>> hda: 66055248 sectors (33820 MB) w/7936KiB Cache, CHS=65531/16/63
> >>>> hda: cache flushes supported
> >>>>    hda: hda1 hda2 hda3
> >>>> hda: p3 size 236037312 exceeds device capacity, enabling native capacity
> >>>> hda: p3 size 236037312 exceeds device capacity, limited to end of disk
> >>>> ide-cd driver 5.00
> >>>> ...
> >>>> Please append a correct "root=" boot option; here are the available partitions:
> >>>> 0300        33027624 hda driver: ide-gd
> >>>>     0301           49391 hda1
> >>>>     0302         1992816 hda2
> >>>>     0303        30985416 hda3
> >>>> Kernel panic - not syncing: VFS: Unable to mount root fs on unknown-block(22,2)
> 
> > All these errors related to unknown-block(22,2) are it trying to find  
> > /dev/hdX, when libata uses the SCSI block devices /dev/sdX
> >
> > These errors are unrelated to HPA, and are a standard issue encountered  
> > when moving from legacy IDE driver to libata.
> 
> added
> libata.dma=0 libata.ignore_hpa=1
> and it's showing the full disk again, thanks for pointing that out,
> I'm just not used to giving module parameters on the kernel command
> line.  Now I'll see what Bartlomiej Zolnierkiewicz has to say about
> his patch which broke via82cxxx.

Please bring upstream IDE problems with upstream kernel maintainer.

I have very little control over what people are doing with some (taken
out of much larger context) atang-specific patches posted for review
to kernel mailing lists and over quality of integration/testing work
that should always accompany upstream merge.

The commit itself may also have a problem but since it was _never_ in
linux-next tree it never saw a wider upstream testing.  Moreover upstream
doesn't use unified driver source (atang tree does) which makes makes
debugging and long-term maintenance more time consuming than necessary.

I'm sorry to hear about your problem but it is not my fault and I prefer
using my _private_ time in more constructive ways..

--
Bartlomiej Zolnierkiewicz

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754067Ab0IMRyA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 13:54:00 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51012 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751771Ab0IMRx7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 13:53:59 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "M. Vefa Bicakci" <bicave@superonline.com>
Subject: Re: [PATCH] PM / Hibernate: Make default image size depend on totalRAM size
Date: Mon, 13 Sep 2010 19:52:57 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc3-rjw+; KDE/4.4.4; x86_64; ; )
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-pm@lists.linux-foundation.org,
        Minchan Kim <minchan.kim@gmail.com>, stable@kernel.org,
        "Greg Kroah-Hartman" <gregkh@suse.de>
References: <201009062043.37819.rjw@sisk.pl> <201009120027.06470.rjw@sisk.pl> <4C8E45EB.8030408@superonline.com>
In-Reply-To: <4C8E45EB.8030408@superonline.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201009131952.57862.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, September 13, 2010, M. Vefa Bicakci wrote:
> On 11/09/10 06:27 PM, Rafael J. Wysocki wrote:
> > On Saturday, September 11, 2010, Rafael J. Wysocki wrote:
> >> On Saturday, September 11, 2010, M. Vefa Bicakci wrote:
> > ...
> >>>
> >>> I would be glad to test that patch as well, to see if it brings speed-ups.
> >>> Actually, I might test hibernation with a larger value written to
> >>> /sys/power/image_size when I have time.
> >>
> >> I think that would improve things, as it probably is impossible to reduce the
> >> image size to 500 MB on your system.
> >>
> >> Anyway, I'll let you know when the patch is ready.
> > 
> > OK, please try the patch below on top of the previous one and see if it makes
> > hibernation run faster on your system.
> 
> Dear Rafael Wysocki,
> 
> I think I have good news. I took a clean 2.6.35.4 tree, and first applied
> the latest version of your larger snapshot.c patch, and then the patch you
> appended to your final e-mail in this thread.
> 
> Here is a comparison of the timings from a kernel without your patch, and
> one with it.
> 
> === 8< ===
> Sep 11 10:22:24 debian kernel: [  499.968989] PM: Allocated 2531300 kbytes in 52.66 seconds (48.06 MB/s)
> Sep 11 10:44:08 debian kernel: [  764.379131] PM: Allocated 2531308 kbytes in 143.41 seconds (17.65 MB/s)
> Sep 11 10:48:41 debian kernel: [  920.626386] PM: Allocated 2531300 kbytes in 66.44 seconds (38.09 MB/s)
> Sep 11 10:53:37 debian kernel: [ 1092.919140] PM: Allocated 2531316 kbytes in 81.28 seconds (31.14 MB/s)
> ...
> Sep 13 01:26:09 debian kernel: [   94.948054] PM: Allocated 1804008 kbytes in 28.72 seconds (62.81 MB/s)
> Sep 13 01:29:58 debian kernel: [  176.678880] PM: Allocated 1803992 kbytes in 34.44 seconds (52.38 MB/s)
> Sep 13 01:33:48 debian kernel: [  253.336405] PM: Allocated 1804000 kbytes in 27.35 seconds (65.95 MB/s)
> === >8 ===
> 
> I didn't have your latest patch applied on September 11, and it was applied
> last night.
> 
> It looks like there is a good improvement. I think the data rates look
> faster on Sept. 13 because the kernel spent less time "thinking" less
> while compacting the memory image. (I don't think I have changed anything
> in my configuration that could affect the data rates that much.)

OK, thanks for testing and information.

> Is it possible to have these patches applied to the 2.6.35 tree so that
> the regression I reported is fixed?

The "snapshot.c" patch has just been included into the Linus' tree as

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=6715045ddc7472a22be5e49d4047d2d89b391f45

> Should I e-mail Greg Kroah-Hartman about this?

and I've already told Greg that it should go into 2.6.35.y.

The second patch, however, only changes the default value of image_size, so it
is not -stable material.

As a workaround, you can change the init scripts on your system to set
/sys/power/image_size to the same value that's in it when the second patch is
applied.

Thanks,
Rafael

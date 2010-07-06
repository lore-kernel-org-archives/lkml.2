Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755816Ab0GFBwZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 21:52:25 -0400
Received: from tn-76-7-162-101.sta.embarqhsd.net ([76.7.162.101]:56238 "EHLO
	animx.eu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753470Ab0GFBwY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 21:52:24 -0400
Date: Mon, 5 Jul 2010 21:52:20 -0400
From: Wakko Warner <wakko@animx.eu.org>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: Marvin <marvin24@gmx.de>, linux-kernel@vger.kernel.org,
       xorg-driver-ati@lists.x.org
Subject: Re: Radeon KMS doesn't work.
Message-ID: <20100706015219.GA26848@animx.eu.org>
Mail-Followup-To: "Justin P. Mattock" <justinmattock@gmail.com>,
	Marvin <marvin24@gmx.de>, linux-kernel@vger.kernel.org,
	xorg-driver-ati@lists.x.org
References: <20100703221056.GA17817@animx.eu.org> <20100704231926.GA1780@animx.eu.org> <201007051927.17001.marvin24@gmx.de> <4C3221FA.6070507@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C3221FA.6070507@gmail.com>
User-Agent: Mutt/1.5.6+20040907i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Justin P. Mattock wrote:
> On 07/05/2010 10:27 AM, Marvin wrote:
> >
> >Hi Wakko,
> >
> >as nobody seems to have answered yet, I think it's better that you file a 
> >bug
> >against the radeon driver (bugs.freedesktop.org, one bug for each defect).
> >There may be similar bugs already, so please check this also.
> >
> >Thanks
> >
> >Marvin
> >
> >Am Montag 05 Juli 2010, 01:19:26 schrieb Wakko Warner:
> >>Wakko Warner wrote:
> >>>I have a Dell Inspiron 5100 with an ATI Radeon Mobility M7 (7500 R100
> >>>PCI ID 1002:4c57 sub 1028:0149).
> >>>
> >>>Immediately when radeon.ko is loaded, the screen goes blank (The
> >>>backlight stays on).  I have fbcon compiled into the kernel (I also
> >>>tried as module). I am unable to get the screen to work again until I
> >>>reboot.  The logs did not appear to have any errors after the module
> >>>loaded.  The system was still responsive on the network.
> >>>
> >>>I tried kernels 2.6.33 and 2.6.34.
> >>>
> >>>I can provide kernel output if needed.
> >>
> >>I need to add that if I use modeset=0, the screen does not blank.
> >>
> >>Also 2.6.34 (with modeset=0) doesn't do 3D very well on this system.  Some
> >>objects look ok, some are garbled, some do not appear at all.  The gears
> >>from xscreensaver does not show up at all.
> >
> >--
> >To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> >the body of a message to majordomo@vger.kernel.org
> >More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >Please read the FAQ at  http://www.tux.org/lkml/
> >
> 
> 
> I've hit a couple of things with radeon as well.. the first was this:
> http://lkml.org/lkml/2010/6/6/172
> (if your hitting this issue, then the patch should work and/or it should 
> already be in the main tree).

Doesn't appear to be.  I mentioned above that I have no errors.  I forgot
about it saying something about the BIOS.  It shows this
[drm:radeon_get_bios] *ERROR* Unable to locate a BIOS ROM

> then a few days ago hit another:
> https://bugzilla.kernel.org/show_bug.cgi?id=16335
> (keep in mind still uncertain on a fix for this, reverting the commit 
> gets me up and running(I created a patch, but an umsure if it's a right 
> solution)).

This one appears to be X related.  In my case, this happens immediately at
radeon.ko load (with modeset=1).
Verification of this was booting with init=/bin/sh and modprobe radeon. 
Instant black screen.  The backlight stays on.

> if none of these are what your hitting, then maybe(if you can) do a 
> bisect on this!

I tried 2.6.32.15.  I noticed that KMS was in staging.  This one didn't do a
black screen.  I saw mostly white, green and a pinkish color.  All were kind
of washed out and were in vertical lines.  KMS on this laptop has not worked
with stock kernels.

I booted Ubuntu 10.04 live CD and it appears that KMS was working.  I don't
know what patches they have in the kernel for this or what is different.

-- 
 Microsoft has beaten Volkswagen's world record.  Volkswagen only created 22
 million bugs.

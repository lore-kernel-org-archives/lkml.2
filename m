Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752714Ab0FWRw2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 13:52:28 -0400
Received: from old-tantale.fifi.org ([64.81.30.200]:35826 "EHLO
	old-tantale.fifi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751506Ab0FWRw1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 13:52:27 -0400
X-Greylist: delayed 567 seconds by postgrey-1.27 at vger.kernel.org; Wed, 23 Jun 2010 13:52:27 EDT
To: Ben Guthro <ben@guthro.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: i915: Dell E6410 Ironlake LVDS detection
References: <AANLkTim362_xv5FAyFSpdnAFUlILliEoGBW8_oZ4QVj1@mail.gmail.com>
Mail-Copies-To: nobody
From: Philippe Troin <phil@fifi.org>
Date: 23 Jun 2010 10:42:55 -0700
In-Reply-To: <AANLkTim362_xv5FAyFSpdnAFUlILliEoGBW8_oZ4QVj1@mail.gmail.com>
Message-ID: <87bpb1fxwg.fsf@old-tantale.fifi.org>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.2
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ben Guthro <ben@guthro.net> writes:

> I have a problematic machine, that I have traced the problem down to
> what I think is an issue with the i915 detection of the LVDS on the
> Ironlake chip.
>
> The machine in question is a Dell Latitude E6410 - i5 quad core
> laptop, with the intel Ironlake chip, and the failure condition is
> such that when the boot sequence switches into KMS mode, the screen
> goes black, and never comes back.

I am seeing similar problems with an HP Elitebook 2540p.

> My base install is Ubuntu 10.04, and I've spun through a few kernels
> to try to bisect the problem. Unfortunately, I've been unable to find
> a kernel that works (including the 2.6.35 RC's, and an ubuntu build of
> drm-intel-next from the beginning of June)

2.6.32 works for me.
2.6.33.5 does not.

I'm currently bisecting the issue, but I do it at a rate of one kernel
a day, so I will need a few more days.

> I can get the machine to come up on an external display, if switched
> at the BIOS screen...but /sys/class/card0 never shows an LVDS
> connector...and dmesg doesn't seem to be throwing any errors.

I'm not sure if this hardware has a LVDS connector.

I was able to boot it with i915 loaded (-> black screen), ssh in and
run xrandr.  Xrandr reported 6 connectors, none of them named LVDS.
It think they were named FP[123].

I was able to turn on an external display connected via VGA with
xrandr and it seemed to be working fine?

Phil.

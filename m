Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752830Ab0LVX1n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 18:27:43 -0500
Received: from colo4.heeltoe.com ([207.210.93.145]:51364 "EHLO
	colo4.heeltoe.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752560Ab0LVX1m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 18:27:42 -0500
X-Greylist: delayed 1626 seconds by postgrey-1.27 at vger.kernel.org; Wed, 22 Dec 2010 18:27:42 EST
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v3] rtc-cmos: fix suspend/resume
From: Paul Fox <pgf@laptop.org>
cc: Daniel Drake <dsd@laptop.org>, a.zummo@towertech.it,
        rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org, rjw@sisk.pl,
        stable@kernel.org
In-reply-to: <20101222141947.94322b9c.akpm@linux-foundation.org> (sfid-20101222_171959_594675_BB7A5BE4)
References: <20101219190828.A6C189D401C@zog.reactivated.net> <20101222141947.94322b9c.akpm@linux-foundation.org> (sfid-20101222_171959_594675_BB7A5BE4)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <8891.1293058835.1@foxharp.boston.ma.us>
Date: Wed, 22 Dec 2010 18:00:35 -0500
Message-ID: <8894.1293058835@foxharp.boston.ma.us>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

andrew wrote:
 > On Sun, 19 Dec 2010 19:08:28 +0000 (GMT)
 > Daniel Drake <dsd@laptop.org> wrote:
 > 
 > > From: Paul Fox <pgf@laptop.org>
 > > 
 > > rtc-cmos was setting suspend/resume hooks at the device_driver level.
 > > However, the platform bus code (drivers/base/platform.c) only looks
 > > for resume hooks at the dev_pm_ops level, or within the platform_driver.
 > > 
 > > Switch rtc_cmos to use dev_pm_ops so that suspend/resume code is
 > > executed again.
 > > 
 > > Signed-off-by: Paul Fox <pgf@laptop.org>
 > > Signed-off-by: Daniel Drake <dsd@laptop.org>
 > > ---
 > >  drivers/rtc/rtc-cmos.c |   16 +++++++++-------
 > >  1 files changed, 9 insertions(+), 7 deletions(-)
 > > 
 > > v2: incorporate feedback from Rafael J. Wysocki, fix tabs, make a bit more
 > > consistent with typical SIMPLE_DEV_PM_OPS users.
 > > 
 > > v3: remove const keyword already set by macro, thanks to Rafael
 > 
 > It's unclear what the user-visible effects of this bug were.  Machine
 > fails to suspend?  RTC loses its brains on resume?  Something else?

the user visible symptom in our (XO laptop) case was that rtcwake
would fail to wake the laptop.  the RTC alarm would expire, but the
wakeup wasn't unmasked.

as for severity, the impact may have been reduced because if i recall
correctly, the bug only affected platforms with CONFIG_PNP disabled.

paul

 > 
 > That's really important information for a bugfix's changelog.  Please
 > never omit it.
 > 
 > 
 > 
 > I'm going to assume that whatever-the-behaviour-is is fairly serious,
 > and that we want this patch in 2.6.37.  So I tagged it for backporting
 > into 2.6.37.1, as we're getting pretty close to 2.6.37.
 > 
 > The patch also applies to 2.6.36.  Is it needed there?  And in earlier
 > kernels?

=---------------------
 paul fox, pgf@laptop.org

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755179Ab1AVAYc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 19:24:32 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46424 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755098Ab1AVAYb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 19:24:31 -0500
Date: Fri, 21 Jan 2011 16:23:25 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, Richard Purdie <rpurdie@rpsys.net>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH] leds: Fix warnings when PM is disabled for BD2802
Message-Id: <20110121162325.c3b513bf.akpm@linux-foundation.org>
In-Reply-To: <20110121233837.GC27943@core.coreip.homeip.net>
References: <1295631217-19591-1-git-send-email-broonie@opensource.wolfsonmicro.com>
	<20110121141402.30aac149.akpm@linux-foundation.org>
	<20110121233837.GC27943@core.coreip.homeip.net>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Jan 2011 15:38:37 -0800 Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:

> > That rather sucks.  It leaves an all-zeroes instance of dev_pm_ops
> > uselessly bloating the driver.
> 
> It is per-driver, not per device so do we really care?

We care about everything.  If the objective was to make life easier for
ourselves, we'd all be on the golf course.

> >  And it leaves
> > bd2802_i2c_driver.driver.pm pointing at that all-zeroes instance of
> > dev_pm_ops, which is rather dangerous.
> 
> Nothing dagerous here - PM core deals with half-filled pm_ops just fine.
> 
> > 
> > If CONFIG_PM_SLEEP=n, the .driver.pm field shouldn't exist at all.
> 
> Meh, we have _waaay_ too many config options, I'd rather see CONFIG_PM
> and possibly CONFIG_PM_SLEEP go, maybe leaving us with
> CONFIG_PM_RUNTIME and maybe not. How many devices out there do not want
> PM?

Don't know.  How do we determine this?

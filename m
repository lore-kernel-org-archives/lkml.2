Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754634Ab1AUXrN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 18:47:13 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45300 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753975Ab1AUXrM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 18:47:12 -0500
Date: Fri, 21 Jan 2011 23:47:11 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Richard Purdie <rpurdie@rpsys.net>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH] leds: Fix warnings when PM is disabled for BD2802
Message-ID: <20110121234711.GB20247@opensource.wolfsonmicro.com>
References: <1295631217-19591-1-git-send-email-broonie@opensource.wolfsonmicro.com> <20110121141402.30aac149.akpm@linux-foundation.org> <20110121233837.GC27943@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110121233837.GC27943@core.coreip.homeip.net>
X-Cookie: You're at the end of the road again.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 21, 2011 at 03:38:37PM -0800, Dmitry Torokhov wrote:
> On Fri, Jan 21, 2011 at 02:14:02PM -0800, Andrew Morton wrote:

> >  And it leaves
> > bd2802_i2c_driver.driver.pm pointing at that all-zeroes instance of
> > dev_pm_ops, which is rather dangerous.

> Nothing dagerous here - PM core deals with half-filled pm_ops just fine.

Indeed, all the PM operations are completly optional so there's no
problem there except for the empty dev_pm_ops we leave lying around for
each driver.

> > If CONFIG_PM_SLEEP=n, the .driver.pm field shouldn't exist at all.

> Meh, we have _waaay_ too many config options, I'd rather see CONFIG_PM
> and possibly CONFIG_PM_SLEEP go, maybe leaving us with
> CONFIG_PM_RUNTIME and maybe not. How many devices out there do not want
> PM?

I made the same point earlier; I guess I'll post an RFC patch over the
weekend.

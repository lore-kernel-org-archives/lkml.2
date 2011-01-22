Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752402Ab1AVKVy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jan 2011 05:21:54 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:41833 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751001Ab1AVKVx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jan 2011 05:21:53 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH] leds: Fix warnings when PM is disabled for BD2802
Date: Sat, 22 Jan 2011 11:21:04 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc1+; KDE/4.4.4; x86_64; ; )
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Richard Purdie <rpurdie@rpsys.net>
References: <1295631217-19591-1-git-send-email-broonie@opensource.wolfsonmicro.com> <20110121233837.GC27943@core.coreip.homeip.net> <20110121234711.GB20247@opensource.wolfsonmicro.com>
In-Reply-To: <20110121234711.GB20247@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201101221121.04840.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, January 22, 2011, Mark Brown wrote:
> On Fri, Jan 21, 2011 at 03:38:37PM -0800, Dmitry Torokhov wrote:
> > On Fri, Jan 21, 2011 at 02:14:02PM -0800, Andrew Morton wrote:
> 
> > >  And it leaves
> > > bd2802_i2c_driver.driver.pm pointing at that all-zeroes instance of
> > > dev_pm_ops, which is rather dangerous.
> 
> > Nothing dagerous here - PM core deals with half-filled pm_ops just fine.
> 
> Indeed, all the PM operations are completly optional so there's no
> problem there except for the empty dev_pm_ops we leave lying around for
> each driver.
> 
> > > If CONFIG_PM_SLEEP=n, the .driver.pm field shouldn't exist at all.

Not if CONFIG_PM_RUNTIME is set (that field is for both SLEEP and RUNTIME).

> > Meh, we have _waaay_ too many config options, I'd rather see CONFIG_PM
> > and possibly CONFIG_PM_SLEEP go, maybe leaving us with
> > CONFIG_PM_RUNTIME and maybe not. How many devices out there do not want
> > PM?

You'd be surprised.

> I made the same point earlier; I guess I'll post an RFC patch over the
> weekend.

The truth is CONFIG_PM was a mistake, because it's practically meaningless
(it basically is always set), so we could remove it, I think, but that
would require us to modify _many_ drivers.

CONFIG_PM_SLEEP is distinctly about suspend and hibernation which people
tend to switch off sometimes.

Thanks,
Rafael

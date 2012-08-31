Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754672Ab2HaRRE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 13:17:04 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55804 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754365Ab2HaRRA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 13:17:00 -0400
Date: Fri, 31 Aug 2012 10:16:56 -0700
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Krystian Garbaciak <krystian.garbaciak@diasemi.com>
Cc: linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com,
        lm-sensors@lm-sensors.org, linux-input@vger.kernel.org,
        linux-watchdog@vger.kernel.org, linux-leds@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>, Liam Girdwood <lrg@ti.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Jean Delvare <khali@linux-fr.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Ashish Jangam <ashish.jangam@kpitcummins.com>,
        Andrew Jones <drjones@redhat.com>, Donggeun Kim <dg77.kim@samsung.com>,
        Philippe =?iso-8859-1?Q?R=E9tornaz?= <philippe.retornaz@epfl.ch>,
        Wim Van Sebroeck <wim@iguana.be>, Bryan Wu <bryan.wu@canonical.com>,
        Richard Purdie <rpurdie@rpsys.net>,
        Anthony Olech <anthony.olech@diasemi.com>
Subject: Re: [PATCH 1/8] mfd: Add Dialog DA906x core driver.
Message-ID: <20120831171655.GC25575@opensource.wolfsonmicro.com>
References: <201208241445@sw-eng-lt-dc-vm2>
 <201208241450@sw-eng-lt-dc-vm2>
 <20120825183113.GE6520@opensource.wolfsonmicro.com>
 <201208311220@sw-eng-lt-dc-vm2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201208311220@sw-eng-lt-dc-vm2>
X-Cookie: You dialed 5483.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 31, 2012 at 12:20:00PM +0100, Krystian Garbaciak wrote:
> > On Fri, Aug 24, 2012 at 02:50:00PM +0100, Krystian Garbaciak wrote:

> > Your selection of people to CC here appears both large and random...

> I've added any maintainer for my modules from maintainer list.

You don't need to CC every single persojn on every single patch, and
quite a few of these people are clearly not active in development.

> > > +inline unsigned int da906x_to_range_reg(u16 reg)
> > > +{
> > > +	return reg + DA906X_MAPPING_BASE;
> > > +}

> > I've no real idea what this stuff is all about, it at least needs some
> > comments somewhere.  The fact that you're just adding a constant offset
> > to all registers is at best odd.

> I will comment it precisely for next version:

This still makes very little sense - this function appears to be
accomplishing very little.  You're adding a constant offset to every
single register address that gets used.  Why are we doing this
dynamically at runtime?

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752796Ab2H3Rrp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 13:47:45 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58834 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751088Ab2H3Rrm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 13:47:42 -0400
Date: Thu, 30 Aug 2012 10:47:38 -0700
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
Subject: Re: [RFC PATCH 2/8] regulator: Add Dialog DA906x voltage regulators
 support.
Message-ID: <20120830174738.GH4356@opensource.wolfsonmicro.com>
References: <201208241450@sw-eng-lt-dc-vm2>
 <201208241455@sw-eng-lt-dc-vm2>
 <20120825151020.GB6520@opensource.wolfsonmicro.com>
 <201208291550@sw-eng-lt-dc-vm2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201208291550@sw-eng-lt-dc-vm2>
X-Cookie: Stay away from flying saucers today.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 29, 2012 at 03:50:00PM +0100, Krystian Garbaciak wrote:

> Because, for some regulators, this is required: val += fvol->offset,
> I was only able to reduce it to the following form.

What on earth makes you say this?  The above is obviously linear.

Besides, you're missing several points here.  One is that you should be
using the framework features, another is that you should be implementing
_sel.

> > > +	bits = da906x_reg_read(hw, DA906X_REG_STATUS_D);
> > > +	if (bits < 0)
> > > +		return IRQ_HANDLED;

> > If you fail to detect an interrupt you report that you handled one...?

> For me there is no sensible return value for this case.

IRQ_NONE.

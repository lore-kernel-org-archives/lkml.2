Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758301Ab0GBJt5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 05:49:57 -0400
Received: from poutre.nerim.net ([62.4.16.124]:52749 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758087Ab0GBJtz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 05:49:55 -0400
Date: Fri, 2 Jul 2010 11:49:49 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: Jim Cromie <jim.cromie@gmail.com>,
       H Hartley Sweeten <hsweeten@visionengravers.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ethan Lawrence <e.law87@yahoo.com>,
       "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "lars4910@hotmail.com" <lars4910@hotmail.com>,
       "birdie@permonline.ru" <birdie@permonline.ru>,
       "jadcock@cox.net" <jadcock@cox.net>
Subject: Re: [PATCH/RFC] hwmon: Add support for W83667HG-B
Message-ID: <20100702114949.3e62ec39@hyperion.delvare>
In-Reply-To: <20100702082530.GC12911@ericsson.com>
References: <1278021735-21188-1-git-send-email-guenter.roeck@ericsson.com>
	<20100702092011.0acd753f@hyperion.delvare>
	<20100702082530.GC12911@ericsson.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guenter,

On Fri, 2 Jul 2010 01:25:30 -0700, Guenter Roeck wrote:
> On Fri, Jul 02, 2010 at 03:20:11AM -0400, Jean Delvare wrote:
> > On Thu, 1 Jul 2010 15:02:15 -0700, Guenter Roeck wrote:
> > > -static const u8 W83627EHF_REG_FAN_MAX_OUTPUT[] = { 0xff, 0x67, 0xff, 0x69 };
> > > -static const u8 W83627EHF_REG_FAN_STEP_OUTPUT[] = { 0xff, 0x68, 0xff, 0x6a };
> > > +
> > > +static const u8 *W83627EHF_REG_FAN_MAX_OUTPUT;
> > > +static const u8 *W83627EHF_REG_FAN_STEP_OUTPUT;
> > > +
> > > +static const u8 W83627EHF_REG_FAN_MAX_OUTPUT_COMMON[]
> > > +						= { 0xff, 0x67, 0xff, 0x69 };
> > > +static const u8 W83627EHF_REG_FAN_STEP_OUTPUT_COMMON[]
> > > +						= { 0xff, 0x68, 0xff, 0x6a };
> > > +
> > > +static const u8 W83627EHF_REG_FAN_MAX_OUTPUT_W83667_B[] = { 0x67, 0x69, 0x6b };
> > > +static const u8 W83627EHF_REG_FAN_STEP_OUTPUT_W83667_B[] = { 0x68, 0x6a, 0x6c };
> > 
> > Is it just me or these arrays aren't used anywhere?
> > 
> > I think I would just drop them. The "0xff" are suspicious in the
> > original arrays, and the size difference between the common and
> > W83667HG-B cases is tricky. Anyone willing to add support for this
> > feature will need to read the datasheets anyway, so you don't add any
> > value by including the register addresses here.
> 
> After removing the defines and trying to compile I remembered.
> I _knew_ there was a reason for not removing them.
> Guess it's too late (or early) here to do serious work.
> 
> The defines _are_ used, in:
> 
> fan_functions(fan_max_output, FAN_MAX_OUTPUT)
> fan_functions(fan_step_output, FAN_STEP_OUTPUT)
> 
> which expands to W83627EHF_REG_FAN_MAX_OUTPUT and W83627EHF_REG_FAN_STEP_OUTPUT.
> 
> Tricky ... and that was also the reason why I retained the original 
> global variables.

Tricky indeed. We normally don't accept code like this in the kernel.

> I'll move the pointers into per-device code as you suggested, but I'll
> have to think about how to do that w/o having to change a lot of code.

If code changes are desirable, let's just do them. You can do that in a
preliminary patch, and then your patch adding support for the
W83667HG-B goes on top of it.

> As for the 0xff - that pretty much applies to all chips supported by this driver. 
> I guess it is supposed to mean "not supported", and as a result the code will
> write to a non-existing register. I don't really want to touch that.

I want you to touch that. Writing to non-existing registers is a bad
idea. You never know what actually happens when you do that.

> The size difference (3 entries vs. 4) doesn't matter, since the chips are both 
> configured to have only three pwm fan controllers (even though the W83667HG
> is supposed to have four per its datasheet). So the 4th element of the arrays
> will not be accessed by the code if W83667HG(-B) is detected.

OK.

-- 
Jean Delvare

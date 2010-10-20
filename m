Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754544Ab0JTRTG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 13:19:06 -0400
Received: from imr3.ericy.com ([198.24.6.13]:54154 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753418Ab0JTRTF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 13:19:05 -0400
Date: Wed, 20 Oct 2010 10:18:06 -0700
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Joe Perches <joe@perches.com>
CC: Jean Delvare <khali@linux-fr.org>, Hans de Goede <j.w.r.degoede@hhs.nl>,
        Alistair John Strachan <alistair@devzero.co.uk>,
        Henrik Rydberg <rydberg@euromail.se>,
        "Mark M. Hoffman" <mhoffman@lightlink.com>,
        Luca Tettamanti <kronos.it@gmail.com>,
        Fenghua Yu <fenghua.yu@intel.com>, Juerg Haefliger <juergh@gmail.com>,
        Eric Piel <eric.piel@tremplin-utc.net>,
        Jim Cromie <jim.cromie@gmail.com>,
        Roger Lucas <vt8231@hiddenengine.co.uk>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drivers/hwmon: Use pr_fmt and pr_<level>
Message-ID: <20101020171806.GD22572@ericsson.com>
References: <1287530020.10409.594.camel@Joe-Laptop>
 <20101020094208.3136b9dd@endymion.delvare>
 <1287590363.1813.148.camel@Joe-Laptop>
 <20101020164929.GB22572@ericsson.com>
 <1287593660.1813.198.camel@Joe-Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1287593660.1813.198.camel@Joe-Laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 20, 2010 at 12:54:20PM -0400, Joe Perches wrote:
> On Wed, 2010-10-20 at 09:49 -0700, Guenter Roeck wrote:
> > On Wed, Oct 20, 2010 at 11:59:23AM -0400,
> >  Joe Perches wrote:
> > [ ... ]
> > > Anyway, I'd like to sort it out eventually.
> > > For now, I just add the #define pr_fmt, with
> > > a long term goal of removing them all and using
> > > a different mechanism to remove the duplicated
> > > prefix string altogether from the formats and
> > > save some text.
> > I don't mind individual pr_fmt defines as long as they are used.
> > However, that is not the case in many of the patches.
> > Just adding a pr_fmt define to a file without using it doesn't make sense to me.
> 
> kernel.h has the equivalent of:
> 
> #define pr_<level>(fmt, arg...) printk(KERN_<level> pr_fmt(fmt), ##arg)
> 
And no one minds that there are literally hundreds of equivalent defines
for pr_fmt in the code, and even more conflicting ones ? Odd.

Maybe the following in kernel.h would make more sense.

#ifndef pr_fmt
#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
#endif

At least it would make more sense than littering source files with pr_fmt definitions.
If that doesn't fly, I would prefer to stick with the existing default definition in kernel.h.
At least that would give people an incentive to fix the problem in kernel.h (or in some other
central location) if they dislike the resulting missing module names.

Thanks,
Guenter

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754927Ab0JTSgn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 14:36:43 -0400
Received: from imr4.ericy.com ([198.24.6.8]:41286 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751288Ab0JTSgm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 14:36:42 -0400
Date: Wed, 20 Oct 2010 11:35:44 -0700
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
Message-ID: <20101020183544.GA22966@ericsson.com>
References: <1287530020.10409.594.camel@Joe-Laptop>
 <20101020094208.3136b9dd@endymion.delvare>
 <1287590363.1813.148.camel@Joe-Laptop>
 <20101020164929.GB22572@ericsson.com>
 <1287593660.1813.198.camel@Joe-Laptop>
 <20101020171806.GD22572@ericsson.com>
 <1287595700.1813.202.camel@Joe-Laptop>
 <20101020174846.GA22819@ericsson.com>
 <1287597762.1813.217.camel@Joe-Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1287597762.1813.217.camel@Joe-Laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 20, 2010 at 02:02:42PM -0400, Joe Perches wrote:
> On Wed, 2010-10-20 at 10:48 -0700, Guenter Roeck wrote:
> > The modified define in kernel.org would only apply if pr_fmt isn't already defined,
> > so that argument is not really correct. The real difference would be that you could
> > then remove the individual pr_fmt defines from 211 files, and all users of pr_fmt
> > without module name (ie those hard to read) would be easier to read/identify.
> 
> I think that's not a good idea for now,
> though I agree with the general concept.
> 
> This is in kernel.h now.
> 
> #ifndef pr_fmt
> #define pr_fmt(fmt) fmt
> #endif
> 
> A lot of the pr_<level> calls already include
> some internal prefix.
> 
> Try:
> $ grep -rP --include=*.[ch] -oh "\bpr_\w+\s*\(\s*\"\w+:" * | \
> 	cut -f2- -d"(" | sort | uniq -c | sort -rn
> 
> You're suggesting modifying 100+ files to get the
> same output used now.
> 
Yes, plus another 200+ files to remove the then-unnecessary existing pr_fmt defines.

> I think doing something like this after some more
> generally accepted agreement is reached on how best
> to do it would be better.
> 
Sounds like the ~400 definitions of TRUE and FALSE in the code base I am working with here.

My take is that the time to reach such an agreement is now, to avoid cluttering more code
with pr_fmt defines. The longer we wait, the more difficult it will get to reach an agreement,
since more and more subsystems will be affected.

Personally, I think the pr_fmt cleanup should be more important than replacing printk
with pr_<level>. But I'll defer to Jean's judgement on this one, and follow his lead.

Guenter

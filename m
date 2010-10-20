Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754715Ab0JTSCq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 14:02:46 -0400
Received: from mail.perches.com ([173.55.12.10]:3373 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753944Ab0JTSCp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 14:02:45 -0400
Subject: Re: [PATCH] drivers/hwmon: Use pr_fmt and pr_<level>
From: Joe Perches <joe@perches.com>
To: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: Jean Delvare <khali@linux-fr.org>, Hans de Goede <j.w.r.degoede@hhs.nl>,
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
In-Reply-To: <20101020174846.GA22819@ericsson.com>
References: <1287530020.10409.594.camel@Joe-Laptop>
	 <20101020094208.3136b9dd@endymion.delvare>
	 <1287590363.1813.148.camel@Joe-Laptop>
	 <20101020164929.GB22572@ericsson.com>
	 <1287593660.1813.198.camel@Joe-Laptop>
	 <20101020171806.GD22572@ericsson.com>
	 <1287595700.1813.202.camel@Joe-Laptop>
	 <20101020174846.GA22819@ericsson.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 20 Oct 2010 11:02:42 -0700
Message-ID: <1287597762.1813.217.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-10-20 at 10:48 -0700, Guenter Roeck wrote:
> The modified define in kernel.org would only apply if pr_fmt isn't already defined,
> so that argument is not really correct. The real difference would be that you could
> then remove the individual pr_fmt defines from 211 files, and all users of pr_fmt
> without module name (ie those hard to read) would be easier to read/identify.

I think that's not a good idea for now,
though I agree with the general concept.

This is in kernel.h now.

#ifndef pr_fmt
#define pr_fmt(fmt) fmt
#endif

A lot of the pr_<level> calls already include
some internal prefix.

Try:
$ grep -rP --include=*.[ch] -oh "\bpr_\w+\s*\(\s*\"\w+:" * | \
	cut -f2- -d"(" | sort | uniq -c | sort -rn

You're suggesting modifying 100+ files to get the
same output used now.

I think doing something like this after some more
generally accepted agreement is reached on how best
to do it would be better.


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753469Ab0JTR2Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 13:28:24 -0400
Received: from mail.perches.com ([173.55.12.10]:3357 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753122Ab0JTR2X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 13:28:23 -0400
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
In-Reply-To: <20101020171806.GD22572@ericsson.com>
References: <1287530020.10409.594.camel@Joe-Laptop>
	 <20101020094208.3136b9dd@endymion.delvare>
	 <1287590363.1813.148.camel@Joe-Laptop>
	 <20101020164929.GB22572@ericsson.com>
	 <1287593660.1813.198.camel@Joe-Laptop>
	 <20101020171806.GD22572@ericsson.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 20 Oct 2010 10:28:20 -0700
Message-ID: <1287595700.1813.202.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-10-20 at 10:18 -0700, Guenter Roeck wrote:
> On Wed, Oct 20, 2010 at 12:54:20PM -0400, Joe Perches wrote:
> > On Wed, 2010-10-20 at 09:49 -0700, Guenter Roeck wrote:
> > > On Wed, Oct 20, 2010 at 11:59:23AM -0400,
> > >  Joe Perches wrote:
> > > [ ... ]
> > > > Anyway, I'd like to sort it out eventually.
> > > > For now, I just add the #define pr_fmt, with
> > > > a long term goal of removing them all and using
> > > > a different mechanism to remove the duplicated
> > > > prefix string altogether from the formats and
> > > > save some text.
> > > I don't mind individual pr_fmt defines as long as they are used.
> > > However, that is not the case in many of the patches.
> > > Just adding a pr_fmt define to a file without using it doesn't make sense to me.
> > kernel.h has the equivalent of:
> > #define pr_<level>(fmt, arg...) printk(KERN_<level> pr_fmt(fmt), ##arg)
> > 
> And no one minds that there are literally hundreds of equivalent defines
> for pr_fmt in the code, and even more conflicting ones ? Odd.
> 
> Maybe the following in kernel.h would make more sense.
> 
> #ifndef pr_fmt
> #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> #endif
> 
> At least it would make more sense than littering source files with pr_fmt definitions.
> If that doesn't fly, I would prefer to stick with the existing default definition in kernel.h.

That would give you no prefix at all and make the
logging messages harder to distinguish.

> At least that would give people an incentive to fix the problem in kernel.h (or in some other
> central location) if they dislike the resulting missing module names.

I don't think it flies for another year or two.

$ grep -Prh --include=*.[ch] "define\s*pr_fmt" * | \
	perl -p -e 's/[ \t]+/ /g' | \
	sort | uniq -c | sort -rn
    211 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
     93 #define pr_fmt(fmt) KMSG_COMPONENT ": " fmt
     16 #define pr_fmt(fmt) KBUILD_MODNAME ":%s(): " fmt, __func__
     16 #define pr_fmt(fmt) KBUILD_MODNAME ":%s: " fmt, __func__
      4 #define pr_fmt(fmt) "intc: " fmt
      4 #define pr_fmt(fmt) "ep93xx " KBUILD_MODNAME ": " fmt
      3 #define pr_fmt(fmt) "%s: " fmt, __func__
      3 #define pr_fmt(fmt) DRV_MODULE_NAME ": " fmt
      2 #define pr_fmt(fmt) "gcov: " fmt
      2 #define pr_fmt(fmt) fmt
      2 #define pr_fmt(fmt) DRV_NAME ": " fmt
      1 #define pr_fmt(fmt) "viod: " fmt
      1 #define pr_fmt(fmt) "tboot: " fmt
      1 #define pr_fmt(fmt) "(stll) :" fmt
      1 #define pr_fmt(fmt) "(stk) :" fmt
      1 #define pr_fmt(fmt) "(stc): " fmt
      1 #define pr_fmt(fmt) "PMU: " fmt
      1 #define pr_fmt(fmt) "pit: " fmt
      1 #define pr_fmt(fmt) "phram: " fmt
      1 #define pr_fmt(fmt) "PCI: " fmt
      1 #define pr_fmt(fmt) "module %s: " fmt
      1 #define pr_fmt(fmt) "mmiotrace: " fmt
      1 #define pr_fmt(fmt) KBUILD_MODNAME " WATCHDOG: " fmt
      1 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt /* Append 'batman-adv: ' before
      1 #define pr_fmt(fmt) KBUILD_MODNAME " " fmt
      1 #define pr_fmt(fmt) KBUILD_BASENAME ": " fmt
      1 #define pr_fmt(fmt) "isram: " fmt
      1 #define pr_fmt(fmt) "hw perfevents: " fmt
      1 #define pr_fmt(fmt) "hw-breakpoint: " fmt
      1 #define pr_fmt(fmt) DRIVER_NAME ": " fmt
      1 #define pr_fmt(fmt) "cxgb: " fmt
      1 #define pr_fmt(fmt) "cn_test: " fmt
      1 #define pr_fmt(fmt) "clock: " fmt
      1 #define pr_fmt(fmt) "acerhdf: " fmt



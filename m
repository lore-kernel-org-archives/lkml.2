Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754325Ab0JTQyY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 12:54:24 -0400
Received: from mail.perches.com ([173.55.12.10]:3345 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752141Ab0JTQyX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 12:54:23 -0400
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
In-Reply-To: <20101020164929.GB22572@ericsson.com>
References: <1287530020.10409.594.camel@Joe-Laptop>
	 <20101020094208.3136b9dd@endymion.delvare>
	 <1287590363.1813.148.camel@Joe-Laptop>
	 <20101020164929.GB22572@ericsson.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 20 Oct 2010 09:54:20 -0700
Message-ID: <1287593660.1813.198.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-10-20 at 09:49 -0700, Guenter Roeck wrote:
> On Wed, Oct 20, 2010 at 11:59:23AM -0400,
>  Joe Perches wrote:
> [ ... ]
> > Anyway, I'd like to sort it out eventually.
> > For now, I just add the #define pr_fmt, with
> > a long term goal of removing them all and using
> > a different mechanism to remove the duplicated
> > prefix string altogether from the formats and
> > save some text.
> I don't mind individual pr_fmt defines as long as they are used.
> However, that is not the case in many of the patches.
> Just adding a pr_fmt define to a file without using it doesn't make sense to me.

kernel.h has the equivalent of:

#define pr_<level>(fmt, arg...) printk(KERN_<level> pr_fmt(fmt), ##arg)

so the added "#define pr_fmt(fmt)..."s are used
wherever pr_<level> is done.



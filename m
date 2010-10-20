Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755335Ab0JTTUA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 15:20:00 -0400
Received: from mailbigip.dreamhost.com ([208.97.132.5]:49498 "EHLO
	homiemail-a10.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754665Ab0JTTT7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 15:19:59 -0400
Subject: Re: [PATCH] drivers/hwmon: Use pr_fmt and pr_<level>
From: Davidlohr Bueso <dave@gnu.org>
Reply-To: dave@gnu.org
To: Jean Delvare <khali@linux-fr.org>
Cc: Joe Perches <joe@perches.com>, Guenter Roeck <guenter.roeck@ericsson.com>,
        Hans de Goede <j.w.r.degoede@hhs.nl>,
        Alistair John Strachan <alistair@devzero.co.uk>,
        Henrik Rydberg <rydberg@euromail.se>,
        "Mark M. Hoffman" <mhoffman@lightlink.com>,
        Luca Tettamanti <kronos.it@gmail.com>,
        Fenghua Yu <fenghua.yu@intel.com>, Juerg Haefliger <juergh@gmail.com>,
        Eric Piel <eric.piel@tremplin-utc.net>,
        Jim Cromie <jim.cromie@gmail.com>,
        Roger Lucas <vt8231@hiddenengine.co.uk>, lm-sensors@lm-sensors.org,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20101020094208.3136b9dd@endymion.delvare>
References: <1287530020.10409.594.camel@Joe-Laptop>
	 <20101020094208.3136b9dd@endymion.delvare>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 20 Oct 2010 16:19:46 -0300
Message-ID: <1287602386.2210.6.camel@cowboy>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-10-20 at 09:42 +0200, Jean Delvare wrote:
> Hi Joe,
> 
> On Tue, 19 Oct 2010 16:13:40 -0700, Joe Perches wrote:
> > Convert printks to pr_<level>
> > Coalesce long formats
> > Removed prefixes from formats
> > Added #define pr_fmt KBUILD_MODNAME ": " fmt
> > Standardized abitguru messages for reporting and finding MAINTAINER
> > (...)
> > diff --git a/drivers/hwmon/abituguru.c b/drivers/hwmon/abituguru.c
> > index 03694cc..8f07a9d 100644
> > --- a/drivers/hwmon/abituguru.c
> > +++ b/drivers/hwmon/abituguru.c
> > @@ -20,6 +20,9 @@
> >      the custom Abit uGuru chip found on Abit uGuru motherboards. Note: because
> >      of lack of specs the CPU/RAM voltage & frequency control is not supported!
> >  */
> > +
> > +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> > +
> >  #include <linux/module.h>
> 
> It looks odd that every driver would have to set this. Shouldn't this
> be the default set in <linux/kernel.h>? Something like:
> 
> #ifndef pr_fmt
> #ifdef KBUILD_MODNAME
> #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> #else
> #define pr_fmt(fmt) fmt
> #endif /* KBUILD_MODNAME */
> #endif
> 

Well we do have this:
#ifndef pr_fmt
#define pr_fmt(fmt) fmt
#endif

Cheers,
Davidlohr


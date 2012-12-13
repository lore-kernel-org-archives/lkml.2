Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756418Ab2LMReo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 12:34:44 -0500
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:31778 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755490Ab2LMRen (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 12:34:43 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+YNqn7FIJV4cWIx9GqbFOt
Date: Thu, 13 Dec 2012 09:34:33 -0800
From: Tony Lindgren <tony@atomide.com>
To: Jon Hunter <jon-hunter@ti.com>
Cc: NeilBrown <neilb@suse.de>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Grant Erickson <marathon96@gmail.com>, linux-omap@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] OMAP: add pwm driver using dmtimers.
Message-ID: <20121213173433.GD4989@atomide.com>
References: <20121212192430.50cea126@notabene.brown>
 <50C8ABFC.3080309@ti.com>
 <20121213140635.4eda5858@notabene.brown>
 <50CA0B4D.2000302@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50CA0B4D.2000302@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jon Hunter <jon-hunter@ti.com> [121213 09:11]:
> On 12/12/2012 09:06 PM, NeilBrown wrote:
> > On Wed, 12 Dec 2012 10:08:28 -0600 Jon Hunter <jon-hunter@ti.com> wrote:
> >> On 12/12/2012 02:24 AM, NeilBrown wrote:
> >>> +
> >>> +#include <plat/dmtimer.h>
> >>
> >> This is going to be a problem for the single zImage work, because we
> >> cannot include any plat headers in driver code any more. Therefore,
> >> although it is not ideal, one way to handle this is pass function
> >> pointers to the various dmtimer APIs that are needed via the platform
> >> data. Painful I know ...
> > 
> > But that doesn't work with devicetree does it?
> 
> Ugh, you are right! This is becoming an increasing problem.
> 
> > Can't we move the dmtimer.h file to include/linux/omap-dmtimer.h or something?
> 
> I can ask Tony if he thinks we could do that.

Yeah we need to fix this somehow. First we need to limit that header
to the minimum and have most of it in a local header file for the
clocksource and clockevent. Then let's move the minimal header to
include/linux/omap-dmtimer.h until we have something Linux generic
available for doing things like this.

Regards,

Tony

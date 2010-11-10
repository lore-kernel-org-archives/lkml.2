Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753718Ab0KJR6g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 12:58:36 -0500
Received: from imr4.ericy.com ([198.24.6.8]:56784 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751505Ab0KJR6f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 12:58:35 -0500
Date: Wed, 10 Nov 2010 09:57:41 -0800
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Henrik Rydberg <rydberg@euromail.se>
CC: Jean Delvare <khali@linux-fr.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 04/11] hwmon: applesmc: Introduce a register lookup
 table (rev2)
Message-ID: <20101110175741.GB18472@ericsson.com>
References: <1289315711-3011-1-git-send-email-rydberg@euromail.se>
 <1289315711-3011-5-git-send-email-rydberg@euromail.se>
 <1289329469.22931.221.camel@groeck-laptop>
 <4CD9A1DC.2000407@euromail.se>
 <1289336024.22931.243.camel@groeck-laptop>
 <4CDA7A94.7070302@euromail.se>
 <20101110154235.GA31170@ericsson.com>
 <4CDAD2FE.3020506@euromail.se>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4CDAD2FE.3020506@euromail.se>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 10, 2010 at 12:14:38PM -0500, Henrik Rydberg wrote:
> >>
> 
> >> Looking at this again, it seems there are two other problems as well. Firstly,
> >> the cache memory is not freed after probe failure, my apologies. Secondly,
> >> execution continues after a probe failure, and the initialization is retried. I
> >> would like to push the latter problem to some other occasion, since the whole
> >> platform logic should be rewritten for the new interface, anyways.
> >>
> > I see the cache problem; this is indeed a tricky one, since it is actually not yet
> > a problem after this patch, but will be one after patch 5.
> > 
> > I don't understand the second problem, though. Looking into the code,
> > the probe function will return an error if applesmc_init_smcreg() fails.
> > Am I missing something ? What execution continues ?
> 
> 
> I think drivers/base/dd.c:142 shows the problem clearly. Basically, the probe
> function is supposed to do the proper initialization, if successful. The driver
> code has been rewritten heavily since the days of the applesmc, and the actual
> probe error is now masked in a rather ugly fashion to allow the driver matching
> to continue. It seems to me that the only clean way around this is to actually
> implement the correct platform driver logic.
> 
Ok, guess there is nothing we can do about that. I'll apply the rest of your series.

Thanks,
Guenter


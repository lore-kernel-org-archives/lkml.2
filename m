Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932801Ab0FRTO2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 15:14:28 -0400
Received: from imr3.ericy.com ([198.24.6.13]:52045 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752030Ab0FRTO0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 15:14:26 -0400
Subject: Re: [lm-sensors] [PATCH 1/3] hwmon: Driver for SMM665 Six-Channel
 Active DC Output Controller/Monitor
From: Guenter Roeck <guenter.roeck@ericsson.com>
Reply-To: guenter.roeck@ericsson.com
To: Jonathan Cameron <jic23@cam.ac.uk>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
       Hans de Goede <hdegoede@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <4C1BB698.2090003@cam.ac.uk>
References: <1276877194-28214-1-git-send-email-guenter.roeck@ericsson.com>
	 <1276877194-28214-2-git-send-email-guenter.roeck@ericsson.com>
	 <4C1BB2AC.4090308@jic23.retrosnub.co.uk>  <4C1BB698.2090003@cam.ac.uk>
Content-Type: text/plain; charset="UTF-8"
Organization: Ericsson
Date: Fri, 18 Jun 2010 12:13:25 -0700
Message-ID: <1276888405.2631.495.camel@groeck-laptop>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-06-18 at 14:10 -0400, Jonathan Cameron wrote:
> On 06/18/10 18:53, Jonathan Cameron wrote:
> >
> > Hi,
> >
> > I've taken a quick look through this code.
> >
> > One or two specific comments below.
> >
> > Only big question is why have the limit functionality in this driver?
> > Given the device has no hardware support and you don't have any form
> > of regular polling (I think) then these limits will only be noticed if
> > you query them. Hence why not leave this job to userspace?
> >
> > I'm not saying you are wrong to do this. Just that you need to explain
> > your reasoning alongside the patch.
> 
> Another quick query.  Are the _min / _max attributes as defined in the
> abi meant for alarms?  I always thought they were to tell userspace the
> limits on measurement?
> 
Good question. I thought it is supposed to refer to alarm limits, but I
may be wrong. 

Browsing through a couple of drivers, it _looks_ like the values are
used for alarm limits (eg adm1025 or lm85). Limits are not always set to
useful values, though. This is what my CPU board returns:

lm85-i2c-0-2e
Adapter: SMBus PIIX4 adapter at 0580
V1.5:        +1.80 V  (min =  +0.00 V, max =  +3.32 V)   
VCore:       +1.29 V  (min =  +0.00 V, max =  +2.99 V)   
V3.3:        +3.32 V  (min =  +0.00 V, max =  +4.38 V)   
V5:          +5.00 V  (min =  +0.00 V, max =  +6.64 V)   
V12:        +12.12 V  (min =  +0.00 V, max = +15.94 V)   

The lm85 datasheet says: "If a voltage input either exceeds the value
set in the voltage high limit register or falls below the value set in
the voltage low limit register, the corresponding bit will be set
automatically by the LM85 in the interrupt status registers (41-42h)."

> Either way, one of us has misunderstood so perhaps the documentation needs
> to be more specific....

Agreed.

Guenter



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754898Ab0FSI1d (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jun 2010 04:27:33 -0400
Received: from poutre.nerim.net ([62.4.16.124]:62204 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754803Ab0FSI1b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jun 2010 04:27:31 -0400
Date: Sat, 19 Jun 2010 10:27:29 +0200
From: Jean Delvare <khali@linux-fr.org>
To: guenter.roeck@ericsson.com
Cc: Jonathan Cameron <jic23@cam.ac.uk>, Hans de Goede <hdegoede@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>
Subject: Re: [lm-sensors] [PATCH 1/3] hwmon: Driver for SMM665 Six-Channel 
 Active DC Output Controller/Monitor
Message-ID: <20100619102729.2ce12447@hyperion.delvare>
In-Reply-To: <1276888405.2631.495.camel@groeck-laptop>
References: <1276877194-28214-1-git-send-email-guenter.roeck@ericsson.com>
	<1276877194-28214-2-git-send-email-guenter.roeck@ericsson.com>
	<4C1BB2AC.4090308@jic23.retrosnub.co.uk>
	<4C1BB698.2090003@cam.ac.uk>
	<1276888405.2631.495.camel@groeck-laptop>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Jun 2010 12:13:25 -0700, Guenter Roeck wrote:
> On Fri, 2010-06-18 at 14:10 -0400, Jonathan Cameron wrote:
> > Another quick query.  Are the _min / _max attributes as defined in the
> > abi meant for alarms?  I always thought they were to tell userspace the
> > limits on measurement?
> > 
> Good question. I thought it is supposed to refer to alarm limits, but I
> may be wrong. 
> 
> Browsing through a couple of drivers, it _looks_ like the values are
> used for alarm limits (eg adm1025 or lm85). Limits are not always set to

Yes, these are alarms. _min and _max are really misnomers, these should
have been _low and _high but by the time I realized it, _min and _max
were already de facto standards and it was too late to change this.

Documentation/hwmon/sysfs-interface says:

Usual items are "input" (measured value), "max" (high threshold,
"min" (low threshold).

Specific occurrences are then left without details. If you think this
document can be improved, I welcome patches.

> useful values, though. This is what my CPU board returns:
> 
> lm85-i2c-0-2e
> Adapter: SMBus PIIX4 adapter at 0580
> V1.5:        +1.80 V  (min =  +0.00 V, max =  +3.32 V)   
> VCore:       +1.29 V  (min =  +0.00 V, max =  +2.99 V)   
> V3.3:        +3.32 V  (min =  +0.00 V, max =  +4.38 V)   
> V5:          +5.00 V  (min =  +0.00 V, max =  +6.64 V)   
> V12:        +12.12 V  (min =  +0.00 V, max = +15.94 V)   
> 
> The lm85 datasheet says: "If a voltage input either exceeds the value
> set in the voltage high limit register or falls below the value set in
> the voltage low limit register, the corresponding bit will be set
> automatically by the LM85 in the interrupt status registers (41-42h)."
> 
> > Either way, one of us has misunderstood so perhaps the documentation needs
> > to be more specific....
> 
> Agreed.

-- 
Jean Delvare

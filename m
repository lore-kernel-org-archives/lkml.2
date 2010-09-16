Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755330Ab0IPPiL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 11:38:11 -0400
Received: from imr3.ericy.com ([198.24.6.13]:58708 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753225Ab0IPPiK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 11:38:10 -0400
Date: Thu, 16 Sep 2010 08:37:15 -0700
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Jean Delvare <khali@linux-fr.org>
CC: Randy Dunlap <rdunlap@xenotime.net>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] hwmon: (adm1031) Replace update_rate sysfs
 attribute with update_interval
Message-ID: <20100916153715.GE14165@ericsson.com>
References: <1284602835-7605-1-git-send-email-guenter.roeck@ericsson.com>
 <1284602835-7605-2-git-send-email-guenter.roeck@ericsson.com>
 <20100916171443.0322bdb6@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100916171443.0322bdb6@hyperion.delvare>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 16, 2010 at 11:14:43AM -0400, Jean Delvare wrote:
> On Wed, 15 Sep 2010 19:07:14 -0700, Guenter Roeck wrote:
> > The attribute reflects an interval, not a rate.
> > 
> > Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
> > ---
> >  Documentation/hwmon/sysfs-interface |   12 +++++-----
> >  drivers/hwmon/adm1031.c             |   43 +++++++++++++++++++---------------
> >  2 files changed, 30 insertions(+), 25 deletions(-)
> > 
> > diff --git a/Documentation/hwmon/sysfs-interface b/Documentation/hwmon/sysfs-interface
> > index ff45d1f..df0cdd2 100644
> > --- a/Documentation/hwmon/sysfs-interface
> > +++ b/Documentation/hwmon/sysfs-interface
> > @@ -91,13 +91,13 @@ name		The chip name.
> >  		I2C devices get this attribute created automatically.
> >  		RO
> >  
> > -update_rate	The rate at which the chip will update readings.
> > -		Unit: millisecond
> > +update_interval	The interval at which the chip or driver will update readings.
> 
> I think I prefer the original wording. The attribute is really about
> setting the register refresh rate at the hardware level. The fact that
> register cache lifetime in the driver can be adjusted accordingly is an
> optional implementation detail IMHO.
> 
Ok, no problem.

> > +		Unit: milliseconds
> 
> Why change? All other units are singular in the file.
> 
Correct for anything but "milliseconds".

I changed it to milliseconds because all other attributes specify
"milliseconds". No other reason. Am I missing something ?

> >  		RW
> > -		Some devices have a variable update rate. This attribute
> > -		can be used to change the update rate to the desired
> > -		frequency.
> > -
> 
> Killing an innocent blank line ;)
> 
Just trying to sneak it through. Got me there.

> > +		Some devices have a variable update rate or interval.
> > +		Some drivers may want to make the update interval configurable
> > +		instead of using a hardcoded value. This attribute can be used
> > +		to change the update interval to the desired value.
> >  
> > +           instead of using a hardcoded value." 
> >  ************
> >  * Voltages *
> 
> I'm fine with all the rest.
> 
> -- 
> Jean Delvare

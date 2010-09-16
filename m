Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756031Ab0IPToU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 15:44:20 -0400
Received: from imr4.ericy.com ([198.24.6.8]:57258 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754570Ab0IPToT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 15:44:19 -0400
Subject: Re: [PATCH 1/2] hwmon: (adm1031) Replace update_rate sysfs
 attribute with update_interval
From: Guenter Roeck <guenter.roeck@ericsson.com>
Reply-To: guenter.roeck@ericsson.com
To: Jean Delvare <khali@linux-fr.org>
CC: Randy Dunlap <rdunlap@xenotime.net>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20100916184237.3be9250d@hyperion.delvare>
References: <1284602835-7605-1-git-send-email-guenter.roeck@ericsson.com>
	 <1284602835-7605-2-git-send-email-guenter.roeck@ericsson.com>
	 <20100916171443.0322bdb6@hyperion.delvare>
	 <20100916153715.GE14165@ericsson.com>
	 <20100916184237.3be9250d@hyperion.delvare>
Content-Type: text/plain; charset="UTF-8"
Organization: Ericsson
Date: Thu, 16 Sep 2010 12:43:15 -0700
Message-ID: <1284666195.15696.35.camel@groeck-laptop>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-09-16 at 12:42 -0400, Jean Delvare wrote:
> On Thu, 16 Sep 2010 08:37:15 -0700, Guenter Roeck wrote:
> > On Thu, Sep 16, 2010 at 11:14:43AM -0400, Jean Delvare wrote:
> > > On Wed, 15 Sep 2010 19:07:14 -0700, Guenter Roeck wrote:
> > > > The attribute reflects an interval, not a rate.
> > > > 
> > > > Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
> > > > ---
> > > >  Documentation/hwmon/sysfs-interface |   12 +++++-----
> > > >  drivers/hwmon/adm1031.c             |   43 +++++++++++++++++++---------------
> > > >  2 files changed, 30 insertions(+), 25 deletions(-)
> > > > 
> > > > diff --git a/Documentation/hwmon/sysfs-interface b/Documentation/hwmon/sysfs-interface
> > > > index ff45d1f..df0cdd2 100644
> > > > --- a/Documentation/hwmon/sysfs-interface
> > > > +++ b/Documentation/hwmon/sysfs-interface
> > > > @@ -91,13 +91,13 @@ name		The chip name.
> > > >  		I2C devices get this attribute created automatically.
> > > >  		RO
> > > >  
> > > > -update_rate	The rate at which the chip will update readings.
> > > > -		Unit: millisecond
> > > > +update_interval	The interval at which the chip or driver will update readings.
> > > 
> > > I think I prefer the original wording. The attribute is really about
> > > setting the register refresh rate at the hardware level. The fact that
> > > register cache lifetime in the driver can be adjusted accordingly is an
> > > optional implementation detail IMHO.
> > > 
> > Ok, no problem.
> > 
> > > > +		Unit: milliseconds
> > > 
> > > Why change? All other units are singular in the file.
> > > 
> > Correct for anything but "milliseconds".
> > 
> > I changed it to milliseconds because all other attributes specify
> > "milliseconds". No other reason. Am I missing something ?
> 
> I'd rather change all these to "millisecond", so that the document
> consistently uses singular for all units.
> 
> I also see that the indentation isn't consistent, with power and energy
> having 4 tabs where the rest has only 2. Bah.
> 
To get beyond this ... how about you apply my rev2, and I make the other
changes (formatting and milliseconds --> millisecond) in a subsequent
patch ?

Guenter



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753964Ab0IPQm6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 12:42:58 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:39337 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753139Ab0IPQm5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 12:42:57 -0400
Date: Thu, 16 Sep 2010 18:42:37 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>, lm-sensors@lm-sensors.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] hwmon: (adm1031) Replace update_rate sysfs 
 attribute with update_interval
Message-ID: <20100916184237.3be9250d@hyperion.delvare>
In-Reply-To: <20100916153715.GE14165@ericsson.com>
References: <1284602835-7605-1-git-send-email-guenter.roeck@ericsson.com>
	<1284602835-7605-2-git-send-email-guenter.roeck@ericsson.com>
	<20100916171443.0322bdb6@hyperion.delvare>
	<20100916153715.GE14165@ericsson.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Sep 2010 08:37:15 -0700, Guenter Roeck wrote:
> On Thu, Sep 16, 2010 at 11:14:43AM -0400, Jean Delvare wrote:
> > On Wed, 15 Sep 2010 19:07:14 -0700, Guenter Roeck wrote:
> > > The attribute reflects an interval, not a rate.
> > > 
> > > Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
> > > ---
> > >  Documentation/hwmon/sysfs-interface |   12 +++++-----
> > >  drivers/hwmon/adm1031.c             |   43 +++++++++++++++++++---------------
> > >  2 files changed, 30 insertions(+), 25 deletions(-)
> > > 
> > > diff --git a/Documentation/hwmon/sysfs-interface b/Documentation/hwmon/sysfs-interface
> > > index ff45d1f..df0cdd2 100644
> > > --- a/Documentation/hwmon/sysfs-interface
> > > +++ b/Documentation/hwmon/sysfs-interface
> > > @@ -91,13 +91,13 @@ name		The chip name.
> > >  		I2C devices get this attribute created automatically.
> > >  		RO
> > >  
> > > -update_rate	The rate at which the chip will update readings.
> > > -		Unit: millisecond
> > > +update_interval	The interval at which the chip or driver will update readings.
> > 
> > I think I prefer the original wording. The attribute is really about
> > setting the register refresh rate at the hardware level. The fact that
> > register cache lifetime in the driver can be adjusted accordingly is an
> > optional implementation detail IMHO.
> > 
> Ok, no problem.
> 
> > > +		Unit: milliseconds
> > 
> > Why change? All other units are singular in the file.
> > 
> Correct for anything but "milliseconds".
> 
> I changed it to milliseconds because all other attributes specify
> "milliseconds". No other reason. Am I missing something ?

I'd rather change all these to "millisecond", so that the document
consistently uses singular for all units.

I also see that the indentation isn't consistent, with power and energy
having 4 tabs where the rest has only 2. Bah.

-- 
Jean Delvare

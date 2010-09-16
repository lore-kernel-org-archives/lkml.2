Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755503Ab0IPQBZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 12:01:25 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:35993 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754429Ab0IPQBY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 12:01:24 -0400
Date: Thu, 16 Sep 2010 18:01:12 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Guenter Roeck <guenter.roeck@ericsson.com>,
        Randy Dunlap <rdunlap@xenotime.net>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] [PATCH 1/2] hwmon: (adm1031) Replace update_rate 
 sysfs attribute with update_interval
Message-ID: <20100916180112.2ce29d2a@hyperion.delvare>
In-Reply-To: <20100916154243.GB25145@khazad-dum.debian.net>
References: <1284602835-7605-1-git-send-email-guenter.roeck@ericsson.com>
	<1284602835-7605-2-git-send-email-guenter.roeck@ericsson.com>
	<20100916171443.0322bdb6@hyperion.delvare>
	<20100916154243.GB25145@khazad-dum.debian.net>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Sep 2010 12:42:43 -0300, Henrique de Moraes Holschuh wrote:
> On Thu, 16 Sep 2010, Jean Delvare wrote:
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
> 
> Only, it doesn't set any rates in the hardware.  It sets the period
> (interval).
> 
> If the unit of update_rate is changed to Hz, and the driver does
> hardware_timer_milliseconds = 1000/update_rate_Hz, THEN it will be
> correct to call it a rate...

I agree. My point was really only about "chip or driver" vs. "chip".

> I'd rather have it in Hz, actually.  I consider that more user-friendly.
> But that's just personal preference.

The problem with Hz is that we need to be able to handle values lower
than 1, and mHz as a unit isn't exactly friendly. I would be very fine
with Hz (especially as we use it for pwmN_freq already) if we didn't
have to support frequencies below 1 Hz. For such low frequencies,
period (or interval) is clearer than frequency IMHO.

-- 
Jean Delvare

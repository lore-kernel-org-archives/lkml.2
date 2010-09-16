Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755425Ab0IPPms (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 11:42:48 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:55863 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753629Ab0IPPmr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 11:42:47 -0400
X-Sasl-enc: pI/l45yIc4l+NiLzPMKCvoMZZA0/q661l/qRLrF6qjSS 1284651766
Date: Thu, 16 Sep 2010 12:42:43 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Jean Delvare <khali@linux-fr.org>
Cc: Guenter Roeck <guenter.roeck@ericsson.com>,
        Randy Dunlap <rdunlap@xenotime.net>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] [PATCH 1/2] hwmon: (adm1031) Replace update_rate
 sysfs attribute with update_interval
Message-ID: <20100916154243.GB25145@khazad-dum.debian.net>
References: <1284602835-7605-1-git-send-email-guenter.roeck@ericsson.com>
 <1284602835-7605-2-git-send-email-guenter.roeck@ericsson.com>
 <20100916171443.0322bdb6@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100916171443.0322bdb6@hyperion.delvare>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Sep 2010, Jean Delvare wrote:
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

Only, it doesn't set any rates in the hardware.  It sets the period
(interval).

If the unit of update_rate is changed to Hz, and the driver does
hardware_timer_milliseconds = 1000/update_rate_Hz, THEN it will be
correct to call it a rate...

I'd rather have it in Hz, actually.  I consider that more user-friendly.
But that's just personal preference.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh

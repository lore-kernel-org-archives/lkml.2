Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752269Ab0HZRxG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 13:53:06 -0400
Received: from imr4.ericy.com ([198.24.6.8]:43239 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752023Ab0HZRxA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 13:53:00 -0400
Date: Thu, 26 Aug 2010 10:51:41 -0700
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
CC: Jean Delvare <khali@linux-fr.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        Randy Dunlap <rdunlap@xenotime.net>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>
Subject: Re: [lm-sensors] [PATCH] hwmon: Add tempX_emergency to sysfs ABI
Message-ID: <20100826175141.GA19646@ericsson.com>
References: <1282838085-7210-1-git-send-email-guenter.roeck@ericsson.com>
 <20100826161022.GA1383@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100826161022.GA1383@khazad-dum.debian.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 26, 2010 at 12:10:23PM -0400, Henrique de Moraes Holschuh wrote:
> On Thu, 26 Aug 2010, Guenter Roeck wrote:
> > Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
> > ---
> > tempX_emergency will be used by max6696. It can also be used for other chips
> > supporting three upper temperature limits.
> > 
> >  Documentation/hwmon/sysfs-interface |    6 ++++++
> >  1 files changed, 6 insertions(+), 0 deletions(-)
> > 
> > diff --git a/Documentation/hwmon/sysfs-interface b/Documentation/hwmon/sysfs-interface
> > index ff45d1f..1ceb2b9 100644
> > --- a/Documentation/hwmon/sysfs-interface
> > +++ b/Documentation/hwmon/sysfs-interface
> > @@ -310,6 +310,12 @@ temp[1-*]_crit_hyst
> >  		from the critical value.
> >  		RW
> >  
> > +temp[1-*]_emergency
> > +		Temperature emergency value, typically greater than
> > +		corresponding temp_crit values.
> > +		Unit: millidegree Celsius
> > +		RW
> > +
> 
> If we have two-level alarms: critical, then emergency, it is best to have
> that written down than to imply it by "typically greater than corresponding
> temp_crit"...
> 
How about:
        Temperature emergency max value, for chips supporting more than
        two upper temperature limits. Must be equal or greater than
        corresponding temp_crit values.
        Unit: millidegree Celsius
        RW

Guenter

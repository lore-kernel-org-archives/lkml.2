Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753563Ab0GKQSM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jul 2010 12:18:12 -0400
Received: from imr1.ericy.com ([198.24.6.9]:41676 "EHLO imr1.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751523Ab0GKQSK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jul 2010 12:18:10 -0400
Date: Sun, 11 Jul 2010 09:16:58 -0700
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Joe Perches <joe@perches.com>
CC: Jean Delvare <khali@linux-fr.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Hans de Goede <hdegoede@redhat.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Goyette <paul@whooppee.com>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>
Subject: Re: [PATCH v2] hwmon: Add support for JEDEC JC 42.4 compliant
 temperature sensors
Message-ID: <20100711161658.GA23927@ericsson.com>
References: <1278859984-22593-1-git-send-email-guenter.roeck@ericsson.com>
 <1278862266.1501.59.camel@Joe-Laptop.home>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1278862266.1501.59.camel@Joe-Laptop.home>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 11, 2010 at 11:31:06AM -0400, Joe Perches wrote:
> On Sun, 2010-07-11 at 07:53 -0700, Guenter Roeck wrote:
> > diff --git a/drivers/hwmon/jc42.c b/drivers/hwmon/jc42.c
> > new file mode 100644
> > index 0000000..685057d
> > --- /dev/null
> > +++ b/drivers/hwmon/jc42.c
> []
> > +struct jc42_chips {
> > +	u16 manid;
> > +	u16 devid;
> > +	u16 devid_mask;
> > +};
> > +
> > +static struct jc42_chips jc42_chips[] = {
> > +	{ ADT_MANID, ADT7408_DEVID, ADT7408_DEVID_MASK },
> > +	{ IDT_MANID, TS3000B3_DEVID, TS3000B3_DEVID_MASK },
> > +	{ MAX_MANID, MAX6604_DEVID, MAX6604_DEVID_MASK },
> > +	{ MCP_MANID, MCP98242_DEVID, MCP98242_DEVID_MASK },
> > +	{ MCP_MANID, MCP98243_DEVID, MCP98243_DEVID_MASK },
> > +	{ MCP_MANID, MCP9843_DEVID, MCP9843_DEVID_MASK },
> > +	{ NXP_MANID, SE97_DEVID, SE97_DEVID_MASK },
> > +	{ ONS_MANID, CAT6095_DEVID, CAT6095_DEVID_MASK },
> > +	{ NXP_MANID, SE98_DEVID, SE98_DEVID_MASK },
> > +	{ STM_MANID, STTS424_DEVID, STTS424_DEVID_MASK },
> > +	{ STM_MANID, STTS424E_DEVID, STTS424E_DEVID_MASK },
> > +};
> []
> > +	for (i = 0; i < ARRAY_SIZE(jc42_chips); i++) {
> > +		if (manid == jc42_chips[i].manid
> > +		    && (devid & jc42_chips[i].devid_mask) ==
> > +					    jc42_chips[i].devid) {
> > +			strlcpy(info->type, "jc42", I2C_NAME_SIZE);
> > +			return 0;
> > +		}
> > +	}
> 
> Decidedly trivial:
> 
> Kernel style seems to prefer having logical tests at
> end of line rather than start of line.
> 
Ok. Would be nice to have checkpatch.pl complain about it, though,
if it is a to-be-enforced rule.

> Maybe this bit would be more readable with a temporary:
> 
> 	for (i = 0; i < ARRAY_SIZE(jc42_chips); i++) {
> 		struct jc42_chips *chip = &jc42_chips[i];
> 		if (manid == chip->manid &&
> 		    (devid & chip->devid_mask) == chip->devid) {
> 			strlcpy(info->type, "jc42", I2C_NAME_SIZE);
> 			return 0;
> 		}
> 	}
> 
Agreed. I'll change that.

Thanks,
Guenter

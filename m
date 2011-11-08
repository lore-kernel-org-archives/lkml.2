Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751985Ab1KHI7s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 03:59:48 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:48610 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751277Ab1KHI7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 03:59:46 -0500
Date: Tue, 8 Nov 2011 09:59:25 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Guenter Roeck <guenter.roeck@ericsson.com>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] hwmon: lm63: Add support for the NatSemi LM96163.
Message-ID: <20111108095925.0d99aea5@endymion.delvare>
In-Reply-To: <20111108073052.GC27841@avionic-0098.mockup.avionic-design.de>
References: <1320661258-1775-1-git-send-email-thierry.reding@avionic-design.de>
	<1320684566.2309.115.camel@groeck-laptop>
	<20111108073052.GC27841@avionic-0098.mockup.avionic-design.de>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thierry,

On Tue, 8 Nov 2011 08:30:52 +0100, Thierry Reding wrote:
> * Guenter Roeck wrote:
> > Hi,
> > 
> > On Mon, 2011-11-07 at 05:20 -0500, Thierry Reding wrote:
> > > Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
> > > ---
> > >  drivers/hwmon/lm63.c |    2 +-
> > >  1 files changed, 1 insertions(+), 1 deletions(-)
> > > 
> > > diff --git a/drivers/hwmon/lm63.c b/drivers/hwmon/lm63.c
> > > index 508cb29..94e373c 100644
> > > --- a/drivers/hwmon/lm63.c
> > > +++ b/drivers/hwmon/lm63.c
> > > @@ -483,7 +483,7 @@ static int lm63_detect(struct i2c_client *new_client,
> > >  		return -ENODEV;
> > >  	}
> > >  
> > > -	if (chip_id == 0x41 && address == 0x4c)
> > > +	if ((chip_id == 0x41 || chip_id == 0x49) && address == 0x4c)
> > >  		strlcpy(info->type, "lm63", I2C_NAME_SIZE);
> > >  	else if (chip_id == 0x51 && (address == 0x18 || address == 0x4e))
> > >  		strlcpy(info->type, "lm64", I2C_NAME_SIZE);
> > 
> > Minor - the new chip should be mentioned in drivers/hwmon/Kconfig and in
> > Documentation/hwmon/lm63.
> 
> I don't see how to list this variant meaningfully in the documentation.
> Since, as you mention, no functionality specific to the LM96163 is added,
> this patch really only adds support for one more lm63 chip.

The new chip name should at least be listed in
Documentation/hwmon/lm63, drivers/hwmon/Kconfig.

> > My main concern is that LM96163 supports a high resolution PWM mode.
> > Since that mode is much more convenient than the LM63-compatible mode, I
> > think it is likely to be enabled in designs using LM96163, and it should
> > be supported by the driver if we add support for LM96163.
> 
> Unfortunately our design doesn't use the PWM at all. It is only used for
> temperature measurements, so I'm not able to test any of the PWM code.

You still need to ensure that nothing bad will happen if users load the
lm63 driver with a LM96163 chip (if nothing else, by disabling the
unimplemented/untested feature.)

-- 
Jean Delvare

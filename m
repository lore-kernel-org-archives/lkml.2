Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751736Ab2HMNoP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 09:44:15 -0400
Received: from mail.active-venture.com ([67.228.131.205]:57829 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750963Ab2HMNoN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 09:44:13 -0400
X-Originating-IP: 108.223.40.66
Date: Mon, 13 Aug 2012 06:44:09 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Bitan Biswas <bbiswas@nvidia.com>
Cc: "khali@linux-fr.org" <khali@linux-fr.org>,
        "guenter.roeck@ericsson.com" <guenter.roeck@ericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: [lm-sensors] hwmon : raw reading -> temperature conversion
Message-ID: <20120813134409.GA31991@roeck-us.net>
References: <50251826.9020303@nvidia.com>
 <20120810184326.GA4625@roeck-us.net>
 <5028AC47.8080108@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5028AC47.8080108@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 13, 2012 at 12:57:03PM +0530, Bitan Biswas wrote:
> Hi Guenter,
> 
>  Thank you for the guidance.
> 
> >>
> >>But looking at the hwmon linux documentation, seems the sensor
> >>kernel drivers should report only raw readings.
> >>The raw readings can be converted into required output,
> >>e.g. temperature in this case, by respective user space implementation.
> >>
> >"raw" means the value as reported to the sensor. For example, for an ADC, the
> >raw value means the voltage in mV as seen on the sensor's input pins. This
> >voltage is the voltage to be reported. Converting it to a "real" voltage as,
> >typically, determined by a set of voltage divider resistors should be done in
> >user space.
> >
> >For temperature sensors this is a bit more tricky. Presumably you get readings
> >from a thermistor or similar. The hwmon subsystem includes a driver for NTC
> >thermistors; maybe you can get some ideas from it. Maybe you can even use
> >it and/or extend it to support your hardware.
> 
> The sensor is Tegra3 integrated thermal sensor. It is not a
> thermistor, but gives a counter reading. The expressions to convert
> the counter to temperature use characterization data and certain
> initialization parameters. I looked at the NTC thermistor driver.
> The expressions I need to use to convert counter value to
> temperature would need floating point arguments.
> 
> >
> >>However because of my driver clients being in kernel space, I am
> >>thinking of doing fixed point calculations in the sensor driver
> >>and get the temperature corresponding to raw sensor readings.
> >>
> >>Please let me know if this a correct approach?
> >>
> >Question is really what chip you are using, and how exactly your hardware looks
> >like. Do you use a generic ADC ? If so, is it already supported in the kernel ?
> >How are the thermistor readings converted and reported to SW ?
> 
> I think this is somewhat like an ADC but I need to implement the
> expressions to convert the counter readings to temperature. Using
> fixed point approximations instead of the floating point operands,
> the expressions can be implemented in kernel. The expressions to be
> used for calculation are specific to chip and I could not find a
> existing driver that could support this sensor.
> 
>  There are expressions that can convert the counter readings to
> temperature and vice-versa.
> 1) SW could call the driver callbacks and get the temperature.
> 2) SW could also request temperature thresholds to be configured for
> thermal monitoring.
> 
> The software that may need to use the temperature are some other
> kernel drivers.
> 
> Is it not allowed to implement the counter raw readings to
> temperature in the hwmon sensor driver?
> 
If you look at the NTC driver, that is pretty much exactly what it does. It
accepts Ohm or Volt as input, and calculates a temperature from it. One can
think of a counter reading as to be similar to a resistance reading; if you
do that, you have a good starting point for your driver. You can use either
fixed point approximations, or a table approach as in the NTC driver.

Thanks,
Guenter

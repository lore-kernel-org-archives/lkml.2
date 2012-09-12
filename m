Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753277Ab2ILI53 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 04:57:29 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:43980 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753098Ab2ILI5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 04:57:25 -0400
Message-ID: <50504E6B.9060401@gmail.com>
Date: Wed, 12 Sep 2012 10:57:15 +0200
From: Daniel Mack <zonque@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: devicetree-discuss@lists.ozlabs.org, lrg@ti.com,
        broonie@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] regulator: gpio-regulator: add DT bindings
References: <1347289429-18713-1-git-send-email-zonque@gmail.com> <504E4234.9090300@wwwdotorg.org>
In-Reply-To: <504E4234.9090300@wwwdotorg.org>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On 10.09.2012 21:40, Stephen Warren wrote:
> On 09/10/2012 09:03 AM, Daniel Mack wrote:
>> Add DT bindings for the gpio-regulator driver and some documentation on
>> how to use it.
> 
>> +++ b/Documentation/devicetree/bindings/regulator/gpio-regulator.txt
>> @@ -0,0 +1,58 @@
>> +Device tree bindings for GPIO controlled voltages
>> +
>> +Voltage or current regulators on boards that are controlled by GPIOs can
>> +be used by the gpio-regulator driver.
>> +
>> +Required properties:
>> +
>> + - "compatible":	must be set to "gpio-regulator"
>> + - "regulator-name": 	must be set to a string describing the name of this
>> +			regulator.
> 
> I'd expect the "gpios" property to be listed here.

Yes, I'll add that.

> 
>> +Optional properties:
>> +
>> + - "startup-delay":		Start-up time in microseconds
>> + - "enable-high":		Polarity of enable GPIO. Active high if
>> +				defined, otherwise active low
> 
> fixed-regulator.txt already has an "enable-active-high" property; it'd
> be nice to be consistent.

Ok.

>> + - "enabled-at-boot":		If set, the regulator has been enabled at boot
>> +				time
> 
> Isn't that regulator-boot-on, as defined in regulator.txt that you
> mentioned?
> 
>> + - "regulator-type-voltage":	The regulator controls a voltage
>> + - "regulator-type-current":	The regulator controls a current
> 
> I wonder if it'd be better to differentiate this using different
> compatible values instead?

I like this idea. Will make that "gpio-voltage-regulator" and
"gpio-current-regulator".

> 
>> + - "states":			An array of possible states, describing the
>> +				GPIO states to reach a given value
>> +	- "value":		The value of the state, in microvolts or
>> +				microamperes
> 
> A name like "microvolts", "voltage", "microamps", or "current" might be
> more descriptive here.

I'm for "microvolts" and "microamperes". Will change. I just thought it
might be good to keep as close to the struct member names for making it
easiest for users to convert over to DT, but you're right, a more
descriptive property name is certainly better.

>> +	- "gpios":		bitfield of gpio target-states for the value
>> +				The n-th bit in the bitfield describes the
>> +				state of the n-th GPIO from the gpios-array
> 
> "gpios" sounds like the name of a property that defines which GPIOs are
> used, rather than the value of those GPIOs. Perhaps "gpio-values" instead?
> 
> Actually, I wonder if we really even need to represent that values
> explicitly; rather than have a big set of nodes, perhaps you can instead
> have a single property that lists the voltage (or current) that each
> combination of GPIO values gives; something like:
> 
> reg_gpio {
>     ...
>     gpios = <&ggpio 23 0 &gpio 24 0>;
>     voltages = <0 1000000 2000000 3000000>;
> };
> 
> (As inspiration for that, I looked at
> Documentation/devicetree/bindings/net/mdio-mux-gpio.txt which doesn't
> have a property defining the value of the GPIOs for each combination,
> but rather a node per valid combination).
> 
> Perhaps represent and invalid GPIO combination with 0xffffffff?

Sorry, I don't follow you on this one. How would you specify the
voltages that way? And The driver allows for arbitrary GPIO patterns to
be set on the GPIOs in order to reach a specific voltage. Could you give
me another example how that would look like in your approach?

Once that topic is agreed on, I'll send out a new version.

>> +Also, all properties described in
>> +Documentation/devicetree/bindings/regulator/regulator.txt are supported as
>> +well.
>> +
>> +Example:
>> +
>> +	reg_gpio {
>> +		compatible = "gpio-regulator";
>> +		regulator-name = "voltage";
>> +		regulator-enable-high;
>> +		regulator-type-voltage;
>> +		regulator-min-microvolt = <3300000>;
>> +		regulator-max-microvolt = <3300000>;
>> +		regulator-always-on;
>> +
>> +		gpios = <&gpio 23 0>;
>> +
>> +		states {
>> +			state-on {
>> +				value = <3300000>;
>> +				gpios = <0x1>;
>> +			};
>> +
>> +			state-off {
>> +				value = <0>;
>> +				gpios = <0x0>;
>> +			};
>> +		};
>> +	};
> 
> That particular example only has on/off states, and so might be better
> covered using the existing fixed-regulator, with optional GPIO control.
> Perhaps an example using 2 GPIOs for 4 voltage states would be more useful?

Yes, that's true. Funny thing is - I forgot about the fixed-regulator's
feature to control GPIOs and use the driver as in the example that I
provided :) Anyway, I'll finish the conversion of this one now, as I'm
on it.


Many thanks for your review,

Daniel




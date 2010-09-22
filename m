Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754235Ab0IVSPQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 14:15:16 -0400
Received: from qmta07.emeryville.ca.mail.comcast.net ([76.96.30.64]:44272 "EHLO
	qmta07.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753701Ab0IVSPO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 14:15:14 -0400
Date: Wed, 22 Sep 2010 11:14:27 -0700
From: matt mooney <mfm@muteddisk.com>
To: Samu Onkalo <samu.p.onkalo@nokia.com>
Cc: rpurdie@linux.intel.com, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] Documentation: led drivers lp5521 and lp5523
Message-ID: <20100922181427.GA18432@haskell.muteddisk.com>
Mail-Followup-To: Samu Onkalo <samu.p.onkalo@nokia.com>,
	rpurdie@linux.intel.com, linux-i2c@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <1284631946-5350-1-git-send-email-samu.p.onkalo@nokia.com>
 <1284631946-5350-5-git-send-email-samu.p.onkalo@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1284631946-5350-5-git-send-email-samu.p.onkalo@nokia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13:12 Thu 16 Sep     , Samu Onkalo wrote:
> +
> +LP5521 can drive up to 3 channels. Leds can be controlled directly via
 [the] led class control interface. Channels have generic names:

* The "a" after "have" was removed too.

> +lp5521:channelx, where x is 0 .. 2
> +
> +All three channels can be also controlled using engine micro programs.
> +More details of the instructions can be found from public data sheet.

Also, all three channels can be controlled using [the] micro-engine programs.
More details of the instructions can be found from [the] public datasheet.

> +Control interface for engines:

Control interface for [the] engines:

> +
> +sysfs contains also selftest entry.

sysfs contains a selftest entry.
                

> +It communicates with the chip and checks that
> +clock mode is automatically set to requested one.

The test communicates with the chip and checks that
[the] clock mode is automatically set to [the] requested one.


> +
> +Each channel contains led current settings.

Each channel has its own led current settings.


> +/sys/class/leds/lp5521:channel0/led_current - RW
> +/sys/class/leds/lp5521:channel0/max_current - RO
> +Format: 10x mA i.e 10 means 1.0 mA
> +
> +example platform data:
> +static struct lp5521_led_config lp5521_led_config[] = {
> +        {
> +                .chan_nr        = 0,
> +                .led_current    = 50,
> +		.max_current    = 130,
> +        }, {
> +                .chan_nr        = 1,
> +                .led_current    = 0,
> +		.max_current    = 130,
> +        }, {
> +                .chan_nr        = 2,
> +                .led_current    = 0,
> +		.max_current    = 130,
> +        }
> +};
> +
> +static int lp5521_setup(void)
> +{
> +	/* setup HW resources */
> +}
> +
> +static void lp5521_release(void)
> +{
> +	/* Release HW resources */
> +}
> +
> +static void lp5521_enable(bool state)
> +{
> +	/* Control of chip enable signal */
> +}
> +
> +static struct lp5521_platform_data lp5521_platform_data = {
> +        .led_config     = lp5521_led_config,
> +        .num_channels   = ARRAY_SIZE(lp5521_led_config),
> +        .clock_mode     = LP5521_CLOCK_EXT,
> +        .setup_resources   = lp5521_setup,
> +        .release_resources = lp5521_release,
> +        .enable            = lp5521_enable,
> +};
> +
> +If the current is set to 0 in the platform data, that channel is
> +disabled and it is not visible in the sysfs.
> diff --git a/Documentation/leds/leds-lp5523.txt b/Documentation/leds/leds-lp5523.txt
> new file mode 100644
> index 0000000..915298d
> --- /dev/null
> +++ b/Documentation/leds/leds-lp5523.txt
> @@ -0,0 +1,81 @@
> +-----------
> +LP5523 can drive up to 9 channels. Leds can be controlled directly via
> +led class control interface. Channels have a generic names:
> +lp5523:channelx where x is 0...8

Same as above

> +Chip provides 3 engines which can be control channels without main CPU

* The antecedent that "which" refers to above is the "chip."

[The] chip provides 3 engines. Each engine can control a channel without
interaction from the main CPU.

> +interaction. Details of the micro engine code can be found from the
> +public data sheet. Leds can be muxed to different channels.
> +
> +Control interface for engines:
> +x is 1 .. 3
> +enginex_mode : disabled, load, run
> +enginex_load : microcode load (visible only in load mode)
> +enginex_leds : led mux control (visible only in load mode)
> +
> +cd /sys/class/leds/lp5523:channel2/device
> +echo "load" > engine3_mode
> +echo "9d80400004ff05ff437f0000" > engine3_load
> +echo "111111111" > engine3_leds
> +echo "run" > engine3_mode
> +
> +sysfs contains also selftest entry. It measures each channel
> +voltage level and checks if it looks reasonable. Too high
> +level means missing led and to low value means short circuit.

If the level is too high, the led is missing; if the level is
too low, there is a short circuit.

> +Selftest uses always current from platform data.

Selftest always uses [the] current from [the] platform data.

-mfm

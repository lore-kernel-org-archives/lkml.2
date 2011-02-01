Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753086Ab1BAQ11 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 11:27:27 -0500
Received: from mail127.messagelabs.com ([216.82.250.115]:18345 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752020Ab1BAQ10 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 11:27:26 -0500
X-VirusChecked: Checked
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-3.tower-127.messagelabs.com!1296577645!9085316!2
X-StarScan-Version: 6.2.9; banners=-,-,-
X-Originating-IP: [216.166.12.31]
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Wolfram Sang <w.sang@pengutronix.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 1 Feb 2011 10:27:23 -0600
Subject: RE: [leds-pca9532] Add gpio capability
Thread-Topic: [leds-pca9532] Add gpio capability
Thread-Index: AcvB5krfbSW/sZjwSWeAgHXNlt+hawARbEsg
Message-ID: <0D753D10438DA54287A00B027084269764CEEDAC85@AUSP01VMBX24.collaborationhost.net>
References: <0D753D10438DA54287A00B027084269764CEEDA479@AUSP01VMBX24.collaborationhost.net>
 <20110201080146.GA27955@pengutronix.de>
In-Reply-To: <20110201080146.GA27955@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, February 01, 2011 1:02 AM, Wolfram Sang wrote:
>> From the datasheet:
>>[...]
>> So, you should provide both a direction_input and direction_output.
>
> He did in V2 of this patch (what made me also download the datasheet ;)).

Ok.  Just looked at the v2 patch.

> +static int pca9532_gpio_direction_input(struct gpio_chip *gc, unsigned offset)
> +{
> + struct pca9532_data *data = container_of(gc, struct pca9532_data, gpio);
> + struct pca9532_led *led = &data->leds[offset];
> +
> + /* To use as input ensure pin is not driven */
> + led->state = PCA9532_OFF;
> + pca9532_setled(led);
> +
> + return 0;
> +}
> +

This looks good.  When configured as an input the pin needs to be set high-impedance,
00 which is PCA9532_OFF).

> +static int pca9532_gpio_direction_output(struct gpio_chip *gc,
> unsigned offset, int val)
> +{
> + return 0;
> +}
> +

Not good.  When the pin is configured as an output, the direction_output method also
requests that the pin be set to a desired level.  For this driver that means that the
pca9532_gpio_direction_output function just needs to call pca9532_gpio_set_value.

Regards,
Hartley

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754124Ab2DZGd1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 02:33:27 -0400
Received: from na3sys009aob106.obsmtp.com ([74.125.149.76]:39159 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753397Ab2DZGdZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 02:33:25 -0400
MIME-Version: 1.0
In-Reply-To: <4F981CD1.2050007@wwwdotorg.org>
References: <1335346004-18108-1-git-send-email-sourav.poddar@ti.com>
	<4F981CD1.2050007@wwwdotorg.org>
Date: Thu, 26 Apr 2012 12:03:23 +0530
Message-ID: <CAKdam56ONhS_drgfHCeY6aKWp3nT0PtDEO5SMCKxG+dGVPS66A@mail.gmail.com>
Subject: Re: [PATCHv4 1/2] drivers: input: keypad: Add device tree support
From: "Poddar, Sourav" <sourav.poddar@ti.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: devicetree-discuss@lists.ozlabs.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        Benoit Cousson <b-cousson@ti.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>, Felipe Balbi <balbi@ti.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Randy Dunlap <rdunlap@xenotime.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Wed, Apr 25, 2012 at 9:18 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 04/25/2012 03:26 AM, Sourav Poddar wrote:
>> Update the Documentation with omap4 keypad device tree
>> binding information.
>> Add device tree support for omap4 keypad driver.
>
>> diff --git a/Documentation/devicetree/bindings/input/omap-keypad.txt b/Documentation/devicetree/bindings/input/omap-keypad.txt
>
>> +Required Board Specific Properties, in addition to those specified by
>> +the shared matrix-keyboard bindings:
>> +- keypad,num-rows: Number of row lines connected to the keypad
>> +  controller.
>> +
>> +- keypad,num-columns: Number of column lines connected to the
>> +  keypad controller.
>
> I'm not sure if "keypad," is the appropriate prefix here. If the
> properties are specific to this one TI/OMAP binding, "ti," might be a
> better prefix. However, if they're more generally applicable, maybe
> "linux," to match "linux,keymap"?
>
Yes, the idea was to make this binding more generic. Hence no "ti/omap"
prefix were used.
'linux' prefix denotes bindings specific to linux, keymap has
keycodes which is linux specific. Hence, linux,keymap looks
appropriate. But num rows/ cols are keyboard specific, so I am not
sure if linux prefix goes well here ??
>> +Optional Properties specific to linux:
>> +- linux,keypad-no-autorepeat: do no enable autorepeat feature.
>
> It's probably worth considering whether num-rows/columns should be part
> of matrix-keyboard.txt, and whether linux,keypad-no-autorepeat should be
> part of some core keyboard binding. Some of the properties in
> tegra-kbc.txt might be worth generalizing too (debounce/repeat delay,
> ghost filter)?
>
Yes, I also think that its a good idea to make some of the above
binding more generic. Though, I think "linux,keypad-no-autorepeat"
will still be a custom binding, since its totally on the platform
whether to use
autorepeat feature or not?
>> +Example:
>> +        keypad@4ae1c000{

>> +                compatible = "ti,omap4-keypad";
>> +                keypad,num-rows = <2>;
>> +                keypad,num-columns = <8>;
>> +             linux,keypad-no-autorepeat;
>> +     };

~Sourav

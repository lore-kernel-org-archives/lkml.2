Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752715Ab2IYEbH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 00:31:07 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:36135 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750854Ab2IYEbB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 00:31:01 -0400
From: "Philip, Avinash" <avinashphilip@ti.com>
To: Stephen Warren <swarren@wwwdotorg.org>
CC: "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "rob@landley.net" <rob@landley.net>,
        "rpurdie@rpsys.net" <rpurdie@rpsys.net>,
        "thierry.reding@avionic-design.de" <thierry.reding@avionic-design.de>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Nori, Sekhar" <nsekhar@ti.com>,
        "Hebbar, Gururaja" <gururaja.hebbar@ti.com>
Subject: RE: [PATCH v2] pwm_backlight: Add device tree support for Low
 Threshold Brightness
Thread-Topic: [PATCH v2] pwm_backlight: Add device tree support for Low
 Threshold Brightness
Thread-Index: AQHNl7dcczUdlqqMiEavEaWXq+POTpeT5POAgABctfCAAHP6gIAEaxEQ
Date: Tue, 25 Sep 2012 04:29:27 +0000
Deferred-Delivery: Tue, 25 Sep 2012 04:29:00 +0000
Message-ID: <518397C60809E147AF5323E0420B992E3E9A8449@DBDE01.ent.ti.com>
References: <1348203080-16348-1-git-send-email-avinashphilip@ti.com>
 <505BF83D.8040201@wwwdotorg.org>
 <518397C60809E147AF5323E0420B992E3E9A685B@DBDE01.ent.ti.com>
 <505CA74B.2090405@wwwdotorg.org>
In-Reply-To: <505CA74B.2090405@wwwdotorg.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.162.25]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 21, 2012 at 23:13:39, Stephen Warren wrote:
> On 09/21/2012 12:03 AM, Philip, Avinash wrote:
> > Hi Stephen,
> > 
> > On Fri, Sep 21, 2012 at 10:46:45, Stephen Warren wrote:
> >> On 09/20/2012 10:51 PM, Philip, Avinash wrote:
> >>> Some backlights perform poorly when driven by a PWM with a short
> >>> duty-cycle. For such devices, the low threshold can be used to specify a
> >>> lower bound for the duty-cycle and should be chosen to exclude the
> >>> problematic range.
> >>>
> >>> This patch adds support for an optional low-threshold-brightness
> >>> property.
> >>
> >>> diff --git a/Documentation/devicetree/bindings/video/backlight/pwm-backlight.txt b/Documentation/devicetree/bindings/video/backlight/pwm-backlight.txt
> >>
> >>>  Optional properties:
> >>>    - pwm-names: a list of names for the PWM devices specified in the
> >>>                 "pwms" property (see PWM binding[0])
> >>> +  - low-threshold-brightness: brightness threshold low level. Low threshold
> >>> +    brightness set to value so that backlight present on low end of
> >>> +    brightness.
> >>
> >> For my education, why not just specify values above this value in the
> >> brightness-levels array; how do those two interact?
> > 
> > Please find details from 
> > https://lkml.org/lkml/2012/7/18/284
> 
> Hmm. That still doesn't really explain what this property does.
> 
> I'm going to guess that if this property is present, and values in the
> brightness-levels property get scaled between the
> low-threshold-brightness and 255 instead of being used directly.

This is correct.

> But then, in the email you linked to, what does "But brightness-levels won't
> be uniformly divided" mean?

For some panels, backlight would absent on low end of brightness due to low
percentage in duty_cycle. Consider following example where backlight absent
for brightness levels from 0 - 51.

pwms = <&pwm 0 50000>;
brightness-levels = <0 51 53 56 62 75 101 152 255>; 
default-brightness-level = <6>;

So in the example, brightness-levels are set to have values for backlight present.
Here levels are not uniformly divided.

But by providing,
brightness_threshold_level = <50>;

we can have a uniform division in brightness-levels as below

brightness-levels = <0 2 4 8 16 32 64 128 255>;


> Why would doing the calculation at run-time
> be any better than simply putting the correct values into
> brightness-levels in the first place?

I think you mean to provide the backlight-levels as in example
brightness-levels = <0 51 53 56 62 75 101 152 255>;

In that case, I still feel adding brightness_threshold_level would be a
better option.

> 
> Either way, the DT binding should explain exactly what this value is
> used for, and how it affects the interpretation of values in
> brightness-levels.

Is DT binding documentation a good place to explain this feature?
Initially Thierry suggested document option. So I left out.

Thanks
Avinash

> 


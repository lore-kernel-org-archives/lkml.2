Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755147Ab2I0J0Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 05:26:24 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:33916 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753216Ab2I0J0V convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 05:26:21 -0400
From: "Philip, Avinash" <avinashphilip@ti.com>
To: Thierry Reding <thierry.reding@avionic-design.de>,
        Stephen Warren <swarren@wwwdotorg.org>
CC: "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "rob@landley.net" <rob@landley.net>,
        "rpurdie@rpsys.net" <rpurdie@rpsys.net>,
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
Thread-Index: AQHNl7dcczUdlqqMiEavEaWXq+POTpeT5POAgABctfCAAHP6gIAEaxEQgAEfCQCAAL+RgIABbAyAgAAW5oCAATZisA==
Date: Thu, 27 Sep 2012 09:24:47 +0000
Deferred-Delivery: Thu, 27 Sep 2012 09:24:00 +0000
Message-ID: <518397C60809E147AF5323E0420B992E3E9A9B2A@DBDE01.ent.ti.com>
References: <1348203080-16348-1-git-send-email-avinashphilip@ti.com>
 <505BF83D.8040201@wwwdotorg.org>
 <518397C60809E147AF5323E0420B992E3E9A685B@DBDE01.ent.ti.com>
 <505CA74B.2090405@wwwdotorg.org>
 <518397C60809E147AF5323E0420B992E3E9A8449@DBDE01.ent.ti.com>
 <50614CE2.7010301@wwwdotorg.org>
 <518397C60809E147AF5323E0420B992E3E9A8FA7@DBDE01.ent.ti.com>
 <50631EF7.6040908@wwwdotorg.org>
 <20120926164949.GA24041@avionic-0098.mockup.avionic-design.de>
In-Reply-To: <20120926164949.GA24041@avionic-0098.mockup.avionic-design.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 26, 2012 at 22:19:49, Thierry Reding wrote:
> On Wed, Sep 26, 2012 at 09:27:51AM -0600, Stephen Warren wrote:
> > On 09/25/2012 10:35 PM, Philip, Avinash wrote:
> > > On Tue, Sep 25, 2012 at 11:49:14, Stephen Warren wrote:
> > >> On 09/24/2012 10:29 PM, Philip, Avinash wrote:
> > >>> On Fri, Sep 21, 2012 at 23:13:39, Stephen Warren wrote:
> > >>>> On 09/21/2012 12:03 AM, Philip, Avinash wrote:
> > >>>>> Hi Stephen,
> > >>>>>
> > >>>>> On Fri, Sep 21, 2012 at 10:46:45, Stephen Warren wrote:
> > >>>>>> On 09/20/2012 10:51 PM, Philip, Avinash wrote:
> > >>>>>>> Some backlights perform poorly when driven by a PWM with a short
> > >>>>>>> duty-cycle. For such devices, the low threshold can be used to specify a
> > >>>>>>> lower bound for the duty-cycle and should be chosen to exclude the
> > >>>>>>> problematic range.
> > >>>>>>>
> > >>>>>>> This patch adds support for an optional low-threshold-brightness
> > >>>>>>> property.
> > >>>>>>
> > >>>>>>> diff --git a/Documentation/devicetree/bindings/video/backlight/pwm-backlight.txt b/Documentation/devicetree/bindings/video/backlight/pwm-backlight.txt
> > >>>>>>
> > >>>>>>>  Optional properties:
> > >>>>>>>    - pwm-names: a list of names for the PWM devices specified in the
> > >>>>>>>                 "pwms" property (see PWM binding[0])
> > >>>>>>> +  - low-threshold-brightness: brightness threshold low level. Low threshold
> > >>>>>>> +    brightness set to value so that backlight present on low end of
> > >>>>>>> +    brightness.
> > >>>>>>
> > >>>>>> For my education, why not just specify values above this value in the
> > >>>>>> brightness-levels array; how do those two interact?
> > >>>>>
> > >>>>> Please find details from 
> > >>>>> https://lkml.org/lkml/2012/7/18/284
> > >>>>
> > >>>> Hmm. That still doesn't really explain what this property does.
> > >>>>
> > >>>> I'm going to guess that if this property is present, and values in the
> > >>>> brightness-levels property get scaled between the
> > >>>> low-threshold-brightness and 255 instead of being used directly.
> > >>>
> > >>> This is correct.
> > >>>
> > >>>> But then, in the email you linked to, what does "But brightness-levels won't
> > >>>> be uniformly divided" mean?
> > >>>
> > >>> For some panels, backlight would absent on low end of brightness due to low
> > >>> percentage in duty_cycle. Consider following example where backlight absent
> > >>> for brightness levels from 0 - 51.
> > >>>
> > >>> pwms = <&pwm 0 50000>;
> > >>> brightness-levels = <0 51 53 56 62 75 101 152 255>; 
> > >>> default-brightness-level = <6>;
> > >>>
> > >>> So in the example, brightness-levels are set to have values for backlight present.
> > >>> Here levels are not uniformly divided.
> > >>
> > >> So why not just change the values so they /are/ what you want? After
> > >> all, it's just data and you can put whatever values you want there. What
> > >> is preventing you from doing this?
> > > 
> > > brightness_threshold_level was added to explore lth_brightness support already
> > > present in non-DT case.
> > 
> > I understand that. Given my discussion above, I would advocate removing
> > lth_brightness from the non-DT case rather than adding it to the DT
> > case, since it seems entirely pointless.
> 
> It is still required for the case where brightness levels are not used.
> So we can't drop it right away. I agree however that we should plan to
> get rid of the max_brightness and lth_brightness eventually. Since the
> DT bindings don't use it yet we should keep only the brightness levels.
> Once all users have been converted we can rename max_brightness to
> something like num_levels and remove lth_brightness. dft_brightness can
> probably be renamed to default_level.

In non-DT case lth_brightness is required. 
But for DT we have options with/without lth_brightness support. 
In case if patch is dropped, user has to put proper brightness-levels 
(brightness-levels DT parameters should be specified considering the 
low-threshold values)

Meanwhile I had submitted another version yesterday (with more documentation)

[PATCH v3] pwm_backlight: Add device tree support for Low Threshold Brightness

https://lkml.org/lkml/2012/9/26/271

Thierry,

Can you please confirm the acceptance/rejection of the patch? This will help me
to submit the backlight DT blob for AM335x platform.

Thanks
Avinash

> 
> Thierry
> 


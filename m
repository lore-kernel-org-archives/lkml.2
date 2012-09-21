Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932360Ab2IURnp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 13:43:45 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:48566 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932122Ab2IURnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 13:43:43 -0400
Message-ID: <505CA74B.2090405@wwwdotorg.org>
Date: Fri, 21 Sep 2012 11:43:39 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: "Philip, Avinash" <avinashphilip@ti.com>
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
Subject: Re: [PATCH v2] pwm_backlight: Add device tree support for Low Threshold
 Brightness
References: <1348203080-16348-1-git-send-email-avinashphilip@ti.com> <505BF83D.8040201@wwwdotorg.org> <518397C60809E147AF5323E0420B992E3E9A685B@DBDE01.ent.ti.com>
In-Reply-To: <518397C60809E147AF5323E0420B992E3E9A685B@DBDE01.ent.ti.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/21/2012 12:03 AM, Philip, Avinash wrote:
> Hi Stephen,
> 
> On Fri, Sep 21, 2012 at 10:46:45, Stephen Warren wrote:
>> On 09/20/2012 10:51 PM, Philip, Avinash wrote:
>>> Some backlights perform poorly when driven by a PWM with a short
>>> duty-cycle. For such devices, the low threshold can be used to specify a
>>> lower bound for the duty-cycle and should be chosen to exclude the
>>> problematic range.
>>>
>>> This patch adds support for an optional low-threshold-brightness
>>> property.
>>
>>> diff --git a/Documentation/devicetree/bindings/video/backlight/pwm-backlight.txt b/Documentation/devicetree/bindings/video/backlight/pwm-backlight.txt
>>
>>>  Optional properties:
>>>    - pwm-names: a list of names for the PWM devices specified in the
>>>                 "pwms" property (see PWM binding[0])
>>> +  - low-threshold-brightness: brightness threshold low level. Low threshold
>>> +    brightness set to value so that backlight present on low end of
>>> +    brightness.
>>
>> For my education, why not just specify values above this value in the
>> brightness-levels array; how do those two interact?
> 
> Please find details from 
> https://lkml.org/lkml/2012/7/18/284

Hmm. That still doesn't really explain what this property does.

I'm going to guess that if this property is present, and values in the
brightness-levels property get scaled between the
low-threshold-brightness and 255 instead of being used directly. But
then, in the email you linked to, what does "But brightness-levels won't
be uniformly divided" mean? Why would doing the calculation at run-time
be any better than simply putting the correct values into
brightness-levels in the first place?

Either way, the DT binding should explain exactly what this value is
used for, and how it affects the interpretation of values in
brightness-levels.

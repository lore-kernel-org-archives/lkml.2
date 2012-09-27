Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755833Ab2I0VdN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 17:33:13 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36000 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755540Ab2I0VdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 17:33:10 -0400
Date: Thu, 27 Sep 2012 14:33:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Philip, Avinash" <avinashphilip@ti.com>
Cc: <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>, <rob@landley.net>,
        <rpurdie@rpsys.net>, <thierry.reding@avionic-design.de>,
        <broonie@opensource.wolfsonmicro.com>, <shawn.guo@linaro.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <nsekhar@ti.com>,
        <gururaja.hebbar@ti.com>
Subject: Re: [PATCH v3] pwm_backlight: Add device tree support for Low
 Threshold Brightness
Message-Id: <20120927143309.02614908.akpm@linux-foundation.org>
In-Reply-To: <1348670827-5720-1-git-send-email-avinashphilip@ti.com>
References: <1348670827-5720-1-git-send-email-avinashphilip@ti.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Sep 2012 20:17:07 +0530
"Philip, Avinash" <avinashphilip@ti.com> wrote:

> Some back lights perform poorly when driven by a PWM with a short
> duty-cycle. For such devices, the low threshold can be used to specify a
> lower bound for the duty-cycle and should be chosen to exclude the
> problematic range.
> 
> Add device tree probing support for lth_brightness putting
> low-threshold-brightness as optional property.
> 
> ...
>
> --- a/Documentation/devicetree/bindings/video/backlight/pwm-backlight.txt
> +++ b/Documentation/devicetree/bindings/video/backlight/pwm-backlight.txt
> @@ -14,6 +14,15 @@ Required properties:
>  Optional properties:
>    - pwm-names: a list of names for the PWM devices specified in the
>                 "pwms" property (see PWM binding[0])
> +  - low-threshold-brightness: brightness threshold low level. Low threshold
> +    brightness set to value so that backlight present on low end of
> +    brightness.
> +    Some panels, backlight would absent if duty percentage of PWM wave is less
> +    than certain level (say 20%). By setting low-threshold-brightness to a
> +    value above (percentage of brightness-levels max) 50 (20% of 255, if 255
> +    is max). On setting low-threshold-brightness, range of brightness-levels
> +    is calculated in a region of low-threshold-brightness to brightness-levels
> +    max.

hoo boy, that's hard to follow.  How does this look?

--- a/Documentation/devicetree/bindings/video/backlight/pwm-backlight.txt~pwm_backlight-add-device-tree-support-for-low-threshold-brightness-fix
+++ a/Documentation/devicetree/bindings/video/backlight/pwm-backlight.txt
@@ -14,15 +14,15 @@ Required properties:
 Optional properties:
   - pwm-names: a list of names for the PWM devices specified in the
                "pwms" property (see PWM binding[0])
-  - low-threshold-brightness: brightness threshold low level. Low threshold
-    brightness set to value so that backlight present on low end of
-    brightness.
-    Some panels, backlight would absent if duty percentage of PWM wave is less
-    than certain level (say 20%). By setting low-threshold-brightness to a
-    value above (percentage of brightness-levels max) 50 (20% of 255, if 255
-    is max). On setting low-threshold-brightness, range of brightness-levels
-    is calculated in a region of low-threshold-brightness to brightness-levels
-    max.
+  - low-threshold-brightness: brightness threshold low level. Sets the lowest
+    brightness value.
+    On some panels the backlight misbehaves if the duty cycle percentage of the
+    PWM wave is less than a certain level (say 20%).  In this example the user
+    can set low-threshold-brightness to a value above 50 (ie, 20% of 255), thus
+    preventing the PWM duty cycle from going too low.
+    On setting low-threshold-brightness the range of brightness levels is
+    calculated in the range low-threshold-brightness to the maximum value in
+    brightness-levels, described above.
 
 [0]: Documentation/devicetree/bindings/pwm/pwm.txt
 


Also, I'm wondering if we really needed a new property - couldn't one
do this simply by setting brightness-levels to 50..255?

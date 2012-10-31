Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161049Ab2JaJC2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 05:02:28 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:6241 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161028Ab2JaJCX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 05:02:23 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Wed, 31 Oct 2012 02:02:18 -0700
From: Alex Courbot <acourbot@nvidia.com>
To: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>
CC: <devicetree-discuss@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>
Subject: How about a gpio_get(device *, char *) function?
Date: Wed, 31 Oct 2012 18:04:09 +0900
Message-ID: <38620644.IyR5R8rjKP@percival>
Organization: NVIDIA
User-Agent: KMail/4.9.2 (Linux/3.6.3-1-ARCH; KDE/4.9.2; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Would anyone be opposed to having a gpio_get() function that works similarly 
to e.g. regulator_get() and clk_get()?

I can see some good reasons to have this:

- Less platform data to pass to drivers,
- Consistency between different subsystems. Regulator, clock, PWM, ... all use 
this scheme.
- The "device-specific indirection" could make some DT structures more 
reusable. Right now the only way to address a GPIO through the DT is via a 
phandle that includes the GPIO number - thus hard-coded.

The implementation would be rather simple, and the function would just return 
the right GPIO number (acquired through gpio_request).

Rationale for this: I would like to be able to share power sequences between 
devices, e.g. to completely extract the per-device resources from the 
sequence. Every power sequence step references either a regulator, PWM, or 
GPIO. For regulators and PWMs separation is easy because their subsystems 
provide regulator_get() and pwm_get() which allow the resource to be 
referenced by name in the sequence, and resolved to different instances 
depending on the device. GPIOs, on the other hand, can only be referenced by 
number - and that makes it necessary to duplicate the sequence's structure in 
memory for every device that may use it. It if was possible to reference GPIOs 
by names that resolve to different GPIO numbers according to the device, then 
the problem would be solved.

There are probably other use-cases that would benefit from this, if you know of 
one please feel free to share.

Thanks,
Alex.


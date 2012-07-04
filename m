Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756081Ab2GDGvg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 02:51:36 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:4250 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803Ab2GDGve (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 02:51:34 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Tue, 03 Jul 2012 23:51:28 -0700
Message-ID: <4FF3E862.8050101@nvidia.com>
Date: Wed, 4 Jul 2012 15:53:22 +0900
From: Alex Courbot <acourbot@nvidia.com>
Organization: NVIDIA
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120616 Thunderbird/13.0.1
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
Subject: Use of the pwm-names DT property
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thierry,

Looking at your PWM/DT integration patches for linux-next, I was 
wondering what is the rationale behind using the pwm-names property. If 
I got it correctly, its purpose is to be able to reference different 
PWMs by name, e.g. by having

	pwms = <&pwm 0 5000000>, <&pwm 1 5000000>;
	pwm-names = "backlight", "flash";

You could get the first PWM in the driver code by calling pwm_get(dev, 
"backlight") and the second through pwm_get(dev, "flash").

While I am ok with this way of doing, why not having the form that is 
already used by the regulator and gpio frameworks, in which the consumer 
is part of the property name?

	vdd-supply = <&vdd_reg>;
	core-supply = <&core_reg>;

Both regulators are then accessed using regulator_get(dev, "vdd") and 
regulator_get(dev, "core").

Wouldn't it make more sense to follow the same scheme that has been 
popularized by other frameworks? It also has the advantage that you do 
not need to maintain two different properties which must be the same size.

Thanks,
Alex.

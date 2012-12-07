Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030630Ab2LGOFQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 09:05:16 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:48255 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030437Ab2LGOFO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 09:05:14 -0500
Message-ID: <50C1F783.6090501@ti.com>
Date: Fri, 7 Dec 2012 15:04:51 +0100
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: Bryan Wu <cooloney@gmail.com>, Richard Purdie <rpurdie@rpsys.net>,
        <linux-leds@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH v2 3/3] leds: leds-pwm: Add device tree bindings
References: <1352731270-27534-1-git-send-email-peter.ujfalusi@ti.com> <1352731270-27534-4-git-send-email-peter.ujfalusi@ti.com> <20121206100052.EC8293E0E22@localhost> <50C0913B.9070802@ti.com> <20121207133453.800C43E0B87@localhost>
In-Reply-To: <20121207133453.800C43E0B87@localhost>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/07/2012 02:34 PM, Grant Likely wrote:
> It really needs to look like this:
> 
> pwmleds {
> 	compatible = "pwm-leds";
> 	kpad {
> 		label = "omap4::keypad";
> 		max-brightness = <127>;
> 		pwms = <&twl_pwm 0 7812500>;
> 	};
> 	charging {
> 		label = "omap4:green:chrg";
> 		max-brightness = <255>;
> 		pwms = <&twl_pwmled 0 7812500>;
> 	};
> };

OK.
So What we need to do is export the of_pwm_request() from drivers/pwm/core.c
Client drivers us of_pwm_request(node, NULL); to get the pwm when booted with DT.
Works fine on my setup this way and the DTS section looks just as you have
described.
Now I need to clean them up and resubmit.

-- 
Péter

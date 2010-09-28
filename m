Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755519Ab0I1NgW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 09:36:22 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:33553 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755435Ab0I1NgS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 09:36:18 -0400
Date: Tue, 28 Sep 2010 16:35:01 +0300
From: Felipe Balbi <balbi@ti.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: "V, Hemanth" <hemanthv@ti.com>, Arun Murthy <arun.murthy@stericsson.com>,
        "lars@metafoo.de" <lars@metafoo.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "philipp.zabel@gmail.com" <philipp.zabel@gmail.com>,
        "robert.jarzmik@free.fr" <robert.jarzmik@free.fr>,
        "marek.vasut@gmail.com" <marek.vasut@gmail.com>,
        "eric.y.miao@gmail.com" <eric.y.miao@gmail.com>,
        "rpurdie@rpsys.net" <rpurdie@rpsys.net>,
        "kgene.kim@samsung.com" <kgene.kim@samsung.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
        "STEricsson_nomadik_linux@list.st.com" 
	<STEricsson_nomadik_linux@list.st.com>
Subject: Re: [PATCH 1/7] pwm: Add pwm core driver
Message-ID: <20100928133501.GB8575@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1285670134-18063-1-git-send-email-arun.murthy@stericsson.com>
 <1285670134-18063-2-git-send-email-arun.murthy@stericsson.com>
 <040c01cb5f0c$29bcb3b0$LocalHost@wipblrx0099946>
 <20100928130610.GB20749@sortiz-mobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20100928130610.GB20749@sortiz-mobl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 28, 2010 at 08:06:11AM -0500, Samuel Ortiz wrote:
>On Tue, Sep 28, 2010 at 06:23:24PM +0530, Hemanth V wrote:
>> ----- Original Message ----- From: "Arun Murthy"
>> <arun.murthy@stericsson.com>
>>
>>
>> >The existing pwm based led and backlight driver makes use of the
>> >pwm(include/linux/pwm.h). So all the board specific pwm drivers will
>> >be exposing the same set of function name as in include/linux/pwm.h.
>> >As a result build fails in case of multi soc environments where each soc
>> >has a pwm device in it.
>>
>> This seems very specific to ST environment,
>No it's not. It's an issue Arun has hit while enabling one of the ST MFD chip,
>but he's tackling a generic issue.
>
>> looking at the driver list from
>> ( [PATCH 4/7] pwm: Align existing pwm drivers with pwm-core ) it seems
>> most multi SOC environments might support PWM in either one of the SOC.
>>
>> arch/arm/plat-mxc/pwm.c
>> arch/arm/plat-pxa/pwm.c
>> arch/arm/plat-samsung/pwm.c
>> arch/mips/jz4740/pwm.c
>> drivers/mfd/twl6030-pwm.c
>>
>> Unless people have examples of other SOCs which might use this,
>> the better approach might be to go for a custom driver rather than changing
>> the framework.
>I wouldn't call the current pwm code a framework. It's a bunch of header
>definitions that happens to work in the specific case of 1 pwm per
>sub architecture.
>What Arun is proposing is an actual framework. And it seems to be clean and
>simple enough.

FWIW, I agree with you Sam. Sooner or later, this will hit other SoCs.

-- 
balbi

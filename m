Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754618Ab2KZJDh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 04:03:37 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:43348 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754055Ab2KZJDd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 04:03:33 -0500
Message-ID: <50B33043.2020700@ti.com>
Date: Mon, 26 Nov 2012 10:02:59 +0100
From: Benoit Cousson <b-cousson@ti.com>
Organization: Texas Instruments
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: "Bedia, Vaibhav" <vaibhav.bedia@ti.com>
CC: "Philip, Avinash" <avinashphilip@ti.com>,
        "thierry.reding@avionic-design.de" <thierry.reding@avionic-design.de>,
        "paul@pwsan.com" <paul@pwsan.com>,
        "tony@atomide.com" <tony@atomide.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "Hiremath, Vaibhav" <hvaibhav@ti.com>,
        "AnilKumar, Chimata" <anilkumar@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "Nori, Sekhar" <nsekhar@ti.com>,
        "Hebbar, Gururaja" <gururaja.hebbar@ti.com>
Subject: Re: [PATCH v3 03/10] ARM: OMAP: AM33xx hwmod: Add parent-child relationship
 for PWM subsystem
References: <1353387831-31538-1-git-send-email-avinashphilip@ti.com> <1353387831-31538-4-git-send-email-avinashphilip@ti.com> <518397C60809E147AF5323E0420B992E3E9EEA8C@DBDE01.ent.ti.com> <B5906170F1614E41A8A28DE3B8D121433EC4C0FA@DBDE01.ent.ti.com>
In-Reply-To: <B5906170F1614E41A8A28DE3B8D121433EC4C0FA@DBDE01.ent.ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vaibhav,

On 11/26/2012 06:19 AM, Bedia, Vaibhav wrote:
> On Fri, Nov 23, 2012 at 16:36:06, Philip, Avinash wrote:
>> On Tue, Nov 20, 2012 at 10:33:44, Philip, Avinash wrote:
>>> As part of PWM subsystem integration, PWM subsystem are sharing
>>> resources like clock across submodules (ECAP, EQEP & EHRPWM).
>>> To handle resource sharing & IP integration
>>> 1. Rework on parent child relation between PWMSS and
>>>    ECAP, EQEP & EHRPWM child devices to support runtime PM.
>>> 2. Add support for opt_clks in EHRPWM HWMOD entry to handle additional
>>>    clock gating from control module.
>>> 3. Add HWMOD entries for EQEP PWM submodule.
>>>
>>
>> Is there any review on this patch?
>> This patch depends on ECAP & EHRPWM to work in am335x.
> 
> First of all, I think you should break up this patch as per the 3 points
> that you mentioned above.
> 
> The usage of opt_clks for this does not look right to me. Based on your
> description this clock is necessary and not optional on AM335x and on 
> Davinci platforms this clock does not exist. 
> 
> I think the custom activate/deactivate functions in the OMAP runtime PM
> implementation was a good fit for keeping this SoC integration detail out
> of the driver code. However, the current DT flow in omap_device.c seems to
> assign the default activate/deactivate ops. Is that approach deprecated?

The issue is that this approach is not doable anymore with DT, that's
why I had to provide a default set of functions.

Regards,
Benoit



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753123Ab2HBIZ5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 04:25:57 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:7216 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752324Ab2HBIZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 04:25:53 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Thu, 02 Aug 2012 01:25:52 -0700
Message-ID: <501A3A00.7070207@nvidia.com>
Date: Thu, 2 Aug 2012 17:27:44 +0900
From: Alex Courbot <acourbot@nvidia.com>
Organization: NVIDIA
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: Stephen Warren <swarren@wwwdotorg.org>,
        Stephen Warren <swarren@nvidia.com>, Simon Glass <sjg@chromium.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
Subject: Re: [RFC][PATCH v3 1/3] runtime interpreted power sequences
References: <1343390750-3642-1-git-send-email-acourbot@nvidia.com> <1343390750-3642-2-git-send-email-acourbot@nvidia.com> <50170EA0.1010408@wwwdotorg.org> <501A338D.7080105@nvidia.com> <20120802082157.GA14866@avionic-0098.adnet.avionic-design.de>
In-Reply-To: <20120802082157.GA14866@avionic-0098.adnet.avionic-design.de>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 02 Aug 2012 05:21:57 PM JST, Thierry Reding wrote:
> * PGP Signed by an unknown key
>
> On Thu, Aug 02, 2012 at 05:00:13PM +0900, Alex Courbot wrote:
>> On 07/31/2012 07:45 AM, Stephen Warren wrote:
>>> Oh I see. That's a little confusing. Why not just reference the relevant
>>> resources directly in each step; something more like:
>>>
>>> 		gpio@1 {
>>> 			action = "enable-gpio";
>>> 			gpio = <&gpio 1 0>;
>>> 		};
>>>
>>> I guess that might make parsing/building a little harder, since you'd
>>> have to detect when you'd already done gpio_request() on a given GPIO
>>> and not repeat it or something like that, but to me this makes the DT a
>>> lot easier to comprehend.
>>
>> I tried to move towards having the phandles directly in the
>> sequences themselves - that reminded me why I did not do that in the
>> first place. Let's say we have a sequence like this (reg property
>> omitted on purpose):
>>
>> 	power-on-sequence {
>> 		step@0 {
>> 			regulator = <&backlight_reg>;
>> 			enable;
>> 		};
>> 		step@1 {
>> 			delay = <10000>;
>> 		};
>> 		step@2 {
>> 			pwm = <&pwm 2 5000000>;
>> 			enable;
>> 		};
>> 		step@3 {
>> 			gpio = <&gpio 28 0>;
>> 			enable;
>> 		};
>> 	};
>>
>> The problem is, how do we turn these phandles into the resource of
>> interest. The type of the resource can be infered by the name of the
>> property. The hard part is resolving the resource from the phandle -
>> it seems like the API just does not allow to do this. GPIO has
>> of_get_named_gpio, but AFAIK there are no equivalent for regulator
>> consumer and PWM: the only way to use the DT with them is through
>> get_regulator and get_pwm which work at the device level.
>>
>> Or is there a way that I overlooked?
>
> No, you are right. Perhaps we should add exported functions that do the
> equivalent of of_pwm_request() or the regulator_dev_lookup() and
> of_get_regulator() pair.

How would that be looked with respect to "good DT practices"? I can 
somehow understand the wish to restrain DT access to these functions 
that integrate well with current workflows. Aren't we going to be 
frowned upon if we make more low-level functions public?

Alex.

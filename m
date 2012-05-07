Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757223Ab2EGPMI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 11:12:08 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:19021 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755872Ab2EGPMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 11:12:05 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Mon, 07 May 2012 08:11:59 -0700
Message-ID: <4FA7E57B.30804@nvidia.com>
Date: Mon, 7 May 2012 20:38:43 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "lrg@ti.com" <lrg@ti.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V1] regulator: fixed: dt: add property for gpio open drain
 flag
References: <1336386499-20408-1-git-send-email-ldewangan@nvidia.com> <4FA7E4A3.6050004@wwwdotorg.org>
In-Reply-To: <4FA7E4A3.6050004@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 07 May 2012 08:35 PM, Stephen Warren wrote:
> On 05/07/2012 04:28 AM, Laxman Dewangan wrote:
>> Add property for the gpio flag open drain when registering
>> fixed regulator.
>> diff --git a/Documentation/devicetree/bindings/regulator/fixed-regulator.txt ...
>> +- gpio-open-drain: GPIO is open drain type.
>> +  If this property is missing then default assumption is false.
> Given that there's a GPIOF_OPEN_DRAIN, isn't the GPIO specifier in the
> gpio property meant to encode this somehow (the format is up to the GPIO
> controller's binding) - the flags are returned by of_get_named_gpio_flags().
>
> (especially given you asked me off-list about updating the GPIO binding
> documentation with information about the flags that Tegra's binding
> documented for this)

gpio of binding does not explain that there is always gpio flag  
(GPIOF_*) in gpio cell argument. It is up to the chip specific gpio 
driver how they implement the argumnets.
For the example of gpio-samsung have the 4 argument list and all are for 
different purpose. And if they want to set pin as open drain, it will 
not be possible  on their argument list as none of the cell argument 
reflect to GPIOF_* flag.
For the case of tegra, there is no of_xlate() implementation and hence 
it is by default return as GPIOF_.

And the client driver which is indpendent of chip specific gpio driver 
should able to handle this.



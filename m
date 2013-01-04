Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754160Ab3ADE0k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 23:26:40 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:1648 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753854Ab3ADE0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 23:26:38 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Thu, 03 Jan 2013 20:26:33 -0800
Message-ID: <50E659F4.7020009@nvidia.com>
Date: Fri, 4 Jan 2013 09:56:28 +0530
From: Prashant Gaikwad <pgaikwad@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: "mturquette@linaro.org" <mturquette@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH v2 05/11] ARM: dt: tegra30: Add device node for APB MISC
References: <1356619644-18565-1-git-send-email-pgaikwad@nvidia.com> <1356619644-18565-6-git-send-email-pgaikwad@nvidia.com> <50E4AE19.1060503@wwwdotorg.org> <50E520FC.4070805@nvidia.com> <50E5ADA6.1070904@wwwdotorg.org> <50E634D0.6080702@nvidia.com> <50E6470E.8090206@wwwdotorg.org> <50E64B18.8060806@nvidia.com> <50E653E3.5060901@wwwdotorg.org>
In-Reply-To: <50E653E3.5060901@wwwdotorg.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 04 January 2013 09:30 AM, Stephen Warren wrote:
> On 01/03/2013 08:23 PM, Prashant Gaikwad wrote:
>> On Friday 04 January 2013 08:35 AM, Stephen Warren wrote:
>>> On 01/03/2013 06:48 PM, Prashant Gaikwad wrote:
>>>> On Thursday 03 January 2013 09:41 PM, Stephen Warren wrote:
> ...
>>>>> OK. It sounds like we need a true APB MISC driver then, to abstract the
>>>>> differences; the clock driver really shouldn't be touching the APB MISC
>>>>> registers in all likelihood, unless a subset of the sections you
>>>>> mention
>>>>> above are truly dedicated to clock functionality.
>>>> I don't think it is a good idea to create a driver for APB MISC, all
>>>> registers are used by different drivers.
>>> Well, it's even worse to have a bunch of other drivers randomly trample
>>> on a set of registers they don't own.
>>>
>>>> Only chip id revision registers are used in clock driver.
>>> There are already global variables exposed by the Tegra fuse driver; can
>>> you just read those?
>> It is not about variables or some value, we have to read some apb
>> register to flush the write operation in apb bus before we disable
>> peripheral clock.
>> We are using chip id revision register for this purpose.
> Ah. That's definitely not something the clock driver should be doing
> directly. It's probably OK to add a custom Tegra-specific function to
> some file in arch/arm/mach-tegra to implement this. Even better would be
> a full bus driver for the APB bus, but that's probably too much bloat
> for now.

tegra_init_fuse in arch/arm/mach-tegra/fuse.c is already reading chip id 
revision register, so I can implement one function to read this register 
in fuse.c, which will be used by clock driver and tegra_init_fuse.
But then we need to add it to some header file in include/mach or 
include/linux, where? any suggestion?

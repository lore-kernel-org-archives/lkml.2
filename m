Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753973Ab3ADEAi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 23:00:38 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:41994 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753840Ab3ADEAh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 23:00:37 -0500
Message-ID: <50E653E3.5060901@wwwdotorg.org>
Date: Thu, 03 Jan 2013 21:00:35 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Prashant Gaikwad <pgaikwad@nvidia.com>
CC: "mturquette@linaro.org" <mturquette@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH v2 05/11] ARM: dt: tegra30: Add device node for APB MISC
References: <1356619644-18565-1-git-send-email-pgaikwad@nvidia.com> <1356619644-18565-6-git-send-email-pgaikwad@nvidia.com> <50E4AE19.1060503@wwwdotorg.org> <50E520FC.4070805@nvidia.com> <50E5ADA6.1070904@wwwdotorg.org> <50E634D0.6080702@nvidia.com> <50E6470E.8090206@wwwdotorg.org> <50E64B18.8060806@nvidia.com>
In-Reply-To: <50E64B18.8060806@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/03/2013 08:23 PM, Prashant Gaikwad wrote:
> On Friday 04 January 2013 08:35 AM, Stephen Warren wrote:
>> On 01/03/2013 06:48 PM, Prashant Gaikwad wrote:
>>> On Thursday 03 January 2013 09:41 PM, Stephen Warren wrote:
...
>>>> OK. It sounds like we need a true APB MISC driver then, to abstract the
>>>> differences; the clock driver really shouldn't be touching the APB MISC
>>>> registers in all likelihood, unless a subset of the sections you
>>>> mention
>>>> above are truly dedicated to clock functionality.
>>>
>>> I don't think it is a good idea to create a driver for APB MISC, all
>>> registers are used by different drivers.
>>
>> Well, it's even worse to have a bunch of other drivers randomly trample
>> on a set of registers they don't own.
>>
>>> Only chip id revision registers are used in clock driver.
>> There are already global variables exposed by the Tegra fuse driver; can
>> you just read those?
> 
> It is not about variables or some value, we have to read some apb
> register to flush the write operation in apb bus before we disable
> peripheral clock.
> We are using chip id revision register for this purpose.

Ah. That's definitely not something the clock driver should be doing
directly. It's probably OK to add a custom Tegra-specific function to
some file in arch/arm/mach-tegra to implement this. Even better would be
a full bus driver for the APB bus, but that's probably too much bloat
for now.

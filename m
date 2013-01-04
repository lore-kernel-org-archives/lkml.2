Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754026Ab3ADDXQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 22:23:16 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:4857 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753799Ab3ADDXN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 22:23:13 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Thu, 03 Jan 2013 19:20:34 -0800
Message-ID: <50E64B18.8060806@nvidia.com>
Date: Fri, 4 Jan 2013 08:53:04 +0530
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
References: <1356619644-18565-1-git-send-email-pgaikwad@nvidia.com> <1356619644-18565-6-git-send-email-pgaikwad@nvidia.com> <50E4AE19.1060503@wwwdotorg.org> <50E520FC.4070805@nvidia.com> <50E5ADA6.1070904@wwwdotorg.org> <50E634D0.6080702@nvidia.com> <50E6470E.8090206@wwwdotorg.org>
In-Reply-To: <50E6470E.8090206@wwwdotorg.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 04 January 2013 08:35 AM, Stephen Warren wrote:
> On 01/03/2013 06:48 PM, Prashant Gaikwad wrote:
>> On Thursday 03 January 2013 09:41 PM, Stephen Warren wrote:
>>> On 01/02/2013 11:11 PM, Prashant Gaikwad wrote:
>>>> On Thursday 03 January 2013 03:30 AM, Stephen Warren wrote:
>>>>> On 12/27/2012 07:47 AM, Prashant Gaikwad wrote:
>>>>>> APB misc contains multiple registers required by different modules
>>>>>> such as CAR.
>>>>> I don't see a DT binding document that describes what
>>>>> nvidia,tegra30-apbmisc means. Also, the register range for this new
>>>>> node
>>>>> overlaps that for the pinmux node, so they can't both "request" their
>>>>> register region. You may need multiple entries in the apbmisc reg
>>>>> property to avoid this.
>>>> apbmisc reg for Tegra30 can be divided into following entries:
>>>>
>>>> strap registers
>>>> jtag configuration registers
>>>> pull_up/pull_down control registers
>>>> vclk control registers
>>>> tvdac registers
>>>> chip id revision registers
>>>> pad control registers
>>>>
>>>> This list is not same for Tegra20 and Tegra30.
>>> OK. It sounds like we need a true APB MISC driver then, to abstract the
>>> differences; the clock driver really shouldn't be touching the APB MISC
>>> registers in all likelihood, unless a subset of the sections you mention
>>> above are truly dedicated to clock functionality.
>> I don't think it is a good idea to create a driver for APB MISC, all
>> registers are used by different drivers.
> Well, it's even worse to have a bunch of other drivers randomly trample
> on a set of registers they don't own.
>
>> Only chip id revision registers are used in clock driver.
> There are already global variables exposed by the Tegra fuse driver; can
> you just read those?

It is not about variables or some value, we have to read some apb 
register to flush the write operation in apb bus before we disable 
peripheral clock.
We are using chip id revision register for this purpose.

>>>> OR
>>>>
>>>> another way is to add chip id revision register region to CAR node as
>>>> done for pinmux node and remove apb misc node.
>>> The pinmux controller doesn't have a reg entry for the chip ID register.
>>> I don't understand what you mean here.
>> I mean as we have separate entry for PAD control registers region in
>> pinmux node we can have also have separate entry for chid id revision
>> register region in CAR node.
> The pad control registers are part of the pinmux HW, so it makes perfect
> sense for the pinmux driver to control them. The APB misc registers
> aren't part of the clock register set, so it doesn't make sense to the
> clock driver to touch them.


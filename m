Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760115Ab2EVSBv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 14:01:51 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:11544 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759243Ab2EVSBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 14:01:46 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 22 May 2012 11:01:46 -0700
Message-ID: <4FBBD33C.8020802@nvidia.com>
Date: Tue, 22 May 2012 23:26:12 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Stephen Warren <swarren@nvidia.com>, "olof@lixom.net" <olof@lixom.net>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH 2/2] ARM: dt: tegra: cardhu: register core regulator tps65911
References: <1337691917-15040-1-git-send-email-ldewangan@nvidia.com> <1337691917-15040-2-git-send-email-ldewangan@nvidia.com> <4FBBC192.7030900@wwwdotorg.org> <4FBBC830.2060802@nvidia.com> <4FBBCA8F.3050903@wwwdotorg.org>
In-Reply-To: <4FBBCA8F.3050903@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 22 May 2012 10:49 PM, Stephen Warren wrote:
> On 05/22/2012 11:09 AM, Laxman Dewangan wrote:
>> On Tuesday 22 May 2012 10:10 PM, Stephen Warren wrote:
>>> On 05/22/2012 07:05 AM, Laxman Dewangan wrote:
>>>> Add device info for the PMIC device tps65911 in tegra-cardhu
>>>> dts file. This device supports the multiple regulator rails,
>>>> gpio, interrupts.
>>> FYI, patch 1 in this series looks fine. Some comments below though:
>>>
>>>> diff --git a/arch/arm/boot/dts/tegra-cardhu.dts
>>>> b/arch/arm/boot/dts/tegra-cardhu.dts
>>>> +        tps65911: tps65911@2d {
>>>> +            compatible = "ti,tps65911";
>>>> +            reg =<0x2d>;
>>>> +
>>>> +            #gpio-cells =<2>;
>>>> +            gpio-controller;
>>>> +
>>>> +            regulators {
>>> Please add the following properties here:
>>>
>>>      #address-cells =<1>;
>>>      #size-cells =<0>;
>>>
>>>> +                vdd1_reg: vdd1 {
>>> This node name should be "regulator", since nodes are generally named
>>> after the class of object they represent. Since all the nodes will then
>>> have the same name, you'll need to add a unit address ("@nnnn") to the
>>> node name.
>> Nop, we can not do it. The node name should match with the name
>> mentioned in driver otherwise the regulator node search will fail
>> Following is the excerpt of the code:
> Hmm. That seems wrong. I thought I had seen at least some regulator
> bindings where these nodes included a name property so that the nodes
> didn't need any particular name.
It is only applicable for the fixed regulators or the device supports 
only one regulator or each regulator have their own compatibility and 
the matching is done by compatibility, not by node name.


> Olof, what are your thoughts here - do we need to fix the code so the
> node names aren't relevant? IIRC, we have had to change some other
> bindings due to the same issue.
>
> ...
>>> Nitpicky, but the labels might be more logical as reg_vdd1 rather than
>>> vdd1_reg, but not a big deal.
>>>
>>> So, please replace the line above with:
>>>
>>>      reg_vdd1: regulator@0 {
>>>          reg =<0>;
>>>
>> Why do we really require the reg at all?
>> I dont think any usage of doing this.
> I guess if these regulators are enabled at boot and always on, we don't
> even need the labels for now; we could add labels later as/when drivers
> begin to dynamically control the regulators.

I think we should provide the label here whether it is always on or not.
The driver who uses the rails will not aware that rail is always on or not.
Second thing is that this gives uniformity and whenever any consumer get 
added, we will not touch this part, only will be change in the driver 
specific part.



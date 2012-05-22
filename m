Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760160Ab2EVS1l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 14:27:41 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:56174 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759947Ab2EVS1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 14:27:39 -0400
Message-ID: <4FBBDA97.6000006@wwwdotorg.org>
Date: Tue, 22 May 2012 12:27:35 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: Stephen Warren <swarren@nvidia.com>, "olof@lixom.net" <olof@lixom.net>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH 2/2] ARM: dt: tegra: cardhu: register core regulator tps65911
References: <1337691917-15040-1-git-send-email-ldewangan@nvidia.com> <1337691917-15040-2-git-send-email-ldewangan@nvidia.com> <4FBBC192.7030900@wwwdotorg.org> <4FBBC830.2060802@nvidia.com> <4FBBCA8F.3050903@wwwdotorg.org> <4FBBD33C.8020802@nvidia.com>
In-Reply-To: <4FBBD33C.8020802@nvidia.com>
X-Enigmail-Version: 1.5pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/22/2012 11:56 AM, Laxman Dewangan wrote:
> On Tuesday 22 May 2012 10:49 PM, Stephen Warren wrote:
>> On 05/22/2012 11:09 AM, Laxman Dewangan wrote:
>>> On Tuesday 22 May 2012 10:10 PM, Stephen Warren wrote:
>>>> On 05/22/2012 07:05 AM, Laxman Dewangan wrote:
>>>>> Add device info for the PMIC device tps65911 in tegra-cardhu
>>>>> dts file. This device supports the multiple regulator rails,
>>>>> gpio, interrupts.
...
>>>> Nitpicky, but the labels might be more logical as reg_vdd1 rather than
>>>> vdd1_reg, but not a big deal.
>>>>
>>>> So, please replace the line above with:
>>>>
>>>>      reg_vdd1: regulator@0 {
>>>>          reg = <0>;
>>>
>>> Why do we really require the reg at all?
>>> I dont think any usage of doing this.

Oh, perhaps you meant the reg property not "reg_" in the label name?

It is required because the parent node has #address-cells and
#size-cells and because the node name itself has a unit address ("@nnn").

>> I guess if these regulators are enabled at boot and always on, we don't
>> even need the labels for now; we could add labels later as/when drivers
>> begin to dynamically control the regulators.
> 
> I think we should provide the label here whether it is always on or not.
> The driver who uses the rails will not aware that rail is always on or not.
> Second thing is that this gives uniformity and whenever any consumer get
> added, we will not touch this part, only will be change in the driver
> specific part.

Yes, if drivers are referring to these nodes, you do need the label.

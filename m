Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755863Ab2JVRO2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 13:14:28 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:56929 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755632Ab2JVRO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 13:14:26 -0400
Message-ID: <50857EEF.2070707@wwwdotorg.org>
Date: Mon, 22 Oct 2012 11:14:23 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Mark Zhang <markz@nvidia.com>
CC: "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: dt: tegra: ventana: define pinmux for ddc
References: <1350626311-18131-1-git-send-email-markz@nvidia.com> <50817668.6020709@wwwdotorg.org> <5084F5D1.7050005@nvidia.com>
In-Reply-To: <5084F5D1.7050005@nvidia.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/22/2012 01:29 AM, Mark Zhang wrote:
> On 10/19/2012 11:48 PM, Stephen Warren wrote:
>> On 10/18/2012 11:58 PM, Mark Zhang wrote:
>>> Define pinmux for DDC. The DDC pinmux in Ventana is 2 pins in I2C2.
>>
>>> +++ b/arch/arm/boot/dts/tegra20-ventana.dts
>>
>>> -            ddc {
>>> -                nvidia,pins = "ddc", "owc", "spdi", "spdo",
>>> -                    "uac";
>>> -                nvidia,function = "rsvd2";
>>> -            };
>>
>> So that removes the entries for 5 pin groups, yet below, entries are
>> only added for the ddc and pta pingroups, so the other 4 pin groups
>> become unconfigured.
>>
> 
> Right. So I think it should be changed to:
> 
>         owc {
>             nvidia,pins = "owc", "spdi", "spdo", "uac";
>             nvidia,function = "rsvd2";
>         };
> 
> Is this right?

Looks correct, yes.

>>> +
>>> +        state_i2cmux_ddc: pinmux_i2cmux_ddc {
>>> +            ddc {
>>> +                nvidia,pins = "ddc";
>>> +                nvidia,function = "i2c2";
>>> +            };
>>> +            pta {
>>> +                nvidia,pins = "pta";
>>> +                nvidia,function = "rsvd4";
>>> +            };
>>
>> Does this actually work? The pta pingroup is configured by the "hog"
>> pinctrl state of the pinctrl node itself, so this state should fail to
>> be applied since it attempts to touch the same pingroup.
> 
> I know little about kernel pinctrl subsystem. After reading some docs
> and codes, I think what you mean is, in Ventana's pinmux configuration,
> pta pingroup has been defined as "hdmi" function and this can't be
> changed(non-dynamic pinmuxing).
> So I want to know why we have defined pta pingroup as hdmi function?
> Can we remove this definition to make the i2cmux above working?

I don't recall why pta was defined to be HDMI. The issue isn't that this
patch changes the pinmux selection for the pta pingroup, but simply that
both the pinctrl node's state definition, and the new I2C mux node's
state definition both attempt to configure pingroup pta. The solution is
most likely to simply remove the pta configuration from the main pinctrl
node.

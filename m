Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751582Ab2JVHgA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 03:36:00 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:9957 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785Ab2JVHf6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 03:35:58 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Mon, 22 Oct 2012 00:29:24 -0700
Message-ID: <5084F5D1.7050005@nvidia.com>
Date: Mon, 22 Oct 2012 15:29:21 +0800
From: Mark Zhang <markz@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: dt: tegra: ventana: define pinmux for ddc
References: <1350626311-18131-1-git-send-email-markz@nvidia.com> <50817668.6020709@wwwdotorg.org>
In-Reply-To: <50817668.6020709@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/19/2012 11:48 PM, Stephen Warren wrote:
> On 10/18/2012 11:58 PM, Mark Zhang wrote:
>> Define pinmux for DDC. The DDC pinmux in Ventana is 2 pins in I2C2.
>
>> +++ b/arch/arm/boot/dts/tegra20-ventana.dts
>
>> -			ddc {
>> -				nvidia,pins = "ddc", "owc", "spdi", "spdo",
>> -					"uac";
>> -				nvidia,function = "rsvd2";
>> -			};
>
> So that removes the entries for 5 pin groups, yet below, entries are
> only added for the ddc and pta pingroups, so the other 4 pin groups
> become unconfigured.
>

Right. So I think it should be changed to:

		owc {
			nvidia,pins = "owc", "spdi", "spdo", "uac";
			nvidia,function = "rsvd2";
		};

Is this right?

>> +
>> +		state_i2cmux_ddc: pinmux_i2cmux_ddc {
>> +			ddc {
>> +				nvidia,pins = "ddc";
>> +				nvidia,function = "i2c2";
>> +			};
>> +			pta {
>> +				nvidia,pins = "pta";
>> +				nvidia,function = "rsvd4";
>> +			};
>
> Does this actually work? The pta pingroup is configured by the "hog"
> pinctrl state of the pinctrl node itself, so this state should fail to
> be applied since it attempts to touch the same pingroup.
>

I know little about kernel pinctrl subsystem. After reading some docs 
and codes, I think what you mean is, in Ventana's pinmux configuration, 
pta pingroup has been defined as "hdmi" function and this can't be 
changed(non-dynamic pinmuxing).
So I want to know why we have defined pta pingroup as hdmi function?
Can we remove this definition to make the i2cmux above working?

>> +	i2cmux {
> ...
>> +		i2c@1 {
>> +			reg = <1>;
>> +			#address-cells = <1>;
>> +			#size-cells = <0>;
>> +
>> +			smart-battery@b {
>> +				compatible = "ti,bq24617", "smart-battery-1.1";
>> +				reg = <0xb>;
>> +				ti,i2c-retry-count = <2>;
>> +				ti,poll-retry-count = <10>;
>> +			};
>
> That wasn't there before. Does that device actually exist on Ventana?
> Adding it should be a separate patch if so, since this one is just about
> introducing the I2C mux, not adding an SBS device. Was this all just
> cut/paste from Seaboard without validation?
>

Yes, I didn't validate this. Actually, I don't know how to validate. I 
have no idea about SBS device. But I have checked the schematic of 
Ventana and it has this "bq24617" battery charge controller(for 
seaboard, it's bq20z75).
So I agree with you not to include this part in the patch.

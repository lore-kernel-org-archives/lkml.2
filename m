Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933423Ab2C2AHF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 20:07:05 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:59253 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933046Ab2C2AG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 20:06:59 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6663"; a="176751040"
Message-ID: <4F73A798.6030607@codeaurora.org>
Date: Wed, 28 Mar 2012 17:06:48 -0700
From: Michael Bohan <mbohan@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: rnayak@ti.com, lrg@ti.com, LKML <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org
Subject: Re: Regulator supplies when using Device Tree
References: <4F6BCF47.4090200@codeaurora.org> <20120326130005.GQ3098@opensource.wolfsonmicro.com> <4F726B96.8070508@codeaurora.org> <20120328100957.GD3232@opensource.wolfsonmicro.com> <4F736451.8020900@codeaurora.org> <20120328193341.GD3232@opensource.wolfsonmicro.com>
In-Reply-To: <20120328193341.GD3232@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/28/2012 12:33 PM, Mark Brown wrote:
> On Wed, Mar 28, 2012 at 12:19:45PM -0700, Michael Bohan wrote:
>> Within the regulator driver, we currently have to do an
>> of_get_property(of_node, "foo-supply", NULL) to determine whether
>> the device has a supply, and thus whether we should assign
>> rdesc->supply_name to "foo" or not when calling
>
> No, this would be completely idiotic.  Please think about what I'm
> saying here.  To repeat, supplies of all kinds are always requested with
> the name the chip uses for the supply.  This means that any machine
> binding is *totally* irrelevant to the regulator driver.

I'm not sure we're even talking about the same problem here. I agree 
that the name used for the supply should correspond with the data sheet 
- I just don't know how that's relevant.

Put simply, whose responsibility is it to assign the 
regulator_desc->supply_name pointer before registering a regulator 
device added from Device Tree? And do you agree that if you assign this 
pointer to a name for which there isn't a Device Tree property specified 
in that device_node, then regulator_register() will fail? This happens 
because of_get_regulator() tacks on a "-supply" at the end and then 
calls of_get_property() on the resulting string. That call will fail 
since there is no property specified in the device_node. This is the 
scenario I'm trying to avoid. Thus I add an additional check with 
of_get_property() in my driver to see if the property does exist before 
registering the regulator device, since both cases are reasonable. One 
is a regulator device with a supply, and one is a regulator device 
without a supply.

Are you aware of any other examples of submitted drivers with Device 
Tree support that implement regulator devices that optionally have an 
upstream supply? I looked at your tree recently and couldn't see any 
such cases.

Thanks,
Mike

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

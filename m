Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753850Ab2DBRf5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 13:35:57 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:27616 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753793Ab2DBRfz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 13:35:55 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6668"; a="175824776"
Message-ID: <4F79E35A.5040908@codeaurora.org>
Date: Mon, 02 Apr 2012 10:35:22 -0700
From: Michael Bohan <mbohan@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:11.0) Gecko/20120312 Thunderbird/11.0
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: rnayak@ti.com, lrg@ti.com, LKML <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org
Subject: Re: Regulator supplies when using Device Tree
References: <4F6BCF47.4090200@codeaurora.org> <20120326130005.GQ3098@opensource.wolfsonmicro.com> <4F726B96.8070508@codeaurora.org> <20120328100957.GD3232@opensource.wolfsonmicro.com> <4F736451.8020900@codeaurora.org> <20120328193341.GD3232@opensource.wolfsonmicro.com> <4F73A798.6030607@codeaurora.org> <20120329111159.GJ3668@opensource.wolfsonmicro.com> <4F7509F4.6010303@codeaurora.org> <20120330103602.GE21950@opensource.wolfsonmicro.com>
In-Reply-To: <20120330103602.GE21950@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/30/2012 3:36 AM, Mark Brown wrote:
> On Thu, Mar 29, 2012 at 06:18:44PM -0700, Michael Bohan wrote:
>> Can you please elaborate on why this is a bad design? We have always
>> used this model in the past, and the regulator framework is happy to
>> support it.
>
> The support for regulator-regulator supplies has always been problematic
> and infrequently used -

Hmm, I'd be interested to know the history there.

> Please be more specific about what you're actually trying to physically
> accomplish here.  It would be *extremely* unusual to see a regulator
> which was able to do something useful without any input power and if you
> genuinely have this need whatever you're doing probably needs the
> framework to actually be aware of what's going on.  However...

Some of our regulators take inputs from other regulators. Some 
regulators take their input from the battery. We support both types in 
the same driver, since the hardware is the same. Thus this supply 
configuration is natural and matches our hardware closely. The actual 
connections of our regulators varies between different board designs.

If you're interested, you can checkout some sample driver code:

https://www.codeaurora.org/gitweb/quic/la/?p=kernel/msm.git;a=blob;f=drivers/regulator/pm8xxx-regulator.c;h=fd691f051428158d3543dd7562e4f5e26e905962;hb=msm-3.0

And see how we pass the supply names and other parameters here:

https://www.codeaurora.org/gitweb/quic/la/?p=kernel/msm.git;a=blob;f=arch/arm/mach-msm/board-8960-regulator.c;h=23e3e690ff0e582fd947553a51015f5059750cdf;hb=msm-3.0

We have a table of devices with associated data attributes -- one of 
them being supplies. For devices with supplies, the name is specified. 
For devices without supplies, nothing is specified. This works well 
since then the driver doesn't need to check whether there exists a 
supply or not.

>> I was hoping that we could continue to treat regulator supplies as
>> normal supplies, but somehow allow the framework to determine
>> whether a regulator supply exists or not in the Device Tree
>> configuration so the driver doesn't have to.
>
> ...this doesn't really make any sense - the new scheme makes regulator
> supplies *more* like normal supplies, not less, since they're now
> specified in exactly the same way as other supplies and are just assumed
> to be provided by the leaf driver.

I don't disagree that the new scheme makes supplies more like normal 
supplies. I'm just pointing out the solution doesn't appear perfect 
since extraneous code is put in the driver in this case.

Thanks,
Mike

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

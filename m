Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753550Ab1CPSkK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 14:40:10 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:16628 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751218Ab1CPSkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 14:40:06 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6287"; a="80140607"
From: David Brown <davidb@codeaurora.org>
To: Daniel Walker <dwalker@fifo99.com>
Cc: Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Saravana Kannan <skannan@codeaurora.org>
Subject: Re: [PATCH 2/3] msm: Peripheral Image Loader (PIL) driver
References: <1299732274-10742-1-git-send-email-sboyd@codeaurora.org>
	<1299732274-10742-3-git-send-email-sboyd@codeaurora.org>
	<1300270820.13755.14.camel@desktop>
Date: Wed, 16 Mar 2011 11:40:27 -0700
In-Reply-To: <1300270820.13755.14.camel@desktop> (Daniel Walker's message of
	"Wed, 16 Mar 2011 03:20:19 -0700")
Message-ID: <8ya62riucx0.fsf@huya.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 16 2011, Daniel Walker wrote:

> On Wed, 2011-03-09 at 20:44 -0800, Stephen Boyd wrote:
>> On 8660, the modem, dsp, and sensors peripherals require their
>> firmware to be loaded into memory before they can be properly
>> taken out of reset.
>> 
>> Drivers are expected to call pil_get() when they wish to load a
>> peripheral. This will initiate multiple firmware_request()s for
>> the metadata and image blobs for a peripheral. Once the image has
>> been loaded into memory, it is validated and brought out of reset
>> via the peripheral reset driver.
>
> Why can't this be part of the generic firmware request API ?

Can you clarify what you mean by this?  The firmware request API is used
to get the firmware itself, which this code uses.  This code is what
manages making those calls for the various MSM peripherals that require
firmware.

>> diff --git a/arch/arm/mach-msm/Kconfig b/arch/arm/mach-msm/Kconfig
>> index 997c5bd..25b73b0 100644
>> --- a/arch/arm/mach-msm/Kconfig
>> +++ b/arch/arm/mach-msm/Kconfig
>> @@ -210,4 +210,17 @@ config IOMMU_API
>>  
>>  config MSM_SCM
>>         bool
>> +
>> +config MSM_PIL
>> +       bool "Peripheral image loading (PIL)"
>> +       select FW_LOADER
>> +       select MSM_SCM
>> +       depends on ARCH_MSM8X60
>> +       help
>> +         Some peripherals need to be loaded into memory before they
>> can be
>> +         brought out of reset.
>> +
>> +         Say yes to support these devices.
>> +
>> +
>
> You shouldn't be adding anything like this to the Kconfig. To me if you
> add stuff like this it's a big red flag.

Can you clarify what you mean "stuff like this".

It seems to me that this option should be selected by the drivers that
need it, since it doesn't make sense to have this if there are no
drivers that need it, and it is required when those drivers are
included.

I do think there are valid hardware configurations that don't have any
peripherals needing firmware, and would think that those should be able
to avoid requiring the code to manage that.  Saravana/Stephen can
clarify that, though.

Thanks,
David

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

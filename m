Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932926Ab1CWWqh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 18:46:37 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:12387 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932785Ab1CWWqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 18:46:36 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6294"; a="81490359"
From: David Brown <davidb@codeaurora.org>
To: Carl Vanderlip <carlv@codeaurora.org>
Cc: Daniel Walker <dwalker@fifo99.com>, Russell King <linux@arm.linux.org.uk>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Brian Swetland <swetland@google.com>, Dima Zavin <dima@android.com>,
        Rebecca Schultz Zavin <rebecca@android.com>,
        Colin Cross <ccross@android.com>, linux-fbdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/20] video: msm: Split out MDP2.2 HW specific code.
References: <1300484846-26393-1-git-send-email-carlv@codeaurora.org>
	<1300485423-27281-1-git-send-email-carlv@codeaurora.org>
	<1300885912.6117.16.camel@m0nster> <4D8A5B44.9050306@codeaurora.org>
Date: Wed, 23 Mar 2011 15:47:15 -0700
In-Reply-To: <4D8A5B44.9050306@codeaurora.org> (Carl Vanderlip's message of
	"Wed, 23 Mar 2011 13:42:44 -0700")
Message-ID: <8yay6455ua4.fsf@huya.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 23 2011, Carl Vanderlip wrote:

> On 03/23/2011 06:11 AM, Daniel Walker wrote:
>> On Fri, 2011-03-18 at 14:57 -0700, Carl Vanderlip wrote:
>>> index df9d74e..d6e75c3 100644
>>> --- a/arch/arm/mach-msm/Kconfig
>>> +++ b/arch/arm/mach-msm/Kconfig
>>> @@ -76,6 +76,11 @@ config HAS_MSM_DEBUG_UART_PHYS
>>>  config  MSM_VIC
>>>         bool
>>>  
>>> +config MSM_MDP22
>>> +       bool
>>> +       depends on ARCH_MSM7X00A
>>> +       default y
>>> + 
>> You should remove the "default y" and this should be moved to a Kconfig
>> under video (shouldn't be added into mach-msm).
>>
>> Daniel
>>
> What about removing the 'depends on' and 'default y' and making it be
> selected by MSM7X00A?

But why should the feature be in the Kconfig for arch/arm/mach-msm when
the driver is under drivers/video/msm?  If it does indeed need
configuration, why not put a Kconfig under drivers/video/msm?

The last patch does select this, so it shouldn't need to get a default.

Does the code work if both MDP22 and MDP31 are defined?  Eventually, it
will be possible to enable multiple SOCs, so this driver will need to be
able to handle that determination at run-time.

David 

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758164Ab1BKVDa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 16:03:30 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:47093 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758096Ab1BKVD3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 16:03:29 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6254"; a="73901429"
From: David Brown <davidb@codeaurora.org>
To: Steve Muckle <smuckle@codeaurora.org>
Cc: Daniel Walker <dwalker@codeaurora.org>,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] msm: iommu: Generalize platform data for multiple targets
In-Reply-To: <4D55A16A.7030300@codeaurora.org> (Steve Muckle's message of
	"Fri, 11 Feb 2011 12:51:54 -0800")
References: <1297456098-3241-1-git-send-email-stepanm@codeaurora.org>
	<1297456098-3241-2-git-send-email-stepanm@codeaurora.org>
	<1297456934.4852.11.camel@m0nster> <4D55A16A.7030300@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
X-Hashcash: 1:20:110211:stepanm@codeaurora.org::EUzkR1WGKYkIi5eP:0000000000000000000000000000000000000000ZOL
X-Hashcash: 1:20:110211:linux-kernel@vger.kernel.org::Wmcoyat1yl4fVP94:0000000000000000000000000000000000kWo
X-Hashcash: 1:20:110211:smuckle@codeaurora.org::I2lvKyNQHsMp/pVK:0000000000000000000000000000000000000004VJ2
X-Hashcash: 1:20:110211:linux-arm-msm@vger.kernel.org::DM2SrdGZBefg/ubT:000000000000000000000000000000005XUX
X-Hashcash: 1:20:110211:dwalker@codeaurora.org::OXzOqMALWdVwRDJu:0000000000000000000000000000000000000007tYC
X-Hashcash: 1:20:110211:linux-arm-kernel@lists.infradead.org::JxwoKYfoOJScQ43E:00000000000000000000000008DLG
Date: Fri, 11 Feb 2011 13:03:28 -0800
Message-ID: <8yaipwql1wf.fsf@huya.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 11 2011, Steve Muckle wrote:

> On 02/11/11 12:42, Daniel Walker wrote:
>>>  static struct resource msm_iommu_jpegd_resources[] = {
>>>  	{
>>> -		.start = MSM_IOMMU_JPEGD_PHYS,
>>> -		.end   = MSM_IOMMU_JPEGD_PHYS + MSM_IOMMU_JPEGD_SIZE - 1,
>>> +		.start = 0x07300000,
>>> +		.end   = 0x07300000 + SZ_1M - 1,
>> 
>> Looks worse .. Just put the macros into a static header file for both.
>
> Why bother defining macros for these if they only appear here? I don't
> think that adds any value or readability - these addresses are clearly
> the physical area for the msm_iommu_jpegd. It just makes it more
> annoying to have to look up the values in a separate file if you are
> wondering what they are.

I want to chime in with a second on this.  Defining names for constants
serves several purposes:

  - It gives meaning to the constants.

  - It allows the definition to be centralized if the value is used in
    one place.

If the constants are initializers in a table, it satisfies both of these
reasons.  Adding #defines for these constants does nothing other than
cause an extra indirection that the reader of the code has to make.

If they were used in more than one place, we could justify the
definition, but in this case, the definition just obscures the code
slightly.

David

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

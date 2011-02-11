Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757249Ab1BKVO4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 16:14:56 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:30431 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757133Ab1BKVOy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 16:14:54 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6254"; a="74110414"
Subject: Re: [PATCH 2/3] msm: iommu: Generalize platform data for multiple
 targets
From: Daniel Walker <dwalker@codeaurora.org>
To: David Brown <davidb@codeaurora.org>
Cc: Steve Muckle <smuckle@codeaurora.org>,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <8yaipwql1wf.fsf@huya.qualcomm.com>
References: <1297456098-3241-1-git-send-email-stepanm@codeaurora.org>
	 <1297456098-3241-2-git-send-email-stepanm@codeaurora.org>
	 <1297456934.4852.11.camel@m0nster> <4D55A16A.7030300@codeaurora.org>
	 <8yaipwql1wf.fsf@huya.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 11 Feb 2011 13:14:49 -0800
Message-ID: <1297458889.4852.24.camel@m0nster>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-02-11 at 13:03 -0800, David Brown wrote:
> On Fri, Feb 11 2011, Steve Muckle wrote:
> 
> > On 02/11/11 12:42, Daniel Walker wrote:
> >>>  static struct resource msm_iommu_jpegd_resources[] = {
> >>>  	{
> >>> -		.start = MSM_IOMMU_JPEGD_PHYS,
> >>> -		.end   = MSM_IOMMU_JPEGD_PHYS + MSM_IOMMU_JPEGD_SIZE - 1,
> >>> +		.start = 0x07300000,
> >>> +		.end   = 0x07300000 + SZ_1M - 1,
> >> 
> >> Looks worse .. Just put the macros into a static header file for both.
> >
> > Why bother defining macros for these if they only appear here? I don't
> > think that adds any value or readability - these addresses are clearly
> > the physical area for the msm_iommu_jpegd. It just makes it more
> > annoying to have to look up the values in a separate file if you are
> > wondering what they are.
> 
> I want to chime in with a second on this.  Defining names for constants
> serves several purposes:
> 
>   - It gives meaning to the constants.
> 
>   - It allows the definition to be centralized if the value is used in
>     one place.
> 
> If the constants are initializers in a table, it satisfies both of these
> reasons.  Adding #defines for these constants does nothing other than
> cause an extra indirection that the reader of the code has to make.
> 
> If they were used in more than one place, we could justify the
> definition, but in this case, the definition just obscures the code
> slightly.

It only obscures the constant, which no one really looks at anyway. in
general it's better design to hide constant like this, because people
don't work naturally with numbers like this.

A good example might be if all these constants are enumerated in a
header file, but aren't all used. In that case it would be fairly easy
to add a new resource without even know what the constant is just by
following the pattern.

I think in general this series just makes this iommu code very much
8660/8960 only code, but what about the potential next iteration of SoC
that uses very similar code to this with all new constants. So this
doesn't seem forward thinking to me.

Daniel


-- 
Sent by an consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora
Forum.



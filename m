Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760629Ab2CMXSL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 19:18:11 -0400
Received: from mga09.intel.com ([134.134.136.24]:2357 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753414Ab2CMXSI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 19:18:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="117419729"
From: bruce robertson <bruce.e.robertson@intel.com>
To: Jason Wortham <Jason.Wortham@maxim-ic.com>
Cc: Anton Vorontsov <cbouatmailru@gmail.com>,
        "dirk.brandewie\@gmail.com" <dirk.brandewie@gmail.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dg77.kim\@samsung.com" <dg77.kim@samsung.com>,
        "kyungmin.park\@samsung.com" <kyungmin.park@samsung.com>,
        "myungjoo.ham\@samsung.com" <myungjoo.ham@samsung.com>
Subject: Re: [PATCH 4/5] max17042: Fix value scaling for VCELL and avgVCELL
References: <1327425968-21195-1-git-send-email-dirk.brandewie@gmail.com>
	<1327425968-21195-5-git-send-email-dirk.brandewie@gmail.com>
	<20120313181918.GA15964@oksana.dev.rtsoft.ru>
	<m3pqcg5i8y.fsf@intel.com>
	<26513DAD5DB1304EAC06B61C2DD20C270DB5ECE32F@ITSVLEX06.it.maxim-ic.internal>
Date: Tue, 13 Mar 2012 16:18:08 -0700
In-Reply-To: <26513DAD5DB1304EAC06B61C2DD20C270DB5ECE32F@ITSVLEX06.it.maxim-ic.internal>
	(Jason Wortham's message of "Tue, 13 Mar 2012 14:04:12 -0700")
Message-ID: <m3fwdcxf7z.fsf@intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jason Wortham <Jason.Wortham@maxim-ic.com> writes:

> The bottom 3 bits are still functional bits and aren't required to be masked.  Arguably these bits are below the hardware accuracy of the ADC, however, they still provide some averaging information.

About the multiplier. why are the multipliers 83? 83*8==664 uV.

>
> --Jason
>
> -----Original Message-----
> From: bruce robertson [mailto:bruce.e.robertson@intel.com] 
> Sent: Tuesday, March 13, 2012 2:00 PM
> To: Anton Vorontsov
> Cc: dirk.brandewie@gmail.com; linux-kernel@vger.kernel.org; dg77.kim@samsung.com; kyungmin.park@samsung.com; myungjoo.ham@samsung.com; Jason Wortham
> Subject: Re: [PATCH 4/5] max17042: Fix value scaling for VCELL and avgVCELL
>
> Anton Vorontsov <cbouatmailru@gmail.com> writes:
>
>> On Tue, Jan 24, 2012 at 09:26:07AM -0800, dirk.brandewie@gmail.com wrote:
>>> From: Bruce Robertson <bruce.e.robertson@intel.com>
>>> 
>>> The bottom three bits of the register are don't care bits.  The LSB
>>> value is 625 uV.  Adjust the returned values appropriately
>>> 
>>> Signed-off-by: Bruce Robertson <bruce.e.robertson@intel.com>
>>> Signed-off-by: Dirk Brandewie <dirk.brandewie@gmail.com>
>>> Acked-by: MyungJoo Ham <myungjoo.ham@samsung.com>
>>
>> I guess this was fixed long ago by the following patch:
>>
>> commit cf7a8c03db792894f436db5f3ffc44d947b9b068
>> Author: MyungJoo Ham <myungjoo.ham@samsung.com>
>> Date:   Wed Aug 17 10:18:34 2011 +0900
>>
>>     max17042_battery: Bugfix of incorrect voltage register value interpretation
>>
>>     The calculation had error in getting voltage values from
>>     MAX17042 registers. The least bit denotes 78.125uV (625/8).
>
> The multipliers I see in the patch are 83 making the voltages somewhat
> high and the low 3 bits are not masked off. I'm probably misreading the code.
>
>>
>>     Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
>>     Signed-off-by: Philip Rakity <prakity@marvell.com>
>>     Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>>     Signed-off-by: Anton Vorontsov <cbouatmailru@gmail.com>
>>
>> Thanks,

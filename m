Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760598Ab2CMW7f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 18:59:35 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:49332 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760329Ab2CMW7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 18:59:32 -0400
Message-ID: <4F5FD151.104@gmail.com>
Date: Tue, 13 Mar 2012 15:59:29 -0700
From: Dirk Brandewie <dirk.brandewie@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Jason Wortham <Jason.Wortham@maxim-ic.com>
CC: bruce robertson <bruce.e.robertson@intel.com>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        "dirk.brandewie@gmail.com" <dirk.brandewie@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dg77.kim@samsung.com" <dg77.kim@samsung.com>,
        "kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
        "myungjoo.ham@samsung.com" <myungjoo.ham@samsung.com>
Subject: Re: [PATCH 4/5] max17042: Fix value scaling for VCELL and avgVCELL
References: <1327425968-21195-1-git-send-email-dirk.brandewie@gmail.com> <1327425968-21195-5-git-send-email-dirk.brandewie@gmail.com> <20120313181918.GA15964@oksana.dev.rtsoft.ru> <m3pqcg5i8y.fsf@intel.com> <26513DAD5DB1304EAC06B61C2DD20C270DB5ECE32F@ITSVLEX06.it.maxim-ic.internal>
In-Reply-To: <26513DAD5DB1304EAC06B61C2DD20C270DB5ECE32F@ITSVLEX06.it.maxim-ic.internal>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/13/2012 02:04 PM, Jason Wortham wrote:
> The bottom 3 bits are still functional bits and aren't required to be masked.  Arguably these bits are below the hardware accuracy of the ADC, however, they still provide some averaging information.
>

The datasheet for the 17042 shows the bottom three bits as don't care that
was the reason for the mask.

If Jason says it is still accurate without the mask I am fine with it.

--Dirk
> --Jason
>
> -----Original Message-----
> From: bruce robertson [mailto:bruce.e.robertson@intel.com]
> Sent: Tuesday, March 13, 2012 2:00 PM
> To: Anton Vorontsov
> Cc: dirk.brandewie@gmail.com; linux-kernel@vger.kernel.org; dg77.kim@samsung.com; kyungmin.park@samsung.com; myungjoo.ham@samsung.com; Jason Wortham
> Subject: Re: [PATCH 4/5] max17042: Fix value scaling for VCELL and avgVCELL
>
> Anton Vorontsov<cbouatmailru@gmail.com>  writes:
>
>> On Tue, Jan 24, 2012 at 09:26:07AM -0800, dirk.brandewie@gmail.com wrote:
>>> From: Bruce Robertson<bruce.e.robertson@intel.com>
>>>
>>> The bottom three bits of the register are don't care bits.  The LSB
>>> value is 625 uV.  Adjust the returned values appropriately
>>>
>>> Signed-off-by: Bruce Robertson<bruce.e.robertson@intel.com>
>>> Signed-off-by: Dirk Brandewie<dirk.brandewie@gmail.com>
>>> Acked-by: MyungJoo Ham<myungjoo.ham@samsung.com>
>>
>> I guess this was fixed long ago by the following patch:
>>
>> commit cf7a8c03db792894f436db5f3ffc44d947b9b068
>> Author: MyungJoo Ham<myungjoo.ham@samsung.com>
>> Date:   Wed Aug 17 10:18:34 2011 +0900
>>
>>      max17042_battery: Bugfix of incorrect voltage register value interpretation
>>
>>      The calculation had error in getting voltage values from
>>      MAX17042 registers. The least bit denotes 78.125uV (625/8).
>
> The multipliers I see in the patch are 83 making the voltages somewhat
> high and the low 3 bits are not masked off. I'm probably misreading the code.
>
>>
>>      Signed-off-by: MyungJoo Ham<myungjoo.ham@samsung.com>
>>      Signed-off-by: Philip Rakity<prakity@marvell.com>
>>      Signed-off-by: Kyungmin Park<kyungmin.park@samsung.com>
>>      Signed-off-by: Anton Vorontsov<cbouatmailru@gmail.com>
>>
>> Thanks,


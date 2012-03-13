Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756094Ab2CMVAP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 17:00:15 -0400
Received: from mga09.intel.com ([134.134.136.24]:47395 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755665Ab2CMVAN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 17:00:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="120693531"
From: bruce robertson <bruce.e.robertson@intel.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: <dirk.brandewie@gmail.com>, <linux-kernel@vger.kernel.org>,
        <dg77.kim@samsung.com>, <kyungmin.park@samsung.com>,
        <myungjoo.ham@samsung.com>, <Jason.Wortham@maxim-ic.com>
Subject: Re: [PATCH 4/5] max17042: Fix value scaling for VCELL and avgVCELL
References: <1327425968-21195-1-git-send-email-dirk.brandewie@gmail.com>
	<1327425968-21195-5-git-send-email-dirk.brandewie@gmail.com>
	<20120313181918.GA15964@oksana.dev.rtsoft.ru>
Date: Tue, 13 Mar 2012 14:00:13 -0700
In-Reply-To: <20120313181918.GA15964@oksana.dev.rtsoft.ru> (Anton Vorontsov's
	message of "Tue, 13 Mar 2012 22:19:18 +0400")
Message-ID: <m3pqcg5i8y.fsf@intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anton Vorontsov <cbouatmailru@gmail.com> writes:

> On Tue, Jan 24, 2012 at 09:26:07AM -0800, dirk.brandewie@gmail.com wrote:
>> From: Bruce Robertson <bruce.e.robertson@intel.com>
>> 
>> The bottom three bits of the register are don't care bits.  The LSB
>> value is 625 uV.  Adjust the returned values appropriately
>> 
>> Signed-off-by: Bruce Robertson <bruce.e.robertson@intel.com>
>> Signed-off-by: Dirk Brandewie <dirk.brandewie@gmail.com>
>> Acked-by: MyungJoo Ham <myungjoo.ham@samsung.com>
>
> I guess this was fixed long ago by the following patch:
>
> commit cf7a8c03db792894f436db5f3ffc44d947b9b068
> Author: MyungJoo Ham <myungjoo.ham@samsung.com>
> Date:   Wed Aug 17 10:18:34 2011 +0900
>
>     max17042_battery: Bugfix of incorrect voltage register value interpretation
>
>     The calculation had error in getting voltage values from
>     MAX17042 registers. The least bit denotes 78.125uV (625/8).

The multipliers I see in the patch are 83 making the voltages somewhat
high and the low 3 bits are not masked off. I'm probably misreading the code.

>
>     Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
>     Signed-off-by: Philip Rakity <prakity@marvell.com>
>     Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>     Signed-off-by: Anton Vorontsov <cbouatmailru@gmail.com>
>
> Thanks,

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751217Ab1JLOHe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 10:07:34 -0400
Received: from mga01.intel.com ([192.55.52.88]:24740 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750780Ab1JLOHd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 10:07:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,334,1315206000"; 
   d="scan'208";a="72736698"
Subject: Re: [PATCH] Code clean up for percpu_xxx() functions
From: "Alex,Shi" <alex.shi@intel.com>
To: Christoph Lameter <cl@gentwo.org>
Cc: "tj@kernel.org" <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "eric.dumazet@gmail.com" <eric.dumazet@gmail.com>,
        "Huang, Ying" <ying.huang@intel.com>
In-Reply-To: <1318382964.27949.782.camel@debian>
References: <1318237851.27949.190.camel@debian>
	 <alpine.DEB.2.00.1110101026080.16264@router.home>
	 <1318324774.27949.693.camel@debian>
	 <alpine.DEB.2.00.1110110910480.3388@router.home>
	 <1318382964.27949.782.camel@debian>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 12 Oct 2011 22:11:13 +0800
Message-ID: <1318428673.29699.13.camel@debian>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Is this a revised patch? I do not see a use of the __this_cpu_xx ops.
> 
> I just changed where you pointed as below at the patch line 146: 
> 
>  #ifdef CONFIG_SMP
>  #define __percpu_prefix                "%%"__stringify(__percpu_seg)":"
> -#define __my_cpu_offset                percpu_read(this_cpu_off)
> +#define __my_cpu_offset                __this_cpu_read(this_cpu_off)
> 
> I do not quite understand you here. Do you mean to change every possible
> this_cpu_xxx() to __this_cpu_xxx()? 

I thought again of this_cpu_xxx function, yes, some of them are better
to be replaced by __this_cpu__xxx if preemption is safe on the scenario.
But this change is better to be done in another patch. I did not
finished all changed function check today.  May try again in next week.
What's you pinion of this? 




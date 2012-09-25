Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756027Ab2IYMA6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 08:00:58 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:37639 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755274Ab2IYMA4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 08:00:56 -0400
X-IronPort-AV: E=Sophos;i="4.80,482,1344182400"; 
   d="scan'208";a="5914177"
Message-ID: <50619D5B.1040101@cn.fujitsu.com>
Date: Tue, 25 Sep 2012 20:02:35 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-numa@vger.kernel.org, wency@cn.fujitsu.com, mingo@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] Update sched_domains_numa_masks when new cpus are onlined.
References: <1347963128-25942-1-git-send-email-tangchen@cn.fujitsu.com>   <1348479536.11847.25.camel@twins> <50611946.9080601@cn.fujitsu.com>  <1348569232.3881.1.camel@twins> <5061996E.8070301@cn.fujitsu.com> <1348573806.3881.35.camel@twins>
In-Reply-To: <1348573806.3881.35.camel@twins>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/25 20:01:09,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/25 20:01:09,
	Serialize complete at 2012/09/25 20:01:09
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter~

I will make a v2 patch-set following your comments
and resent it soon. :)

Thanks. :)

On 09/25/2012 07:50 PM, Peter Zijlstra wrote:
> On Tue, 2012-09-25 at 19:45 +0800, Tang Chen wrote:
>
>
>> Let's have an example here.
>>
>> sched_init_numa()
>> {
>> 	...
>> 	// A loop set sched_domains_numa_levels to level.-------------1
>>
>> 	// I set sched_domains_numa_levels to 0.
>> 	sched_domains_numa_levels = 0;--------------------------------2
>
> Ah, ok, so this 'idiot in a hurry' (aka. me) placed the hunk wrong and
> thought it was at the start of the function.
>
>> 	// A loop allocating memory for sched_domains_numa_masks[][]
>> 	for (i = 0; i<  level; i++) {
>> 		......
>> 		// Allocate memory for sched_domains_numa_masks[i]----3
>> 		......
>> 	}
>> 	......
>>
>> 	// I reset sched_domains_numa_levels to level.
>> 	sched_domains_numa_levels = level;----------------------------4
>> }
>
> Yes this makes sense, it might be best to have this as a separate patch.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>


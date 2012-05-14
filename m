Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753957Ab2ENBMj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2012 21:12:39 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:48798 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753227Ab2ENBMh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2012 21:12:37 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <4FB05B8F.8020408@jp.fujitsu.com>
Date: Mon, 14 May 2012 10:10:39 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>,
        Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Han Ying <yinghan@google.com>, Glauber Costa <glommer@parallels.com>,
        Tejun Heo <tj@kernel.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/6] add res_counter_uncharge_until()
References: <4FACDED0.3020400@jp.fujitsu.com> <4FACE01A.4040405@jp.fujitsu.com> <20120511141945.c487e94c.akpm@linux-foundation.org>
In-Reply-To: <20120511141945.c487e94c.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/05/12 6:19), Andrew Morton wrote:

> On Fri, 11 May 2012 18:47:06 +0900
> KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> 
>> From: Frederic Weisbecker <fweisbec@gmail.com>
>>
>> At killing res_counter which is a child of other counter,
>> we need to do
>> 	res_counter_uncharge(child, xxx)
>> 	res_counter_charge(parent, xxx)
>>
>> This is not atomic and wasting cpu. This patch adds
>> res_counter_uncharge_until(). This function's uncharge propagates
>> to ancestors until specified res_counter.
>>
>> 	res_counter_uncharge_until(child, parent, xxx)
>>
>> Now, ops is atomic and efficient.
>>
>> Changelog since v2
>>  - removed unnecessary lines.
>>  - Fixed 'From' , this patch comes from his series. Please signed-off-by if good.
>>
>> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> Frederic's Signed-off-by: is unavaliable?
> 

I didn't add his Signed-off because I modified his orignal patch a little...
I dropped res_counter_charge_until() because it's not used in this series,
I have no justification for adding it.
The idea of res_counter_uncharge_until() is from his patch.

Thanks,
-Kame



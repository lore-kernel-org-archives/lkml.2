Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932760Ab2EOAEj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 20:04:39 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:43190 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757855Ab2EOAEh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 20:04:37 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <4FB19D14.7080208@jp.fujitsu.com>
Date: Tue, 15 May 2012 09:02:28 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>,
        Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Han Ying <yinghan@google.com>, Glauber Costa <glommer@parallels.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 6/6] remove __must_check for res_counter_charge_nofail()
References: <4FACDED0.3020400@jp.fujitsu.com> <4FACE184.6020307@jp.fujitsu.com> <20120514200925.GH2366@google.com>
In-Reply-To: <20120514200925.GH2366@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/05/15 5:09), Tejun Heo wrote:

> On Fri, May 11, 2012 at 06:53:08PM +0900, KAMEZAWA Hiroyuki wrote:
>> I picked this up from Costa's slub memcg series. For fixing added warning
>> by patch 4.
>> ==
>> From: Glauber Costa <glommer@parallels.com>
>> Subject: [PATCH 6/6] remove __must_check for res_counter_charge_nofail()
>>
>> Since we will succeed with the allocation no matter what, there
>> isn't the need to use __must_check with it. It can very well
>> be optional.
>>
>> Signed-off-by: Glauber Costa <glommer@parallels.com>
>> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> For 3-6,
> 
>  Reviewed-by: Tejun Heo <tj@kernel.org>
> 
> Thanks a lot for doing this.  This doesn't solve all the failure paths
> tho.  ie. what about -EINTR failures from lock contention?
> pre_destroy() would probably need delay and retry logic with
> WARN_ON_ONCE() on !-EINTR failures.
> 


Yes, I'll do more work. I tend to split series, sorry.

Thanks,
-Kame


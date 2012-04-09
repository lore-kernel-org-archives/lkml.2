Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756789Ab2DIIn5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 04:43:57 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:56520 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755694Ab2DIIn4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 04:43:56 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux-mm@kvack.org, mgorman@suse.de, dhillf@gmail.com, aarcange@redhat.com,
        mhocko@suse.cz, akpm@linux-foundation.org, hannes@cmpxchg.org,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH -V5 07/14] memcg: Add HugeTLB extension
In-Reply-To: <4F827BF9.2090205@jp.fujitsu.com>
References: <1333738260-1329-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1333738260-1329-8-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <4F827BF9.2090205@jp.fujitsu.com>User-Agent: Notmuch/0.11.1+346~g13d19c3 (http://notmuchmail.org) Emacs/23.3.1 (x86_64-pc-linux-gnu)
Date: Mon, 09 Apr 2012 14:13:45 +0530
Message-ID: <87zkalcn26.fsf@skywalker.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
x-cbid: 12040822-7014-0000-0000-000000DC98C0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> writes:

> (2012/04/07 3:50), Aneesh Kumar K.V wrote:
>
>> From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
>> 
>> This patch implements a memcg extension that allows us to control HugeTLB
>> allocations via memory controller. The extension allows to limit the
>> HugeTLB usage per control group and enforces the controller limit during
>> page fault. Since HugeTLB doesn't support page reclaim, enforcing the limit
>> at page fault time implies that, the application will get SIGBUS signal if it
>> tries to access HugeTLB pages beyond its limit. This requires the application
>> to know beforehand how much HugeTLB pages it would require for its use.
>> 
>> The charge/uncharge calls will be added to HugeTLB code in later patch.
>> 
>> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
>
>
> Hmm, seems ok to me. please explain 'this patch doesn't include updates
> for memcg destroying, it will be in patch 12/14' or some...
>
> Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>
>
> BTW, you don't put res_counter for hugeltb under CONFIG_MEM_RES_CTLR_HUGETLB...
> do you think we need the config ?


That results in more #ifdef CONFIG_MEM_RES_CTLR_HUGETLB in the
memcg code (mem_cgroup_create/mem_cgroup_read/write etc). I was not
sure we want to do that. Let me know if you think we really need to do this.


-aneesh


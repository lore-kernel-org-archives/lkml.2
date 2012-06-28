Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751187Ab2F1EGg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 00:06:36 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:42584 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744Ab2F1EGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 00:06:35 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <4FEBD7C0.7090906@jp.fujitsu.com>
Date: Thu, 28 Jun 2012 13:04:16 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: David Rientjes <rientjes@google.com>, Michal Hocko <mhocko@suse.cz>,
        Zhouping Liu <zliu@redhat.com>, linux-mm@kvack.org,
        Li Zefan <lizefan@huawei.com>, CAI Qian <caiqian@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: memcg: cat: memory.memsw.* : Operation not supported
References: <2a1a74bf-fbb5-4a6e-b958-44fff8debff2@zmail13.collab.prod.int.phx2.redhat.com> <34bb8049-8007-496c-8ffb-11118c587124@zmail13.collab.prod.int.phx2.redhat.com> <20120627154827.GA4420@tiehlicka.suse.cz> <alpine.DEB.2.00.1206271256120.22162@chino.kir.corp.google.com> <20120627200926.GR15811@google.com> <alpine.DEB.2.00.1206271316070.22162@chino.kir.corp.google.com> <20120627202430.GS15811@google.com>
In-Reply-To: <20120627202430.GS15811@google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/06/28 5:24), Tejun Heo wrote:
> Hello,
>
> On Wed, Jun 27, 2012 at 01:21:27PM -0700, David Rientjes wrote:
>> Well it also has a prerequisite that memcg doesn't have: CONFIG_SWAP, so
>
> Right.
>
>> even if CONFIG_CGROUP_MEM_RES_CTLR_SWAP is folded into
>> CONFIG_CGROUP_MEM_RES_CTLR, then these should still depend on CONFIG_SWAP
>> since configuring them would imply there is some limit to be enforced.
>>
>> But to answer your question:
>>
>>     text	   data	    bss	    dec	    hex	filename
>>    25777	   3644	   4128	  33549	   830d	memcontrol.o.swap_disabled
>>    27294	   4476	   4128	  35898	   8c3a	memcontrol.o.swap_enabled
>
> I still wish it's folded into CONFIG_MEMCG and conditionalized just on
> CONFIG_SWAP tho.
>

In old days, memsw controller was not very stable. So, we devided the config.
And, it makes size of memory for swap-device double (adds 2bytes per swapent.)
That is the problem.

>> Is it really too painful to not create these files when
>> CONFIG_CGROUP_MEM_RES_CTLR_SWAP is disabled?  If so, can we at least allow
>> them to be opened but return -EINVAL if memory.memsw.limit_in_bytes is
>> written?
>
> Not at all, that was the first version anyway, which (IIRC) KAME
> didn't like and suggested always creating those files.  KAME, what do
> you think?
>

IIRC...at that time, we made decision, cgroup has no feature to
'create files dynamically'. Then, we made it in static, decision was done
at compile time and ignores "do_swap_account".

Now, IIUC, we have the feature. So, it's may be a time to create the file
with regard to "do_swap_account", making decision at boot time.


Thanks,
-Kame




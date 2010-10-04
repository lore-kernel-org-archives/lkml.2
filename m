Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756215Ab0JDRfX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 13:35:23 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:39456 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755486Ab0JDRfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 13:35:22 -0400
Message-ID: <4CAA104C.3000708@linux.vnet.ibm.com>
Date: Mon, 04 Oct 2010 23:05:08 +0530
From: Ciju Rajan K <ciju@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Greg Thelen <gthelen@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, containers@lists.osdl.org,
        Andrea Righi <arighi@develer.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [PATCH 03/10] memcg: create extensible page stat update routines
References: <1286175485-30643-1-git-send-email-gthelen@google.com> <1286175485-30643-4-git-send-email-gthelen@google.com> <4CA9DB3E.6020106@linux.vnet.ibm.com> <xr93y6ae2cb1.fsf@ninji.mtv.corp.google.com>
In-Reply-To: <xr93y6ae2cb1.fsf@ninji.mtv.corp.google.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg Thelen wrote:
> Ciju Rajan K <ciju@linux.vnet.ibm.com> writes:
>
>   
>> Greg Thelen wrote:
>>     
>>> Replace usage of the mem_cgroup_update_file_mapped() memcg
>>> statistic update routine with two new routines:
>>> * mem_cgroup_inc_page_stat()
>>> * mem_cgroup_dec_page_stat()
>>>
>>> As before, only the file_mapped statistic is managed.  However,
>>> these more general interfaces allow for new statistics to be
>>> more easily added.  New statistics are added with memcg dirty
>>> page accounting.
>>>
>>>
>>>
>>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>>> index 512cb12..f4259f4 100644
>>> --- a/mm/memcontrol.c
>>> +++ b/mm/memcontrol.c
>>> @@ -1592,7 +1592,9 @@ bool mem_cgroup_handle_oom(struct mem_cgroup *mem, gfp_t mask)
>>>   * possibility of race condition. If there is, we take a lock.
>>>   */
>>>
>>>   -static void mem_cgroup_update_file_stat(struct page *page, int idx, int
>>> val)
>>>   
>>>       
>> Not seeing this function in mmotm 28/09. So not able to apply this patch.
>> Am I missing anything?
>>     
>
> How are you getting mmotm?
>
> I see the mem_cgroup_update_file_stat() routine added in mmotm
> (stamp-2010-09-28-16-13) using patch file:
>   http://userweb.kernel.org/~akpm/mmotm/broken-out/memcg-generic-filestat-update-interface.patch
>   
Sorry for the noise Greg. It was a mistake at my end. Corrected now.
Thanks!
>   Author: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>   Date:   Tue Sep 28 21:48:19 2010 -0700
>   
>       This patch extracts the core logic from mem_cgroup_update_file_mapped() as
>       mem_cgroup_update_file_stat() and adds a wrapper.
>   
>       As a planned future update, memory cgroup has to count dirty pages to
>       implement dirty_ratio/limit.  And more, the number of dirty pages is
>       required to kick flusher thread to start writeback.  (Now, no kick.)
>   
>       This patch is preparation for it and makes other statistics implementation
>       clearer.  Just a clean up.
>   
>       Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>       Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
>       Reviewed-by: Greg Thelen <gthelen@google.com>
>       Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
>       Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>
> If you are using the zen mmotm repository,
> git://zen-kernel.org/kernel/mmotm.git, the commit id of
> memcg-generic-filestat-update-interface.patch is
> 616960dc0cb0172a5e5adc9e2b83e668e1255b50.
>
>   
>>> +void mem_cgroup_update_page_stat(struct page *page,
>>> +				 enum mem_cgroup_write_page_stat_item idx,
>>> +				 int val)
>>>  {
>>>  	struct mem_cgroup *mem;
>>>
>>>   
>>>       


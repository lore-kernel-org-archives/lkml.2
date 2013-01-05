Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754835Ab3AEHif (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2013 02:38:35 -0500
Received: from mail-ie0-f182.google.com ([209.85.223.182]:37292 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754649Ab3AEHid (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2013 02:38:33 -0500
MIME-Version: 1.0
In-Reply-To: <50DCF00B.5040100@jp.fujitsu.com>
References: <1356455919-14445-1-git-send-email-handai.szj@taobao.com>
	<1356456447-14740-1-git-send-email-handai.szj@taobao.com>
	<50DCF00B.5040100@jp.fujitsu.com>
Date: Sat, 5 Jan 2013 15:38:32 +0800
Message-ID: <CAFj3OHW2E_U9B0x0iNMQHkDXLLyLkF3Bz-KUDto3BcKHi6374g@mail.gmail.com>
Subject: Re: [PATCH V3 6/8] memcg: Don't account root_mem_cgroup page statistics
From: Sha Zhengju <handai.szj@gmail.com>
To: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org,
        mhocko@suse.cz, akpm@linux-foundation.org, gthelen@google.com,
        fengguang.wu@intel.com, glommer@parallels.com,
        Sha Zhengju <handai.szj@taobao.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 28, 2012 at 9:04 AM, Kamezawa Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> (2012/12/26 2:27), Sha Zhengju wrote:
>> From: Sha Zhengju <handai.szj@taobao.com>
>>
>> If memcg is enabled and no non-root memcg exists, all allocated pages
>> belongs to root_mem_cgroup and go through root memcg statistics routines
>> which brings some overheads. So for the sake of performance, we can give
>> up accounting stats of root memcg for MEM_CGROUP_STAT_FILE_MAPPED/FILE_DIRTY
>> /WRITEBACK and instead we pay special attention while showing root
>> memcg numbers in memcg_stat_show(): as we don't account root memcg stats
>> anymore, the root_mem_cgroup->stat numbers are actually 0. But because of
>> hierachy, figures of root_mem_cgroup may just represent numbers of pages
>> used by its own tasks(not belonging to any other child cgroup). So here we
>> fake these root numbers by using stats of global state and all other memcg.
>> That is for root memcg:
>>       nr(MEM_CGROUP_STAT_FILE_MAPPED) = global_page_state(NR_FILE_MAPPED) -
>>                                sum_of_all_memcg(MEM_CGROUP_STAT_FILE_MAPPED);
>> Dirty/Writeback pages accounting are in the similar way.
>>
>> Signed-off-by: Sha Zhengju <handai.szj@taobao.com>
>
> isn't it better to use mem_cgroup_is_root() call rather than
> direct comparison (memcg == root_mem_cgroup) ?
>

Okay, it's better to use the wrapper.

> Anyway, Ack to this approach.
>

Thanks for reviewing!


Regards,
Sha

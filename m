Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965214Ab2KVT3D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 14:29:03 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:58755 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965183Ab2KVT27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 14:28:59 -0500
X-Greylist: delayed 3611 seconds by postgrey-1.27 at vger.kernel.org; Thu, 22 Nov 2012 14:28:59 EST
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.8.4
Message-ID: <50AD713F.9030909@jp.fujitsu.com>
Date: Thu, 22 Nov 2012 09:26:39 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: azurIt <azurit@pobox.sk>
CC: linux-kernel@vger.kernel.org, linux-mm <linux-mm@kvack.org>
Subject: Re: memory-cgroup bug
References: <20121121200207.01068046@pobox.sk>
In-Reply-To: <20121121200207.01068046@pobox.sk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/11/22 4:02), azurIt wrote:
> Hi,
>
> i'm using memory cgroup for limiting our users and having a really strange problem when a cgroup gets out of its memory limit. It's very strange because it happens only sometimes (about once per week on random user), out of memory is usually handled ok. This happens when problem occures:
>   - no new processes can be started for this cgroup
>   - current processes are freezed and taking 100% of CPU
>   - when i try to 'strace' any of current processes, the whole strace freezes until process is killed (strace cannot be terminated by CTRL-c)
>   - problem can be resolved by raising memory limit for cgroup or killing of few processes inside cgroup so some memory is freed
>
> I also garbbed the content of /proc/<pid>/stack of freezed process:
> [<ffffffff8110a9c1>] mem_cgroup_handle_oom+0x241/0x3b0
> [<ffffffff8110b5ab>] T.1146+0x5ab/0x5c0
> [<ffffffff8110ba56>] mem_cgroup_charge_common+0x56/0xa0
> [<ffffffff8110bae5>] mem_cgroup_newpage_charge+0x45/0x50
> [<ffffffff810ec54e>] do_wp_page+0x14e/0x800
> [<ffffffff810eda34>] handle_pte_fault+0x264/0x940
> [<ffffffff810ee248>] handle_mm_fault+0x138/0x260
> [<ffffffff810270ed>] do_page_fault+0x13d/0x460
> [<ffffffff815b53ff>] page_fault+0x1f/0x30
> [<ffffffffffffffff>] 0xffffffffffffffff
>
> I'm currently using kernel 3.2.34 but i'm having this problem since 2.6.32.
>
> Any ideas? Thnx.
>

Under OOM in memcg, only one process is allowed to work. Because processes tends to use up
CPU at memory shortage. other processes are freezed.


Then, the problem here is the one process which uses CPU. IIUC, 'freezed' threads are
in sleep and never use CPU. It's expected oom-killer or memory-reclaim can solve the probelm.

What is your memcg's

  memory.oom_control

value ?

and process's oom_adj values ? (/proc/<pid>/oom_adj, /proc/<pid>/oom_score_adj)

Thanks,
-Kame






> azurIt
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



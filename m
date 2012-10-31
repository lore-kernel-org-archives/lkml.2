Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935562Ab2JaNNg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 09:13:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8032 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932673Ab2JaNNe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 09:13:34 -0400
Message-ID: <50912478.2040403@redhat.com>
Date: Wed, 31 Oct 2012 21:15:36 +0800
From: Zhouping Liu <zliu@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121016 Thunderbird/16.0.1
MIME-Version: 1.0
To: Hugh Dickins <hughd@google.com>
CC: Johannes Weiner <hannes@cmpxchg.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rik van Riel <riel@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
        Mel Gorman <mgorman@suse.de>, Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Ingo Molnar <mingo@kernel.org>, CAI Qian <caiqian@redhat.com>
Subject: Re: [PATCH 00/31] numa/core patches
References: <20121025121617.617683848@chello.nl> <508A52E1.8020203@redhat.com> <1351242480.12171.48.camel@twins> <20121028175615.GC29827@cmpxchg.org> <508F73C5.7050409@redhat.com> <20121031004838.GA1657@cmpxchg.org> <alpine.LNX.2.00.1210302350140.5084@eggly.anvils>
In-Reply-To: <alpine.LNX.2.00.1210302350140.5084@eggly.anvils>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/31/2012 03:26 PM, Hugh Dickins wrote:
> On Tue, 30 Oct 2012, Johannes Weiner wrote:
>
> [88099.923724] ------------[ cut here ]------------
> [88099.924036] kernel BUG at mm/memcontrol.c:1134!
> [88099.924036] invalid opcode: 0000 [#1] SMP
> [88099.924036] Modules linked in: lockd sunrpc kvm_amd kvm
> amd64_edac_mod edac_core ses enclosure serio_raw bnx2 pcspkr shpchp
> joydev i2c_piix4 edac_mce_amd k8temp dcdbas ata_generic pata_acpi
> megaraid_sas pata_serverworks usb_storage radeon i2c_algo_bit
> drm_kms_helper ttm drm i2c_core
> [88099.924036] CPU 7
> [88099.924036] Pid: 3441, comm: stress Not tainted 3.7.0-rc2Jons+ #3
> Dell Inc. PowerEdge 6950/0WN213
> [88099.924036] RIP: 0010:[<ffffffff81188e97>] [<ffffffff81188e97>]
> mem_cgroup_update_lru_size+0x27/0x30
>> Thanks a lot for your testing efforts, I really appreciate it.
>>
>> I'm looking into it, but I don't expect power to get back for several
>> days where I live, so it's hard to reproduce it locally.
>>
>> But that looks like an LRU accounting imbalance that I wasn't able to
>> tie to this patch yet.  Do you see weird numbers for the lru counters
>> in /proc/vmstat even without this memory cgroup patch?  Ccing Hugh as
>> well.
> Sorry, I didn't get very far with it tonight.
>
> Almost certain to be a page which was added to lru while it looked like
> a 4k page, but taken off lru as a 2M page: we are taking a 2M page off
> lru here, it's likely to be the page in question, but not necessarily.
>
> There's quite a few put_page()s in do_huge_pmd_numa_page(), and it
> would help if we could focus on the one which is giving the trouble,
> but I don't know which that is.  Zhouping, if you can, please would
> you do an "objdump -ld vmlinux >bigfile" of your kernel, then extract
> from bigfile just the lines from "<do_huge_pmd_numa_page>:" to whatever
> is the next function, and post or mail privately just that disassembly.
> That should be good to identify which of the put_page()s is involved.

Hugh, I didn't find the next function, as I can't find any words that 
matched "do_huge_pmd_numa_page".
is there any other methods? also I tried to use kdump to dump vmcore 
file, but unluckily kdump didn't
work well, if you think it useful to dump vmcore file, I can try it 
again and provide more info.

Thanks,
Zhouping

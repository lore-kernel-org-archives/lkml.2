Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754101Ab1AJOiE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 09:38:04 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:44434 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752203Ab1AJOiB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 09:38:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=m6GKqCd3/zKR0vOwvqoiD3212DS0mnWFkFpBZmUpbLCVxVRhn+1oMzHQx7e2IEmH9Y
         kN6I7bB4Imhz2NJCVygb+pmK1g3sqWFfvvIabPwCJODtwyc+wCIsbQC1Qehv7IfJX0z1
         eSjFN+WEYibG5Oga2U4wrK3oGOVLZIGw9TaVA=
Message-ID: <4D2B19C5.5060709@gmail.com>
Date: Mon, 10 Jan 2011 15:37:57 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.13) Gecko/20101206 SUSE/3.1.7 Thunderbird/3.1.7
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: akpm@linux-foundation.org, mm-commits@vger.kernel.org, linux-mm@kvack.org,
        aarcange@redhat.com, kvm@vger.kernel.org
Subject: qemu-kvm defunct due to THP [was: mmotm 2011-01-06-15-41 uploaded]
References: <201101070014.p070Egpo023959@imap1.linux-foundation.org>
In-Reply-To: <201101070014.p070Egpo023959@imap1.linux-foundation.org>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/07/2011 12:41 AM, akpm@linux-foundation.org wrote:
> The mm-of-the-moment snapshot 2011-01-06-15-41 has been uploaded to

Hi, something of the following breaks qemu-kvm:

> thp-add-pmd-mangling-generic-functions.patch
> thp-add-pmd-mangling-generic-functions-fix-pgtableh-build-for-um.patch
> thp-add-pmd-mangling-functions-to-x86.patch
> thp-bail-out-gup_fast-on-splitting-pmd.patch
> thp-pte-alloc-trans-splitting.patch
> thp-pte-alloc-trans-splitting-fix.patch
> thp-pte-alloc-trans-splitting-fix-checkpatch-fixes.patch
> thp-add-pmd-mmu_notifier-helpers.patch
> thp-clear-page-compound.patch
> thp-add-pmd_huge_pte-to-mm_struct.patch
> thp-split_huge_page_mm-vma.patch
> thp-split_huge_page-paging.patch
> thp-clear_copy_huge_page.patch
> thp-kvm-mmu-transparent-hugepage-support.patch
> thp-_gfp_no_kswapd.patch
> thp-dont-alloc-harder-for-gfp-nomemalloc-even-if-nowait.patch
> thp-transparent-hugepage-core.patch
> thp-split_huge_page-anon_vma-ordering-dependency.patch
> thp-verify-pmd_trans_huge-isnt-leaking.patch
> thp-madvisemadv_hugepage.patch
> thp-add-pagetranscompound.patch
> thp-pmd_trans_huge-migrate-bugcheck.patch
> thp-memcg-compound.patch
> thp-transhuge-memcg-commit-tail-pages-at-charge.patch
> thp-memcg-huge-memory.patch
> thp-transparent-hugepage-vmstat.patch
> thp-khugepaged.patch
> thp-khugepaged-vma-merge.patch
> thp-skip-transhuge-pages-in-ksm-for-now.patch
> thp-remove-pg_buddy.patch
> thp-add-x86-32bit-support.patch
> thp-mincore-transparent-hugepage-support.patch
> thp-add-pmd_modify.patch
> thp-mprotect-pass-vma-down-to-page-table-walkers.patch
> thp-mprotect-transparent-huge-page-support.patch
> thp-set-recommended-min-free-kbytes.patch
> thp-enable-direct-defrag.patch
> thp-add-numa-awareness-to-hugepage-allocations.patch
> thp-allocate-memory-in-khugepaged-outside-of-mmap_sem-write-mode.patch
> thp-allocate-memory-in-khugepaged-outside-of-mmap_sem-write-mode-fix.patch
> thp-transparent-hugepage-config-choice.patch
> thp-select-config_compaction-if-transparent_hugepage-enabled.patch
> thp-transhuge-isolate_migratepages.patch
> thp-avoid-breaking-huge-pmd-invariants-in-case-of-vma_adjust-failures.patch
> thp-dont-allow-transparent-hugepage-support-without-pse.patch
> thp-mmu_notifier_test_young.patch
> thp-freeze-khugepaged-and-ksmd.patch
> thp-use-compaction-in-kswapd-for-gfp_atomic-order-0.patch
> thp-use-compaction-for-all-allocation-orders.patch
> thp-disable-transparent-hugepages-by-default-on-small-systems.patch
> thp-fix-anon-memory-statistics-with-transparent-hugepages.patch
> thp-scale-nr_rotated-to-balance-memory-pressure.patch
> thp-transparent-hugepage-sysfs-meminfo.patch
> thp-add-debug-checks-for-mapcount-related-invariants.patch
> thp-fix-memory-failure-hugetlbfs-vs-thp-collision.patch
> thp-compound_trans_order.patch
> thp-compound_trans_order-fix.patch
> thp-mm-define-madv_nohugepage.patch
> thp-madvisemadv_nohugepage.patch
> thp-khugepaged-make-khugepaged-aware-of-madvise.patch
> thp-khugepaged-make-khugepaged-aware-of-madvise-fix.patch

The series is unbisectable, build errors occur. It needs to be fixed too.

The kernel complains:
BUG: Bad page state in process qemu-kvm  pfn:1bec05
page:ffffea00061ba118 count:1883770 mapcount:0 mapping:          (null)
index:0x0
page flags: 0x8000000000008000(tail)
Pid: 4221, comm: qemu-kvm Not tainted 2.6.37-mm1_64 #2
Call Trace:
 [<ffffffff810cefcb>] ? bad_page+0xab/0x120
 [<ffffffff810cf4a1>] ? free_pages_prepare+0xa1/0xd0
 [<ffffffff810cfebd>] ? __free_pages_ok+0x2d/0xc0
 [<ffffffff810cff66>] ? free_compound_page+0x16/0x20
 [<ffffffff810d44f7>] ? __put_compound_page+0x17/0x20
 [<ffffffff810d4578>] ? put_compound_page+0x48/0x170
 [<ffffffff810d49ae>] ? release_pages+0x24e/0x260
 [<ffffffff810f757d>] ? free_pages_and_swap_cache+0x8d/0xb0
 [<ffffffff81108b30>] ? zap_huge_pmd+0x130/0x1b0
 [<ffffffff810e9877>] ? unmap_vmas+0x877/0xbb0
 [<ffffffff810ec14a>] ? exit_mmap+0xda/0x170
 [<ffffffff810697fa>] ? mmput+0x4a/0x110
 [<ffffffff8106e11b>] ? exit_mm+0x12b/0x170
 [<ffffffff81070299>] ? do_exit+0x6d9/0x820
 [<ffffffff810973cc>] ? futex_wake+0x10c/0x130
 [<ffffffff81070423>] ? do_group_exit+0x43/0xb0
 [<ffffffff8107c59a>] ? get_signal_to_deliver+0x1ba/0x390
 [<ffffffff8103028f>] ? do_notify_resume+0xef/0x850
 [<ffffffff8107aae3>] ? dequeue_signal+0x93/0x160
 [<ffffffff8107add7>] ? sys_rt_sigtimedwait+0x227/0x230
 [<ffffffff81099cce>] ? sys_futex+0x7e/0x150
 [<ffffffff8103101b>] ? int_signal+0x12/0x17

regards,
-- 
js

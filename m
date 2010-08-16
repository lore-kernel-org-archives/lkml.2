Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751987Ab0HPQyf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 12:54:35 -0400
Received: from bluebox.CS.Princeton.EDU ([128.112.136.38]:52635 "EHLO
	bluebox.CS.Princeton.EDU" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929Ab0HPQyd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 12:54:33 -0400
X-Greylist: delayed 352 seconds by postgrey-1.27 at vger.kernel.org; Mon, 16 Aug 2010 12:54:33 EDT
From: "=?utf-8?Q?=22S.=C3=87a=C4=9Flar_Onur=22?=" <caglar@CS.Princeton.EDU>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Subject: 2.6.27.52-rc2
Date: Mon, 16 Aug 2010 12:38:56 -0400
Message-Id: <A3F5ED84-2D61-4527-B914-3B66F645FA0E@cs.princeton.edu>
Cc: gregkh@suse.de
To: linux-kernel@vger.kernel.org, stable@kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
Mime-Version: 1.0 (Apple Message framework v1081)
X-Mailer: Apple Mail (2.1081)
X-Proofpoint-Virus-Version: vendor=nai engine=5400 definitions=6075 signatures=637934
X-Proofpoint-Spam-Reason: safe
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm started to get following with 2.6.27.52-rc2 [1]. Just to note, this kernel is linux-vserver enabled but same patchset works fine with 2.6.27.51

BUG: sleeping function called from invalid context at mm/rmap.c:90
in_atomic():1, irqs_disabled():0
Pid: 1, comm: swapper Not tainted 2.6.27.51-22.planetlab #1
 [<c0417c16>] __might_sleep+0x97/0x9e
 [<c0468576>] anon_vma_prepare+0x1d/0xa8
 [<c0464e32>] expand_stack+0x12/0x87
 [<c04624c7>] handle_mm_fault+0x193/0x86c
 [<c0476343>] ? do_sync_read+0xab/0xe9
 [<c0461781>] ? follow_page+0x53/0x1e8
 [<c0462da5>] get_user_pages+0x205/0x2f4
 [<c04797af>] get_arg_page+0x2d/0x80
 [<c04d8d95>] ? strnlen_user+0x2b/0x49
 [<c04798c7>] copy_strings+0xc5/0x160
 [<c047997e>] copy_strings_kernel+0x1c/0x2b
 [<c047ac97>] do_execve+0xf2/0x1d3
 [<c0402133>] sys_execve+0x29/0x51
 [<c040393f>] carry_on+0xd/0x11
 [<c04700d8>] ? shmem_zero_setup+0x32/0x48
 [<c040643f>] ? kernel_execve+0x17/0x1c
 [<c04011fe>] ? run_init_process+0x17/0x19
 [<c040126a>] ? init_post+0x6a/0xd0
 [<c0404513>] ? kernel_thread_helper+0x7/0x10
 =======================
…
BUG: sleeping function called from invalid context at mm/rmap.c:90
in_atomic():1, irqs_disabled():0
Pid: 362, comm: init Not tainted 2.6.27.51-22.planetlab #1
 [<c0417c16>] __might_sleep+0x97/0x9e
 [<c0468576>] anon_vma_prepare+0x1d/0xa8
 [<c0464e32>] expand_stack+0x12/0x87
 [<c04624c7>] handle_mm_fault+0x193/0x86c
 [<c0476343>] ? do_sync_read+0xab/0xe9
 [<c0461781>] ? follow_page+0x53/0x1e8
 [<c0462da5>] get_user_pages+0x205/0x2f4
 [<c04797af>] get_arg_page+0x2d/0x80
 [<c04d8d95>] ? strnlen_user+0x2b/0x49
 [<c04798c7>] copy_strings+0xc5/0x160
 [<c047997e>] copy_strings_kernel+0x1c/0x2b
 [<c047ac97>] do_execve+0xf2/0x1d3
 [<c0402133>] sys_execve+0x29/0x51
 [<c0403895>] sysenter_do_call+0x12/0x25
 [<c0610000>] ? i8042_probe+0x179/0x4f6
 =======================
…


[1] http://www.cs.princeton.edu/~caglar/dmesg-52-rc2

Best regards.
--
S.Çağlar Onur <caglar@cs.princeton.edu>


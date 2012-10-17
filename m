Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932243Ab2JQPdY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 11:33:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61881 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756321Ab2JQPdX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 11:33:23 -0400
Date: Wed, 17 Oct 2012 11:33:14 -0400
From: Dave Jones <davej@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, Fedora Kernel Team <kernel-team@fedoraproject.org>
Subject: Re: 3.6.0: WARNING: at arch/x86/kernel/apic/ipi.c:109
 default_send_IPI_mask_logical+0x97/0xc7()
Message-ID: <20121017153314.GA22138@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	linux-kernel@vger.kernel.org, x86@kernel.org,
	Fedora Kernel Team <kernel-team@fedoraproject.org>
References: <20121002112631.GB15862@charite.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121002112631.GB15862@charite.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 02, 2012 at 01:26:31PM +0200, Ralf Hildebrandt wrote:

 > WARNING: at arch/x86/kernel/apic/ipi.c:109 default_send_IPI_mask_logical+0x97/0xc7()
 > Hardware name: ProLiant DL360 G4
 > empty IPI mask
 > Modules linked in: nfnetlink_log nfnetlink ipv6 tg3 microcode rng_core psmouse hpwdt container thermal button processor i6300esb
 > Pid: 22582, comm: clamd Not tainted 3.6.0 #1
 > Call Trace:
 >  [<c1027f94>] warn_slowpath_common+0x67/0x8e
 >  [<c101beef>] ? default_send_IPI_mask_logical+0x97/0xc7
 >  [<c101beef>] ? default_send_IPI_mask_logical+0x97/0xc7
 >  [<c1028037>] warn_slowpath_fmt+0x2e/0x30
 >  [<c101beef>] default_send_IPI_mask_logical+0x97/0xc7
 >  [<c101aac4>] native_send_call_func_ipi+0x42/0x54
 >  [<c105c56a>] smp_call_function_many+0x160/0x1dd
 >  [<c1024fe7>] native_flush_tlb_others+0x26/0x28
 >  [<c1025218>] flush_tlb_page+0x49/0x73
 >  [<c109c420>] ptep_clear_flush+0x18/0x20
 >  [<c108fe26>] do_wp_page+0x1f4/0x72f
 >  [<c104ab0c>] ? __enqueue_entity+0x6b/0x73
 >  [<c10917c4>] handle_pte_fault+0x47a/0x8d8
 >  [<c105c7eb>] ? generic_smp_call_function_interrupt+0x6c/0x150
 >  [<c105c842>] ? generic_smp_call_function_interrupt+0xc3/0x150
 >  [<c10928e1>] handle_mm_fault+0x19c/0x211
 >  [<c1020fe5>] ? vmalloc_sync_all+0x5/0x5
 >  [<c10210d8>] do_page_fault+0xf3/0x3ab
 >  [<c105c842>] ? generic_smp_call_function_interrupt+0xc3/0x150
 >  [<c116a593>] ? radix_tree_lookup_slot+0xd/0xf
 >  [<c10793fd>] ? find_get_page+0x1b/0x70
 >  [<c1020fe5>] ? vmalloc_sync_all+0x5/0x5
 >  [<c129f7a3>] error_code+0x67/0x6c
 >  [<c107914e>] ? file_read_actor+0x25/0xb8
 >  [<c1088e4b>] shmem_file_aio_read+0xf1/0x2bb
 >  [<c10abb31>] do_sync_read+0x8f/0xbf
 >  [<c10abaa2>] ? do_sync_write+0xbf/0xbf
 >  [<c10ac450>] vfs_read+0x80/0x13e
 >  [<c10abaa2>] ? do_sync_write+0xbf/0xbf
 >  [<c10ac636>] sys_pread64+0x4e/0x7c
 >  [<c129fa17>] sysenter_do_call+0x12/0x26

We've had a lot of reports of this bug this last two weeks since we pushed out a 3.6 update.

https://bugzilla.redhat.com/show_bug.cgi?id=862560
https://bugzilla.redhat.com/show_bug.cgi?id=867174

All of them are on i686.

We had one report of something similar a while ago too..
https://bugzilla.redhat.com/show_bug.cgi?id=797687
against 3.2.6, so it's possibly an old bug that somehow
became even easier to trigger.

	Dave


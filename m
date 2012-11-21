Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754338Ab2KUNyp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 08:54:45 -0500
Received: from mail2.charite.de ([141.42.206.200]:50881 "EHLO mail2.charite.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752260Ab2KUNyo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 08:54:44 -0500
X-Greylist: delayed 442 seconds by postgrey-1.27 at vger.kernel.org; Wed, 21 Nov 2012 08:54:44 EST
Date: Wed, 21 Nov 2012 14:47:19 +0100
From: Ralf Hildebrandt <Ralf.Hildebrandt@charite.de>
To: linux-kernel@vger.kernel.org
Subject: WARNING: at arch/x86/kernel/apic/ipi.c:109
 default_send_IPI_mask_logical+0x97/0xc7()
Message-ID: <20121121134718.GZ11530@charite.de>
Mail-Followup-To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

from dmesg on a vanilla 3.6.7

# uname -a
Linux mail2.charite.de 3.6.7 #1 SMP Sun Nov 18 19:49:09 CET 2012 i686 GNU/Linux

Nov 19 10:54:16 mail2 kernel: [52464.940539] ------------[ cut here ]------------
Nov 19 10:54:16 mail2 kernel: [52464.940566] WARNING: at arch/x86/kernel/apic/ipi.c:109 default_send_IPI_mask_logical+0x97/0xc7()
Nov 19 10:54:16 mail2 kernel: [52464.940570] Hardware name: ProLiant DL360 G4
Nov 19 10:54:16 mail2 kernel: [52464.940573] empty IPI mask
Nov 19 10:54:16 mail2 kernel: [52464.940576] Modules linked in: nfnetlink_log nfnetlink ipv6 microcode psmouse container hpwdt tg3 thermal rng_core i6300esb button processor
Nov 19 10:54:16 mail2 kernel: [52464.940603] Pid: 27794, comm: clamd Not tainted 3.6.7 #1
Nov 19 10:54:16 mail2 kernel: [52464.940606] Call Trace:
Nov 19 10:54:16 mail2 kernel: [52464.940620]  [<c1027f84>] warn_slowpath_common+0x67/0x8e
Nov 19 10:54:16 mail2 kernel: [52464.940627]  [<c101beef>] ? default_send_IPI_mask_logical+0x97/0xc7
Nov 19 10:54:16 mail2 kernel: [52464.940631]  [<c101beef>] ? default_send_IPI_mask_logical+0x97/0xc7
Nov 19 10:54:16 mail2 kernel: [52464.940636]  [<c1028027>] warn_slowpath_fmt+0x2e/0x30
Nov 19 10:54:16 mail2 kernel: [52464.940641]  [<c101beef>] default_send_IPI_mask_logical+0x97/0xc7
Nov 19 10:54:16 mail2 kernel: [52464.940650]  [<c101aac4>] native_send_call_func_ipi+0x42/0x54
Nov 19 10:54:16 mail2 kernel: [52464.940657]  [<c105c5fa>] smp_call_function_many+0x160/0x1dd
Nov 19 10:54:16 mail2 kernel: [52464.940663]  [<c1024fe7>] native_flush_tlb_others+0x26/0x28
Nov 19 10:54:16 mail2 kernel: [52464.940667]  [<c1025087>] flush_tlb_mm_range+0x4f/0x18e
Nov 19 10:54:16 mail2 kernel: [52464.940676]  [<c108f706>] tlb_flush_mmu+0x7a/0x7c
Nov 19 10:54:16 mail2 kernel: [52464.940681]  [<c108f71a>] tlb_finish_mmu+0x12/0x33
Nov 19 10:54:16 mail2 kernel: [52464.940686]  [<c109473f>] unmap_region+0x88/0x9e
Nov 19 10:54:16 mail2 kernel: [52464.940691]  [<c1095bb9>] do_munmap+0x1bb/0x2aa
Nov 19 10:54:16 mail2 kernel: [52464.940696]  [<c1095cda>] vm_munmap+0x32/0x45
Nov 19 10:54:16 mail2 kernel: [52464.940700]  [<c10967e6>] sys_munmap+0xe/0x10
Nov 19 10:54:16 mail2 kernel: [52464.940710]  [<c129ff17>] sysenter_do_call+0x12/0x26
Nov 19 10:54:16 mail2 kernel: [52464.940713] ---[ end trace a5fffac357fb1c34 ]---

-- 
Ralf Hildebrandt                   Charite Universitätsmedizin Berlin
ralf.hildebrandt@charite.de        Campus Benjamin Franklin
http://www.charite.de              Hindenburgdamm 30, 12203 Berlin
Geschäftsbereich IT, Abt. Netzwerk fon: +49-30-450.570.155

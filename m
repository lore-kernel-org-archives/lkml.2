Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755727Ab0KZRYP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 12:24:15 -0500
Received: from smtp6-g21.free.fr ([212.27.42.6]:38174 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754740Ab0KZRYJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 12:24:09 -0500
Date: Fri, 26 Nov 2010 18:23:55 +0100
From: mat <castet.matthieu@free.fr>
To: Valdis.Kletnieks@vt.edu
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-next@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>,
        James Morris <jmorris@namei.org>,
        Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@muc.de>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
        Stephen Rothwell <sfr@canb.auug.org.au>, Dave Jones <davej@redhat.com>,
        Siarhei Liakh <sliakh.lkml@gmail.com>,
        Kees Cook <kees.cook@canonical.com>
Subject: Re: [PATCH 3/3 V13] RO/NX protection for loadable kernel
Message-ID: <20101126182355.62615dff@mat-laptop>
In-Reply-To: <24422.1290656467@localhost>
References: <4CE2F914.9070106@free.fr>
	<24422.1290656467@localhost>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/u4AfbfrTKD9Qh3gR_9SQMcY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--MP_/u4AfbfrTKD9Qh3gR_9SQMcY
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Le Wed, 24 Nov 2010 22:41:07 -0500,
Valdis.Kletnieks@vt.edu a =E9crit :

> On Tue, 16 Nov 2010 22:35:16 +0100, matthieu castet said:
>=20
> > This patch is a logical extension of the protection provided by
> > CONFIG_DEBUG_RODATA to LKMs. The protection is provided by splitting
> > module_core and module_init into three logical parts each and
> > setting appropriate page access permissions for each individual
> > section:
> >=20
> >  1. Code: RO+X
> >  2. RO data: RO+NX
> >  3. RW data: RW+NX
>=20
> This is incompatible with CONFIG_JUMP_LABEL:
>=20
> [  252.093624] BUG: unable to handle kernel paging request at
> ffffffffa0680764 [  252.094008] IP: [<ffffffff81225ee0>]
> generic_swap+0xa/0x1a [  252.094008] PGD 1a1e067 PUD 1a22063 PMD
> 1093ac067 PTE 8000000109786161 [  252.094008] Oops: 0003 [#1] PREEMPT
> SMP=20
>=20
> [  252.094008] Pid: 3740, comm: modprobe Not tainted
> 2.6.37-rc3-mmotm1123 #1 0X564R/Latitude E6500 [  252.094008] RIP:
> 0010:[<ffffffff81225ee0>]  [<ffffffff81225ee0>] generic_swap+0xa/0x1a
> [  252.094008] RSP: 0018:ffff88011a217d98  EFLAGS: 00010206
> [  252.094008] RAX: 00000000000000d9 RBX: 0000000000000030 RCX:
> 000000000000007c [  252.094008] RDX: 0000000000000017 RSI:
> ffffffffa0680794 RDI: ffffffffa0680764 [  252.094008] RBP:
> ffff88011a217d98 R08: 0000000000000000 R09: ffff88011a217d38
> [  252.094008] R10: 0000000000000000 R11: 000000000000013d R12:
> ffffffffa0680764 [  252.094008] R13: 0000000000000018 R14:
> 0000000000000018 R15: 0000000000000018 [  252.094008] FS:
> 00007f6ecb897720(0000) GS:ffff8800df100000(0000)
> knlGS:0000000000000000 [  252.094008] CS:  0010 DS: 0000 ES: 0000
> CR0: 000000008005003b [  252.094008] CR2: ffffffffa0680764 CR3:
> 000000011911e000 CR4: 00000000000406e0 [  252.094008] DR0:
> 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [  252.094008] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
> 0000000000000400 [  252.094008] Process modprobe (pid: 3740,
> threadinfo ffff88011a216000, task ffff88011861e300) [  252.094008]
> Stack: [  252.094008]  ffff88011a217e28 ffffffff81226007
> ffffffff81a31158 0000000000000000 [  252.094008]  0000000000000030
> 0000000000000048 ffffffff8105fa34 ffffffff81225ed6 [  252.094008]
> ffffffff00000018 ffffffff00000018 0000000000000018 00000030ffffffff
> [  252.094008] Call Trace: [  252.094008]  [<ffffffff81226007>]
> sort+0x117/0x1b0 [  252.094008]  [<ffffffff8105fa34>] ?
> jump_label_cmp+0x0/0x1b [  252.094008]  [<ffffffff81225ed6>] ?
> generic_swap+0x0/0x1a [  252.094008]  [<ffffffff8105faa6>]
> sort_jump_label_entries+0x2b/0x2d [  252.094008]
> [<ffffffff8105feda>] jump_label_module_notify+0x58/0x253
> [  252.094008]  [<ffffffff8155e816>] notifier_call_chain+0x54/0x81
> [  252.094008]  [<ffffffff8105d9b2>]
> __blocking_notifier_call_chain+0x5c/0x79 [  252.094008]
> [<ffffffff8105d9de>] blocking_notifier_call_chain+0xf/0x11
> [  252.094008]  [<ffffffff810778cc>] sys_init_module+0x76/0x1f5
> [  252.094008]  [<ffffffff8100277b>] system_call_fastpath+0x16/0x1b
> [  252.094008] Code: 05 ff c0 48 29 f7 48 39 f7 73 f6 48 89 3a c9 c3
> 90 90 90 8b 07 8b 16 55 89 17 48 89 e5 89 06 c9 c3 55 48 89 e5 8a 07
> 8a 0e ff ca <88> 0f 48 ff c7 88 06 48 ff c6 85 d2 7f ec c9 c3 55 89
> d0 48 89 [  252.094008] RIP  [<ffffffff81225ee0>]
> generic_swap+0xa/0x1a [  252.094008]  RSP <ffff88011a217d98>
> [  252.094008] CR2: ffffffffa0680764 [  252.094008] ---[ end trace
> f88479be6b01e4c4 ]---
>=20
>=20
> > +config DEBUG_SET_MODULE_RONX
> > +	bool "Set loadable kernel module data as NX and text as RO"
> > +	default n
> > +	depends on X86 && MODULES
>=20
> 	depends on X86 && MODULES && !JUMP_LABEL
could you try the attached patch ?

on module load, we sort the __jump_table section. So we should make it
writable.


Matthieu

--MP_/u4AfbfrTKD9Qh3gR_9SQMcY
Content-Type: text/x-patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=jmp_label.diff

diff --git a/arch/x86/include/asm/jump_label.h b/arch/x86/include/asm/jump_label.h
index f52d42e..574dbc2 100644
--- a/arch/x86/include/asm/jump_label.h
+++ b/arch/x86/include/asm/jump_label.h
@@ -14,7 +14,7 @@
 	do {							\
 		asm goto("1:"					\
 			JUMP_LABEL_INITIAL_NOP			\
-			".pushsection __jump_table,  \"a\" \n\t"\
+			".pushsection __jump_table,  \"aw\" \n\t"\
 			_ASM_PTR "1b, %l[" #label "], %c0 \n\t" \
 			".popsection \n\t"			\
 			: :  "i" (key) :  : label);		\

--MP_/u4AfbfrTKD9Qh3gR_9SQMcY--

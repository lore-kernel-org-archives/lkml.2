Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753529Ab1GHM6e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 08:58:34 -0400
Received: from hera.kernel.org ([140.211.167.34]:32925 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751526Ab1GHM6b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 08:58:31 -0400
Date: Fri, 8 Jul 2011 12:58:16 GMT
From: tip-bot for Naga Chumbalkar <nagananda.chumbalkar@hp.com>
Message-ID: <tip-ded1f6ab43a03be74a53649cf388b5424d447584@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        nagananda.chumbalkar@hp.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        nagananda.chumbalkar@hp.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20110708083555.2598.42216.sendpatchset@nchumbalkar.americas.hpqcorp.net>
References: <20110708083555.2598.42216.sendpatchset@nchumbalkar.americas.hpqcorp.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86: print APIC data a little later during boot
Git-Commit-ID: ded1f6ab43a03be74a53649cf388b5424d447584
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 08 Jul 2011 12:58:17 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ded1f6ab43a03be74a53649cf388b5424d447584
Gitweb:     http://git.kernel.org/tip/ded1f6ab43a03be74a53649cf388b5424d447584
Author:     Naga Chumbalkar <nagananda.chumbalkar@hp.com>
AuthorDate: Fri, 8 Jul 2011 08:36:34 +0000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 8 Jul 2011 13:20:14 +0200

x86: print APIC data a little later during boot

To view IOAPIC data you could boot with "apic=debug".

When booting in such a way then the kernel will dump the
IO-APIC's registers, for example:

NR Dst Mask Trig IRR Pol Stat Dmod Deli Vect:
 00 000 1    0    0   0   0    0    0    00
 01 000 0    0    0   0   0    0    0    31
 02 000 0    0    0   0   0    0    0    30
 03 000 0    0    0   0   0    0    0    33
 04 000 0    0    0   0   0    0    0    34
 05 000 0    0    0   0   0    0    0    35
 06 000 0    0    0   0   0    0    0    36
 07 000 0    0    0   0   0    0    0    37
 08 000 0    0    0   0   0    0    0    38
 09 000 0    1    0   0   0    0    0    39
 0a 000 0    0    0   0   0    0    0    3A
 0b 000 0    0    0   0   0    0    0    3B
 0c 000 0    0    0   0   0    0    0    3C
 0d 000 0    0    0   0   0    0    0    3D
 0e 000 0    0    0   0   0    0    0    3E
 0f 000 0    0    0   0   0    0    0    3F
 10 000 1    0    0   0   0    0    0    00
 11 000 1    0    0   0   0    0    0    00
 12 000 1    0    0   0   0    0    0    00
 13 000 1    0    0   0   0    0    0    00
 14 000 1    0    0   0   0    0    0    00
 15 000 1    0    0   0   0    0    0    00
 16 000 1    0    0   0   0    0    0    00
 17 000 1    0    0   0   0    0    0    00

Delaying the call to print_ICs() gives better results:

NR Dst Mask Trig IRR Pol Stat Dmod Deli Vect:
 00 000 1    0    0   0   0    0    0    00
 01 000 0    0    0   0   0    0    0    31
 02 000 0    0    0   0   0    0    0    30
 03 000 1    0    0   0   0    0    0    33
 04 000 1    0    0   0   0    0    0    34
 05 000 1    0    0   0   0    0    0    35
 06 000 1    0    0   0   0    0    0    36
 07 000 1    0    0   0   0    0    0    37
 08 000 0    0    0   0   0    0    0    38
 09 000 0    1    0   0   0    0    0    39
 0a 000 1    0    0   0   0    0    0    3A
 0b 000 1    0    0   0   0    0    0    3B
 0c 000 0    0    0   0   0    0    0    3C
 0d 000 1    0    0   0   0    0    0    3D
 0e 000 1    0    0   0   0    0    0    3E
 0f 000 1    0    0   0   0    0    0    3F
 10 000 1    1    0   1   0    0    0    29
 11 000 1    0    0   0   0    0    0    00
 12 000 1    0    0   0   0    0    0    00
 13 000 1    0    0   0   0    0    0    00
 14 000 0    1    0   1   0    0    0    51
 15 000 1    0    0   0   0    0    0    00
 16 000 0    1    0   1   0    0    0    61
 17 000 0    1    0   1   0    0    0    59

Notice that the entries beyond interrupt input signal 0x0f also
get populated and arent just the hw-initialization default of
all zeroes.

Signed-off-by: Naga Chumbalkar <nagananda.chumbalkar@hp.com>
Link: http://lkml.kernel.org/r/20110708083555.2598.42216.sendpatchset@nchumbalkar.americas.hpqcorp.net
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/apic/io_apic.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index e529339..98c8d7e 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1792,7 +1792,7 @@ __apicdebuginit(int) print_ICs(void)
 	return 0;
 }
 
-fs_initcall(print_ICs);
+late_initcall(print_ICs);
 
 
 /* Where if anywhere is the i8259 connect in external int mode */

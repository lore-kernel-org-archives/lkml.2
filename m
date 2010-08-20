Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751879Ab0HTMlx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 08:41:53 -0400
Received: from hera.kernel.org ([140.211.167.34]:40237 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751504Ab0HTMlv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 08:41:51 -0400
Date: Fri, 20 Aug 2010 12:41:24 GMT
From: tip-bot for Daniel Kiper <dkiper@net-space.pl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        dkiper@net-space.pl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, dkiper@net-space.pl, mingo@elte.hu
In-Reply-To: <20100819224616.GB9967@router-fw-old.local.net-space.pl>
References: <20100819224616.GB9967@router-fw-old.local.net-space.pl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, apic: Fix apic=debug boot crash
Message-ID: <tip-05e407603e527f9d808dd3866d3a17c2ce4dfcc5@git.kernel.org>
Git-Commit-ID: 05e407603e527f9d808dd3866d3a17c2ce4dfcc5
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 20 Aug 2010 12:41:28 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  05e407603e527f9d808dd3866d3a17c2ce4dfcc5
Gitweb:     http://git.kernel.org/tip/05e407603e527f9d808dd3866d3a17c2ce4dfcc5
Author:     Daniel Kiper <dkiper@net-space.pl>
AuthorDate: Fri, 20 Aug 2010 00:46:16 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 20 Aug 2010 10:18:28 +0200

x86, apic: Fix apic=debug boot crash

Fix a boot crash when apic=debug is used and the APIC is
not properly initialized.

This issue appears during Xen Dom0 kernel boot but the
fix is generic and the crash could occur on real hardware
as well.

Signed-off-by: Daniel Kiper <dkiper@net-space.pl>
Cc: xen-devel@lists.xensource.com
Cc: konrad.wilk@oracle.com
Cc: jeremy@goop.org
Cc: <stable@kernel.org> # .35.x, .34.x, .33.x, .32.x
LKML-Reference: <20100819224616.GB9967@router-fw-old.local.net-space.pl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/apic/io_apic.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 4dc0084..f1efeba 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1728,6 +1728,8 @@ __apicdebuginit(void) print_IO_APIC(void)
 		struct irq_pin_list *entry;
 
 		cfg = desc->chip_data;
+		if (!cfg)
+			continue;
 		entry = cfg->irq_2_pin;
 		if (!entry)
 			continue;

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756407Ab0GWKzY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 06:55:24 -0400
Received: from hera.kernel.org ([140.211.167.34]:41812 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753391Ab0GWKzU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 06:55:20 -0400
Date: Fri, 23 Jul 2010 10:54:52 GMT
From: tip-bot for Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        tglx@linutronix.de, venki@google.com, stefano.stabellini@eu.citrix.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, stefano.stabellini@eu.citrix.com, venki@google.com
In-Reply-To: <alpine.DEB.2.00.1007211726240.22235@kaball-desktop>
References: <alpine.DEB.2.00.1007211726240.22235@kaball-desktop>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: Do not try to disable hpet if it hasn't been initialized before
Message-ID: <tip-ff4878089e1eaeac79d57878ad4ea32910fb4037@git.kernel.org>
Git-Commit-ID: ff4878089e1eaeac79d57878ad4ea32910fb4037
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 23 Jul 2010 10:54:54 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ff4878089e1eaeac79d57878ad4ea32910fb4037
Gitweb:     http://git.kernel.org/tip/ff4878089e1eaeac79d57878ad4ea32910fb4037
Author:     Stefano Stabellini <stefano.stabellini@eu.citrix.com>
AuthorDate: Wed, 21 Jul 2010 18:32:37 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 23 Jul 2010 12:53:00 +0200

x86: Do not try to disable hpet if it hasn't been initialized before

hpet_disable is called unconditionally on machine reboot if hpet support
is compiled in the kernel.
hpet_disable only checks if the machine is hpet capable but doesn't make
sure that hpet has been initialized.

[ tglx: Made it a one liner and removed the redundant hpet_address check ]

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Acked-by: Venkatesh Pallipadi <venki@google.com>
LKML-Reference: <alpine.DEB.2.00.1007211726240.22235@kaball-desktop>
Cc: stable@kernel.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/hpet.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index a198b7c..ba390d7 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -964,7 +964,7 @@ fs_initcall(hpet_late_init);
 
 void hpet_disable(void)
 {
-	if (is_hpet_capable()) {
+	if (is_hpet_capable() && hpet_virt_address) {
 		unsigned int cfg = hpet_readl(HPET_CFG);
 
 		if (hpet_legacy_int_enabled) {

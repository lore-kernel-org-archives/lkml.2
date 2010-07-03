Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755579Ab0GCQKI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jul 2010 12:10:08 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:35163 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753783Ab0GCQKF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jul 2010 12:10:05 -0400
X-Greylist: delayed 365 seconds by postgrey-1.27 at vger.kernel.org; Sat, 03 Jul 2010 12:10:04 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=DzlW66JqVPWOOqjVJP3i7/bLt1ANwMbt0zfY6oeMebVr9FjonScqu6ZX0jHNOQ9JSG
         rtRWjFFaF4ka1kqAj6gKC/haFjoNGRmb4th3wXdgfwKdmW1L28aJgIyKANaTuc+0izrn
         dJqV24yBwLi8k+vGe0gkaCSHBNoqAuNKAYqhg=
From: Kulikov Vasiliy <segooon@gmail.com>
To: Kernel Janitors <kernel-janitors@vger.kernel.org>
Cc: Dave Jones <davej@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       x86@kernel.org, Tejun Heo <tj@kernel.org>, cpufreq@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 06/19] arch/x86/kernel/cpu/cpufreq: use for_each_pci_dev()
Date: Sat,  3 Jul 2010 20:03:55 +0400
Message-Id: <1278173036-11609-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use for_each_pci_dev() to simplify the code.

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 arch/x86/kernel/cpu/cpufreq/gx-suspmod.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/cpufreq/gx-suspmod.c b/arch/x86/kernel/cpu/cpufreq/gx-suspmod.c
index 16e3483..8c3325f 100644
--- a/arch/x86/kernel/cpu/cpufreq/gx-suspmod.c
+++ b/arch/x86/kernel/cpu/cpufreq/gx-suspmod.c
@@ -199,7 +199,7 @@ static __init struct pci_dev *gx_detect_chipset(void)
 	}
 
 	/* detect which companion chip is used */
-	while ((gx_pci = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, gx_pci)) != NULL) {
+	for_each_pci_dev(gx_pci) {
 		if ((pci_match_id(gx_chipset_tbl, gx_pci)) != NULL)
 			return gx_pci;
 	}
-- 
1.7.0.4


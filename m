Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758407Ab2IEK5a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 06:57:30 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56312 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979Ab2IEK52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 06:57:28 -0400
Date: Wed, 5 Sep 2012 03:57:17 -0700
From: tip-bot for Mathias Krause <minipli@googlemail.com>
Message-ID: <tip-04d695a6828bca54d53305246545cd1f8a841ac6@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        dan.j.williams@intel.com, minipli@googlemail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        dan.j.williams@intel.com, minipli@googlemail.com, tglx@linutronix.de
In-Reply-To: <1346621506-30857-5-git-send-email-minipli@googlemail.com>
References: <1346621506-30857-5-git-send-email-minipli@googlemail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/debug] x86/pci/probe_roms:
  Add missing __iomem annotation to pci_map_biosrom()
Git-Commit-ID: 04d695a6828bca54d53305246545cd1f8a841ac6
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 05 Sep 2012 03:57:22 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  04d695a6828bca54d53305246545cd1f8a841ac6
Gitweb:     http://git.kernel.org/tip/04d695a6828bca54d53305246545cd1f8a841ac6
Author:     Mathias Krause <minipli@googlemail.com>
AuthorDate: Sun, 2 Sep 2012 23:31:43 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 5 Sep 2012 10:52:25 +0200

x86/pci/probe_roms: Add missing __iomem annotation to pci_map_biosrom()

Stay in sync with the declaration and fix the corresponding
sparse warnings.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Link: http://lkml.kernel.org/r/1346621506-30857-5-git-send-email-minipli@googlemail.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/probe_roms.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/probe_roms.c b/arch/x86/kernel/probe_roms.c
index 0bc72e2..d5f15c3 100644
--- a/arch/x86/kernel/probe_roms.c
+++ b/arch/x86/kernel/probe_roms.c
@@ -150,7 +150,7 @@ static struct resource *find_oprom(struct pci_dev *pdev)
 	return oprom;
 }
 
-void *pci_map_biosrom(struct pci_dev *pdev)
+void __iomem *pci_map_biosrom(struct pci_dev *pdev)
 {
 	struct resource *oprom = find_oprom(pdev);
 

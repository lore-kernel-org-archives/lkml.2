Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751735Ab2LTT7x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 14:59:53 -0500
Received: from terminus.zytor.com ([198.137.202.10]:56088 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917Ab2LTT7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 14:59:45 -0500
Date: Thu, 20 Dec 2012 11:59:21 -0800
From: tip-bot for Sasha Levin <sasha.levin@oracle.com>
Message-ID: <tip-886d751a2ea99a160f2d0a472231566d9cb0cf58@git.kernel.org>
Cc: mjg@redhat.com, linux-kernel@vger.kernel.org, sasha.levin@oracle.com,
        hpa@zytor.com, mingo@kernel.org, seth.forshee@canonical.com,
        matt.fleming@intel.com, bhelgaas@google.com, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, sasha.levin@oracle.com,
        linux-kernel@vger.kernel.org, mjg@redhat.com, matt.fleming@intel.com,
        seth.forshee@canonical.com, bhelgaas@google.com, tglx@linutronix.de,
        hpa@linux.intel.com
In-Reply-To: <1356030701-16284-25-git-send-email-sasha.levin@oracle.com>
References: <1356030701-16284-25-git-send-email-sasha.levin@oracle.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, efi:
  correct precedence of operators in setup_efi_pci
Git-Commit-ID: 886d751a2ea99a160f2d0a472231566d9cb0cf58
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 20 Dec 2012 11:59:28 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  886d751a2ea99a160f2d0a472231566d9cb0cf58
Gitweb:     http://git.kernel.org/tip/886d751a2ea99a160f2d0a472231566d9cb0cf58
Author:     Sasha Levin <sasha.levin@oracle.com>
AuthorDate: Thu, 20 Dec 2012 14:11:33 -0500
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 20 Dec 2012 11:47:14 -0800

x86, efi: correct precedence of operators in setup_efi_pci

With the current code, the condition in the if() doesn't make much sense due to
precedence of operators.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
Link: http://lkml.kernel.org/r/1356030701-16284-25-git-send-email-sasha.levin@oracle.com
Cc: Matt Fleming <matt.fleming@intel.com>
Cc: Matthew Garrett <mjg@redhat.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Seth Forshee <seth.forshee@canonical.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/boot/compressed/eboot.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index b1942e2..18e329c 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -302,7 +302,7 @@ static efi_status_t setup_efi_pci(struct boot_params *params)
 		if (status != EFI_SUCCESS)
 			continue;
 
-		if (!attributes & EFI_PCI_IO_ATTRIBUTE_EMBEDDED_ROM)
+		if (!(attributes & EFI_PCI_IO_ATTRIBUTE_EMBEDDED_ROM))
 			continue;
 
 		if (!pci->romimage || !pci->romsize)

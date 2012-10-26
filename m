Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758519Ab2JZLRo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 07:17:44 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52696 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755406Ab2JZLRm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 07:17:42 -0400
Date: Fri, 26 Oct 2012 04:17:29 -0700
From: tip-bot for Bin Gao <bin.gao@linux.intel.com>
Message-ID: <tip-6e87f9b7e48e165cb8e6092b9abe682e7065614a@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        bin.gao@intel.com, tglx@linutronix.de, len.brown@intel.com,
        bin.gao@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, bin.gao@intel.com, bin.gao@linux.intel.com,
        len.brown@intel.com
In-Reply-To: <20121025163544.GB38477@bingao-desk1.fm.intel.com>
References: <20121025163544.GB38477@bingao-desk1.fm.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/boot] arch/x86/Kconfig:
  Allow turning off CONFIG_X86_MPPARSE when either ACPI or SFI is present
Git-Commit-ID: 6e87f9b7e48e165cb8e6092b9abe682e7065614a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 26 Oct 2012 04:17:34 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6e87f9b7e48e165cb8e6092b9abe682e7065614a
Gitweb:     http://git.kernel.org/tip/6e87f9b7e48e165cb8e6092b9abe682e7065614a
Author:     Bin Gao <bin.gao@linux.intel.com>
AuthorDate: Thu, 25 Oct 2012 09:35:44 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 26 Oct 2012 12:20:38 +0200

arch/x86/Kconfig: Allow turning off CONFIG_X86_MPPARSE when either ACPI or SFI is present

MPS tables are not needed for systems that have proper ACPI
support. This is also true for systems that have SFI in place.

So this patch allows the configuration (turning off) of
CONFIG_X86_MPPARSE when either ACPI or SFI is present.

Signed-off-by: Bin Gao <bin.gao@intel.com>
Cc: Len Brown <len.brown@intel.com>
Cc: Bin Gao <bin.gao@linux.intel.com>
Link: http://lkml.kernel.org/r/20121025163544.GB38477@bingao-desk1.fm.intel.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 46c3bff..b1494bd 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -310,7 +310,7 @@ config X86_X2APIC
 	  If you don't know what to do here, say N.
 
 config X86_MPPARSE
-	bool "Enable MPS table" if ACPI
+	bool "Enable MPS table" if ACPI || SFI
 	default y
 	depends on X86_LOCAL_APIC
 	---help---

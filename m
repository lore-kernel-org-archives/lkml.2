Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752903Ab0JOHsa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 03:48:30 -0400
Received: from hera.kernel.org ([140.211.167.34]:57586 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751269Ab0JOHs3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 03:48:29 -0400
Date: Fri, 15 Oct 2010 07:46:54 GMT
From: tip-bot for Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        dsd@laptop.org, sfr@canb.auug.org.au, tglx@linutronix.de,
        randy.dunlap@oracle.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        dsd@laptop.org, tglx@linutronix.de, sfr@canb.auug.org.au,
        randy.dunlap@oracle.com, mingo@elte.hu
In-Reply-To: <20101014101313.adf7eb2a.randy.dunlap@oracle.com>
References: <20101014101313.adf7eb2a.randy.dunlap@oracle.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/olpc] x86, olpc: XO-1 uses/depends on PCI
Message-ID: <tip-9e9006e9090dc1f88d5127cb69f416013e7ecd60@git.kernel.org>
Git-Commit-ID: 9e9006e9090dc1f88d5127cb69f416013e7ecd60
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 15 Oct 2010 07:46:54 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9e9006e9090dc1f88d5127cb69f416013e7ecd60
Gitweb:     http://git.kernel.org/tip/9e9006e9090dc1f88d5127cb69f416013e7ecd60
Author:     Randy Dunlap <randy.dunlap@oracle.com>
AuthorDate: Thu, 14 Oct 2010 10:13:13 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 15 Oct 2010 09:41:38 +0200

x86, olpc: XO-1 uses/depends on PCI

olpc-xo1 uses pci_*() interfaces so it should depend on PCI.

Otherwise we get build failure like:

 arch/x86/kernel/olpc-xo1.c:65: error: implicit declaration of function 'pci_enable_device_io'
 arch/x86/kernel/olpc-xo1.c:71: error: implicit declaration of function 'pci_request_region'
 arch/x86/kernel/olpc-xo1.c:80: error: implicit declaration of function 'pci_release_region'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Acked-by: Daniel Drake <dsd@laptop.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
LKML-Reference: <20101014101313.adf7eb2a.randy.dunlap@oracle.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 0bcb876..c010b8d 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -2068,7 +2068,7 @@ config OLPC
 
 config OLPC_XO1
 	tristate "OLPC XO-1 support"
-	depends on OLPC
+	depends on OLPC && PCI
 	---help---
 	  Add support for non-essential features of the OLPC XO-1 laptop.
 

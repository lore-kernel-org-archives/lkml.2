Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754225Ab0DBTHN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 15:07:13 -0400
Received: from hera.kernel.org ([140.211.167.34]:47728 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753750Ab0DBTHG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 15:07:06 -0400
Date: Fri, 2 Apr 2010 19:06:39 GMT
From: tip-bot for David Rientjes <rientjes@google.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de, rientjes@google.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, rientjes@google.com, mingo@elte.hu
In-Reply-To: <alpine.DEB.2.00.1003251538060.8589@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1003251538060.8589@chino.kir.corp.google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: Increase CONFIG_NODES_SHIFT max to 10
Message-ID: <tip-51591e31dcb3716f03f962e26ec36a029aa46340@git.kernel.org>
Git-Commit-ID: 51591e31dcb3716f03f962e26ec36a029aa46340
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 02 Apr 2010 19:06:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  51591e31dcb3716f03f962e26ec36a029aa46340
Gitweb:     http://git.kernel.org/tip/51591e31dcb3716f03f962e26ec36a029aa46340
Author:     David Rientjes <rientjes@google.com>
AuthorDate: Thu, 25 Mar 2010 15:39:27 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 2 Apr 2010 19:09:31 +0200

x86: Increase CONFIG_NODES_SHIFT max to 10

Some larger systems require more than 512 nodes, so increase the
maximum CONFIG_NODES_SHIFT to 10 for a new max of 1024 nodes.

This was tested with numa=fake=64M on systems with more than
64GB of RAM. A total of 1022 nodes were initialized.

Successfully builds with no additional warnings on x86_64
allyesconfig.

( No effect on any existing config. Newly enabled CONFIG_MAXSMP=y
  will see the new default. )

Signed-off-by: David Rientjes <rientjes@google.com>
LKML-Reference: <alpine.DEB.2.00.1003251538060.8589@chino.kir.corp.google.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/Kconfig |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 0eacb1f..9458685 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1216,8 +1216,8 @@ config NUMA_EMU
 
 config NODES_SHIFT
 	int "Maximum NUMA Nodes (as a power of 2)" if !MAXSMP
-	range 1 9
-	default "9" if MAXSMP
+	range 1 10
+	default "10" if MAXSMP
 	default "6" if X86_64
 	default "4" if X86_NUMAQ
 	default "3"

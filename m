Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932095Ab2LRVy7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 16:54:59 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:33190 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754569Ab2LRVyx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 16:54:53 -0500
From: Corey Bryant <coreyb@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org, jmorris@namei.org, wad@chromium.org,
        pmoore@redhat.com, otubo@linux.vnet.ibm.com
Subject: [PATCH 2/3] Documentation: SECCOMP_RET_INFO return value
Date: Tue, 18 Dec 2012 16:54:31 -0500
Message-Id: <1355867671-3269-1-git-send-email-coreyb@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.11.7
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12121821-2398-0000-0000-00000F298440
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds documentation describing the SECCOMP_RET_INFO return value.

Signed-off-by: Corey Bryant <coreyb@linux.vnet.ibm.com>
---
 Documentation/prctl/seccomp_filter.txt | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/Documentation/prctl/seccomp_filter.txt b/Documentation/prctl/seccomp_filter.txt
index 1e469ef..ffddf9f 100644
--- a/Documentation/prctl/seccomp_filter.txt
+++ b/Documentation/prctl/seccomp_filter.txt
@@ -49,6 +49,7 @@ CONFIG_HAVE_ARCH_SECCOMP_FILTER, then filters may be added as below:
 PR_SET_SECCOMP:
 	Now takes an additional argument which specifies a new filter
 	using a BPF program.
+
 	The BPF program will be executed over struct seccomp_data
 	reflecting the system call number, arguments, and other
 	metadata.  The BPF program must then return one of the
@@ -138,6 +139,12 @@ SECCOMP_RET_TRACE:
 	allow use of ptrace, even of other sandboxed processes, without
 	extreme care; ptracers can use this mechanism to escape.)
 
+SECCOMP_RET_INFO:
+	Results in a rate-limited informational kernel message that
+	includes the system call number, and the system call is
+	executed.  The message format is:
+	"seccomp: syscall=x", where x is the system call number.
+
 SECCOMP_RET_ALLOW:
 	Results in the system call being executed.
 
-- 
1.7.11.7


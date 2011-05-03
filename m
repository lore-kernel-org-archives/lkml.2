Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752931Ab1ECObb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 10:31:31 -0400
Received: from 236.121.91-79.rev.gaoland.net ([79.91.121.236]:46244 "EHLO
	mx.synack.fr" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751262Ab1ECOb2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 10:31:28 -0400
X-Greylist: delayed 420 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 May 2011 10:31:28 EDT
From: Samir Bellabes <sam@synack.fr>
To: linux-security-module@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, jamal <hadi@cyberus.ca>,
        Patrick McHardy <kaber@trash.net>, Evgeniy Polyakov <zbr@ioremap.net>,
        Grzegorz Nosek <root@localdomain.pl>, Samir Bellabes <sam@synack.fr>
Subject: [RFC v3 09/10] snet: introduce snet_utils
Date: Tue,  3 May 2011 16:24:22 +0200
Message-Id: <1304432663-1575-10-git-send-email-sam@synack.fr>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1304432663-1575-1-git-send-email-sam@synack.fr>
References: <1304432663-1575-1-git-send-email-sam@synack.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch provides helper functions for other subsystems

Signed-off-by: Samir Bellabes <sam@synack.fr>
---
 security/snet/snet_utils.c |   38 ++++++++++++++++++++++++++++++++++++++
 security/snet/snet_utils.h |    9 +++++++++
 2 files changed, 47 insertions(+), 0 deletions(-)
 create mode 100644 security/snet/snet_utils.c
 create mode 100644 security/snet/snet_utils.h

diff --git a/security/snet/snet_utils.c b/security/snet/snet_utils.c
new file mode 100644
index 0000000..e9178d7
--- /dev/null
+++ b/security/snet/snet_utils.c
@@ -0,0 +1,38 @@
+#include <linux/types.h>
+#include <linux/snet.h>
+
+const char *snet_verdict_name(const enum snet_verdict cmd)
+{
+	static const char *const verdict_name[] = {
+		[SNET_VERDICT_GRANT]	= "Grant",
+		[SNET_VERDICT_DENY]	= "Deny",
+		[SNET_VERDICT_PENDING]	= "Pending",
+		[SNET_VERDICT_NONE]	= "None",
+	};
+
+	if (cmd >= SNET_NR_VERDICT_TYPES)
+		return "INVALID";
+	else
+		return verdict_name[cmd];
+}
+
+const char *snet_syscall_name(const enum snet_syscall sys)
+{
+	static const char *const syscall_name[] = {
+		[SNET_SOCKET_CREATE]		= "Create",
+		[SNET_SOCKET_BIND]		= "Bind",
+		[SNET_SOCKET_CONNECT]		= "Connect",
+		[SNET_SOCKET_LISTEN]		= "Listen",
+		[SNET_SOCKET_ACCEPT]		= "Accept",
+		[SNET_SOCKET_POST_ACCEPT]	= "Post Accept",
+		[SNET_SOCKET_SENDMSG]		= "Sendmsg",
+		[SNET_SOCKET_RECVMSG]		= "Recvmsg",
+		[SNET_SOCKET_SOCK_RCV_SKB]	= "Sock Rcv Skb",
+		[SNET_SOCKET_CLOSE]		= "Close",
+	};
+
+	if (sys >= SNET_NR_SOCKET_TYPES)
+		return "INVALID";
+	else
+		return syscall_name[sys];
+}
diff --git a/security/snet/snet_utils.h b/security/snet/snet_utils.h
new file mode 100644
index 0000000..01e515f
--- /dev/null
+++ b/security/snet/snet_utils.h
@@ -0,0 +1,9 @@
+#ifndef _SNET_UTILS_H
+#define _SNET_UTILS_H
+
+#include <linux/skbuff.h>
+
+const char *snet_verdict_name(const enum snet_verdict cmd);
+const char *snet_syscall_name(const enum snet_syscall sys);
+
+#endif	/* _SNET_UTILS_H */
-- 
1.7.4.1


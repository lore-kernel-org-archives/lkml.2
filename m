Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757848Ab2JSC4u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 22:56:50 -0400
Received: from mail.kernel.org ([198.145.19.201]:52404 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965004Ab2JSCtT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 22:49:19 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Sasha Levin <sasha.levin@oracle.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Dave Jones <davej@redhat.com>
Subject: [ 55/76] fs: handle failed audit_log_start properly
Date: Thu, 18 Oct 2012 19:47:19 -0700
Message-Id: <20121019024358.977576495@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121019024350.087156547@linuxfoundation.org>
References: <20121019024350.087156547@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sasha Levin <sasha.levin@oracle.com>

commit d1c7d97ad58836affde6e39980b96527510b572e upstream.

audit_log_start() may return NULL, this is unchecked by the caller in
audit_log_link_denied() and could cause a NULL ptr deref.

Introduced by commit a51d9eaa ("fs: add link restriction audit reporting").

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Cc: Dave Jones <davej@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/audit.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -1466,6 +1466,8 @@ void audit_log_link_denied(const char *o
 
 	ab = audit_log_start(current->audit_context, GFP_KERNEL,
 			     AUDIT_ANOM_LINK);
+	if (!ab)
+		return;
 	audit_log_format(ab, "op=%s action=denied", operation);
 	audit_log_format(ab, " pid=%d comm=", current->pid);
 	audit_log_untrustedstring(ab, current->comm);



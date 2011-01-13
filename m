Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933089Ab1AMQXV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 11:23:21 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:54694 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933020Ab1AMQXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 11:23:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=VXHtOAB4JIay7miqTabD7EY0Xu7tgVxR1zetQsx4BtETgovNy0LSqylby9NoqPJSjI
         p5li6YLTkuKCyPb8BY5Vb88lOZZo30qBenC4e2oe81G2xlo7dk9tl53U98vlHKERCxwW
         310HroxcKaC9aFOwKIpiJIGK2Ur06cIwoKNig=
Date: Thu, 13 Jan 2011 18:23:10 +0200
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: "Andrew G. Morgan" <morgan@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] libcap: introduce CAP_SYSLOG
Message-ID: <20110113162310.GA4044@swordfish>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit 38ef4c2e437d11b5922723504b62824e96761459 syslog
operations require CAP_SYSLOG capability (intoriduced by commit 
ce6ada35bdf710d16582cc4869c26722547e6f11), not CAP_SYS_ADMIN.

Patch introduces CAP_SYSLOG capability.

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>

---

 libcap/include/linux/capability.h |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/libcap/include/linux/capability.h b/libcap/include/linux/capability.h
index 39e5ff5..4924f2a 100644
--- a/libcap/include/linux/capability.h
+++ b/libcap/include/linux/capability.h
@@ -355,7 +355,12 @@ struct cpu_vfs_cap_data {
 
 #define CAP_MAC_ADMIN        33
 
-#define CAP_LAST_CAP         CAP_MAC_ADMIN
+
+/* Privileged syslog operations currently require CAP_SYSLOG.
+   CAP_SYS_ADMIN is not acceptable anymore. */
+#define CAP_SYSLOG           34
+
+#define CAP_LAST_CAP         CAP_SYSLOG
 
 #define cap_valid(x) ((x) >= 0 && (x) <= CAP_LAST_CAP)
 

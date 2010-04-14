Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754604Ab0DNCme (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 22:42:34 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:35975 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754544Ab0DNCmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 22:42:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=YVj00ZBv9bJtzy207jpcr5tRm1zCORhxHuHaomQe/QfMjnNsP7Fs9fWYYaTlOox2ll
         xFL442lMP77DGfMrkKaWmPk3ybeE64LSpQ5D6XQN9YjBnghCwsLq3iMnY7iTt+VPfR20
         wQX9sdiRzwim7EPnwjka8LgtQwLJRsZY2/gj8=
Date: Wed, 14 Apr 2010 10:48:42 +0800
From: wzt.wzt@gmail.com
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org, jmorris@namei.org
Subject: Security: Replace dac_mmap_min_addr to mmap_min_addr in cap_file_mmap()
Message-ID: <20100414024842.GB3718@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cap_file_mmap() comments said "If the process is attempting to map 
memory below mmap_min_addr", if CONFIG_LSM_MMAP_MIN_ADDR is set, 
dac_mmap_min_addr is not equal mmap_min_addr, so replace dac_mmap_min_addr
to mmap_min_addr seems to be better.

Signed-off-by: Zhitong Wang <zhitong.wangzt@alibaba-inc.com>

---
 include/linux/security.h |    1 +
 security/commoncap.c     |    2 +-
 2 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/include/linux/security.h b/include/linux/security.h
index 233d20b..61fd9e7 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -101,6 +101,7 @@ void reset_security_ops(void);
 extern unsigned long mmap_min_addr;
 extern unsigned long dac_mmap_min_addr;
 #else
+#define mmap_min_addr		0UL
 #define dac_mmap_min_addr	0UL
 #endif
 
diff --git a/security/commoncap.c b/security/commoncap.c
index 6166973..878cf89 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -942,7 +942,7 @@ int cap_file_mmap(struct file *file, unsigned long reqprot,
 {
 	int ret = 0;
 
-	if (addr < dac_mmap_min_addr) {
+	if (addr < mmap_min_addr) {
 		ret = cap_capable(current, current_cred(), CAP_SYS_RAWIO,
 				  SECURITY_CAP_AUDIT);
 		/* set PF_SUPERPRIV if it turns out we allow the low mmap */
-- 
1.6.5.3


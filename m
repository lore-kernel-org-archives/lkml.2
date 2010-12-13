Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932286Ab0LMRFf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 12:05:35 -0500
Received: from shutemov.name ([188.40.19.243]:54682 "EHLO shutemov.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932138Ab0LMRFd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 12:05:33 -0500
From: "Kirill A. Shutsemov" <kirill@shutemov.name>
To: "David S. Miller" <davem@davemloft.net>
Cc: netdev@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Dmitry V. Levin" <ldv@altlinux.org>, linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: [PATCH] netlink: fix gcc -Wconversion compilation warning
Date: Mon, 13 Dec 2010 19:05:13 +0200
Message-Id: <1292259913-9911-1-git-send-email-kirill@shutemov.name>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dmitry V. Levin <ldv@altlinux.org>

$ cat << EOF | gcc -Wconversion -xc -S -o/dev/null -
unsigned f(void) {return NLMSG_HDRLEN;}
EOF
<stdin>: In function 'f':
<stdin>:3:26: warning: negative integer implicitly converted to unsigned type

Signed-off-by: Dmitry V. Levin <ldv@altlinux.org>
Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
---
 include/linux/netlink.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/netlink.h b/include/linux/netlink.h
index 1235669..e2b9e63 100644
--- a/include/linux/netlink.h
+++ b/include/linux/netlink.h
@@ -70,7 +70,7 @@ struct nlmsghdr {
    Check		NLM_F_EXCL
  */
 
-#define NLMSG_ALIGNTO	4
+#define NLMSG_ALIGNTO	4U
 #define NLMSG_ALIGN(len) ( ((len)+NLMSG_ALIGNTO-1) & ~(NLMSG_ALIGNTO-1) )
 #define NLMSG_HDRLEN	 ((int) NLMSG_ALIGN(sizeof(struct nlmsghdr)))
 #define NLMSG_LENGTH(len) ((len)+NLMSG_ALIGN(NLMSG_HDRLEN))
-- 
1.7.3.3


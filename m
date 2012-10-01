Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965135Ab2JAX1J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 19:27:09 -0400
Received: from 1wt.eu ([62.212.114.60]:35265 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932777Ab2JAXA4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 19:00:56 -0400
Message-Id: <20121001225203.757191787@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 02 Oct 2012 00:54:22 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Dan Carpenter <dan.carpenter@oracle.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 145/180] x86, tls: Off by one limit check
In-Reply-To: <6a854f579a99b4fe2efaca1057e8ae22@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 8f0750f19789cf352d7e24a6cc50f2ab1b4f1372 upstream.

These are used as offsets into an array of GDT_ENTRY_TLS_ENTRIES members
so GDT_ENTRY_TLS_ENTRIES is one past the end of the array.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Link: http://lkml.kernel.org/r/20120324075250.GA28258@elgon.mountain
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 arch/x86/kernel/tls.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/tls.c b/arch/x86/kernel/tls.c
index 6bb7b85..bcfec2d 100644
--- a/arch/x86/kernel/tls.c
+++ b/arch/x86/kernel/tls.c
@@ -163,7 +163,7 @@ int regset_tls_get(struct task_struct *target, const struct user_regset *regset,
 {
 	const struct desc_struct *tls;
 
-	if (pos > GDT_ENTRY_TLS_ENTRIES * sizeof(struct user_desc) ||
+	if (pos >= GDT_ENTRY_TLS_ENTRIES * sizeof(struct user_desc) ||
 	    (pos % sizeof(struct user_desc)) != 0 ||
 	    (count % sizeof(struct user_desc)) != 0)
 		return -EINVAL;
@@ -198,7 +198,7 @@ int regset_tls_set(struct task_struct *target, const struct user_regset *regset,
 	struct user_desc infobuf[GDT_ENTRY_TLS_ENTRIES];
 	const struct user_desc *info;
 
-	if (pos > GDT_ENTRY_TLS_ENTRIES * sizeof(struct user_desc) ||
+	if (pos >= GDT_ENTRY_TLS_ENTRIES * sizeof(struct user_desc) ||
 	    (pos % sizeof(struct user_desc)) != 0 ||
 	    (count % sizeof(struct user_desc)) != 0)
 		return -EINVAL;
-- 
1.7.2.1.45.g54fbc




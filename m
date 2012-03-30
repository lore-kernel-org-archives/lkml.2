Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935397Ab2C3VIo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 17:08:44 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:55577 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935371Ab2C3VIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:08:35 -0400
Message-Id: <20120330195737.212469285@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 30 Mar 2012 12:59:07 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Dan Carpenter <dan.carpenter@oracle.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [ 105/108] x86, tls: Off by one limit check
In-Reply-To: <20120330195812.GA31833@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 8f0750f19789cf352d7e24a6cc50f2ab1b4f1372 upstream.

These are used as offsets into an array of GDT_ENTRY_TLS_ENTRIES members
so GDT_ENTRY_TLS_ENTRIES is one past the end of the array.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Link: http://lkml.kernel.org/r/20120324075250.GA28258@elgon.mountain
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/tls.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/x86/kernel/tls.c
+++ b/arch/x86/kernel/tls.c
@@ -163,7 +163,7 @@ int regset_tls_get(struct task_struct *t
 {
 	const struct desc_struct *tls;
 
-	if (pos > GDT_ENTRY_TLS_ENTRIES * sizeof(struct user_desc) ||
+	if (pos >= GDT_ENTRY_TLS_ENTRIES * sizeof(struct user_desc) ||
 	    (pos % sizeof(struct user_desc)) != 0 ||
 	    (count % sizeof(struct user_desc)) != 0)
 		return -EINVAL;
@@ -198,7 +198,7 @@ int regset_tls_set(struct task_struct *t
 	struct user_desc infobuf[GDT_ENTRY_TLS_ENTRIES];
 	const struct user_desc *info;
 
-	if (pos > GDT_ENTRY_TLS_ENTRIES * sizeof(struct user_desc) ||
+	if (pos >= GDT_ENTRY_TLS_ENTRIES * sizeof(struct user_desc) ||
 	    (pos % sizeof(struct user_desc)) != 0 ||
 	    (count % sizeof(struct user_desc)) != 0)
 		return -EINVAL;



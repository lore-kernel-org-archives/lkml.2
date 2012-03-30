Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936494Ab2C3WI4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 18:08:56 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33001 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965366Ab2C3VPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:15:42 -0400
Message-Id: <20120330194902.002276664@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 30 Mar 2012 12:50:45 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Tim Abbott <tim.abbott@oracle.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: [ 132/149] module: Remove module size limit
In-Reply-To: <20120330195823.GA31857@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sasha Levin <levinsasha928@gmail.com>

commit f946eeb9313ff1470758e171a60fe7438a2ded3f upstream.

Module size was limited to 64MB, this was legacy limitation due to vmalloc()
which was removed a while ago.

Limiting module size to 64MB is both pointless and affects real world use
cases.

Cc: Tim Abbott <tim.abbott@oracle.com>
Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/module.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2341,8 +2341,7 @@ static int copy_and_check(struct load_in
 		return -ENOEXEC;
 
 	/* Suck in entire file: we'll want most of it. */
-	/* vmalloc barfs on "unusual" numbers.  Check here */
-	if (len > 64 * 1024 * 1024 || (hdr = vmalloc(len)) == NULL)
+	if ((hdr = vmalloc(len)) == NULL)
 		return -ENOMEM;
 
 	if (copy_from_user(hdr, umod, len) != 0) {



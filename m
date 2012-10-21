Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754871Ab2JUB7j (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2012 21:59:39 -0400
Received: from oproxy11-pub.bluehost.com ([173.254.64.10]:38719 "HELO
	oproxy11-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753073Ab2JUB7h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2012 21:59:37 -0400
Message-ID: <50835703.30608@xenotime.net>
Date: Sat, 20 Oct 2012 18:59:31 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
CC: David Howells <dhowells@redhat.com>
Subject: [PATCH] module_signing: fix printk format warning
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

kernel/module_signing.c:195:2: warning: format '%lu' expects type 'long unsigned int', but argument 3 has type 'size_t'

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Cc: David Howells <dhowells@redhat.com>
---
 kernel/module_signing.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- lnx-37-rc2.orig/kernel/module_signing.c
+++ lnx-37-rc2/kernel/module_signing.c
@@ -192,7 +192,7 @@ int mod_verify_sig(const void *mod, unsi
 	size_t modlen = *_modlen, sig_len;
 	int ret;
 
-	pr_devel("==>%s(,%lu)\n", __func__, modlen);
+	pr_devel("==>%s(,%zu)\n", __func__, modlen);
 
 	if (modlen <= sizeof(ms))
 		return -EBADMSG;

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757505Ab2FOTTj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 15:19:39 -0400
Received: from oproxy9.bluehost.com ([69.89.24.6]:40997 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757374Ab2FOTTh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 15:19:37 -0400
Message-ID: <4FDB8AB8.6060703@xenotime.net>
Date: Fri, 15 Jun 2012 12:19:20 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Marco Stornelli <marco.stornelli@gmail.com>,
        Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH -next] pstore: fix printk format warning in ram.c
References: <20120615143303.3b88edcbc3efc7b1bf81839b@canb.auug.org.au>
In-Reply-To: <20120615143303.3b88edcbc3efc7b1bf81839b@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

Fix printk format warning (on i386) in pstore:

fs/pstore/ram.c:378:3: warning: format '%lu' expects type 'long unsigned int', but argument 2 has type 'size_t'

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
---
 fs/pstore/ram.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20120615.orig/fs/pstore/ram.c
+++ linux-next-20120615/fs/pstore/ram.c
@@ -375,7 +375,7 @@ static int __init ramoops_probe(struct p
 		goto fail_init_cprz;
 
 	if (!cxt->przs && !cxt->cprz) {
-		pr_err("memory size too small, minimum is %lu\n",
+		pr_err("memory size too small, minimum is %zu\n",
 			cxt->console_size + cxt->record_size);
 		goto fail_cnt;
 	}

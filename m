Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754916Ab2GWX7d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 19:59:33 -0400
Received: from oproxy5-pub.bluehost.com ([67.222.38.55]:52794 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754602Ab2GWX7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 19:59:31 -0400
Message-ID: <500DE527.1030309@xenotime.net>
Date: Mon, 23 Jul 2012 16:58:31 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Marco Stornelli <marco.stornelli@gmail.com>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH -next] pstore: fix printk format warning
References: <20120723164036.52bc93caafcd165fc16f0284@canb.auug.org.au>
In-Reply-To: <20120723164036.52bc93caafcd165fc16f0284@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

Fix printk format warning (on i386) in pstore:

fs/pstore/ram.c:409:3: warning: format '%lu' expects type 'long unsigned int', but argument 2 has type 'size_t'

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Acked-by: Kees Cook <keescook@chromium.org>
---
This patch from June 15 is still needed in linux-next.

 fs/pstore/ram.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20120723.orig/fs/pstore/ram.c
+++ linux-next-20120723/fs/pstore/ram.c
@@ -406,7 +406,7 @@ static int __devinit ramoops_probe(struc
 		goto fail_init_fprz;
 
 	if (!cxt->przs && !cxt->cprz && !cxt->fprz) {
-		pr_err("memory size too small, minimum is %lu\n",
+		pr_err("memory size too small, minimum is %zu\n",
 			cxt->console_size + cxt->record_size +
 			cxt->ftrace_size);
 		goto fail_cnt;

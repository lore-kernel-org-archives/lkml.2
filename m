Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757840Ab2K0BxF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 20:53:05 -0500
Received: from 173-254-64-10.unifiedlayer.com ([173.254.64.10]:56732 "HELO
	oproxy11-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755500Ab2K0BxD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 20:53:03 -0500
Message-ID: <50B41CF9.3050502@xenotime.net>
Date: Mon, 26 Nov 2012 17:52:57 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: stable@vger.kernel.org
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH -stable 3.6.x] pstore: fix ram.c printk format warning
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

Fix printk format warning (on i386) in pstore:

fs/pstore/ram.c:409:3: warning: format '%lu' expects type 'long unsigned int', but argument 2 has type 'size_t'

Mainline patch commit ID is: 0427193b691edc81c846c7d0ebd2561cae8709d8

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Acked-by: Kees Cook <keescook@chromium.org>
Cc: Anton Vorontsov <anton.vorontsov@linaro.org>
---
 fs/pstore/ram.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- lnx-36-rc1.orig/fs/pstore/ram.c
+++ lnx-36-rc1/fs/pstore/ram.c
@@ -406,7 +406,7 @@ static int __devinit ramoops_probe(struc
 		goto fail_init_fprz;
 
 	if (!cxt->przs && !cxt->cprz && !cxt->fprz) {
-		pr_err("memory size too small, minimum is %lu\n",
+		pr_err("memory size too small, minimum is %zu\n",
 			cxt->console_size + cxt->record_size +
 			cxt->ftrace_size);
 		goto fail_cnt;

-- 
~Randy

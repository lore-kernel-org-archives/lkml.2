Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754086Ab2HDAEH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 20:04:07 -0400
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:35292 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754018Ab2HDAED (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 20:04:03 -0400
Message-ID: <501C66A8.5000902@xenotime.net>
Date: Fri, 03 Aug 2012 17:02:48 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH] pstore: fix printk format warning
References: <CA+55aFy4vnD5-8SWF_WDC3oTGotzkDg2_4=YHXd6qMiJ=OKekw@mail.gmail.com>
In-Reply-To: <CA+55aFy4vnD5-8SWF_WDC3oTGotzkDg2_4=YHXd6qMiJ=OKekw@mail.gmail.com>
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
Cc: Anton Vorontsov <anton.vorontsov@linaro.org>
---
I posted this patch on June 15 and July 23 but it has not been
merged anywhere afaict, so I'm sending it directly to the man.

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

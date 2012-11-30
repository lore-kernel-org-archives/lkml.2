Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1768682Ab2K3TJ6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 14:09:58 -0500
Received: from mail.kernel.org ([198.145.19.201]:59610 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993025Ab2K3TC0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 14:02:26 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Randy Dunlap <rdunlap@xenotime.net>, Kees Cook <keescook@chromium.org>,
        Anton Vorontsov <anton.vorontsov@linaro.org>
Subject: [ 38/54] pstore/ram: Fix printk format warning
Date: Fri, 30 Nov 2012 10:56:09 -0800
Message-Id: <20121130185211.769708948@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121130185207.894301294@linuxfoundation.org>
References: <20121130185207.894301294@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Randy Dunlap <rdunlap@xenotime.net>

commit 0427193b691edc81c846c7d0ebd2561cae8709d8 upstream.

Fix printk format warning (on i386) in pstore:

fs/pstore/ram.c:409:3: warning: format '%lu' expects type 'long unsigned int', but argument 2 has type 'size_t'

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Acked-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/pstore/ram.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/pstore/ram.c
+++ b/fs/pstore/ram.c
@@ -406,7 +406,7 @@ static int __devinit ramoops_probe(struc
 		goto fail_init_fprz;
 
 	if (!cxt->przs && !cxt->cprz && !cxt->fprz) {
-		pr_err("memory size too small, minimum is %lu\n",
+		pr_err("memory size too small, minimum is %zu\n",
 			cxt->console_size + cxt->record_size +
 			cxt->ftrace_size);
 		goto fail_cnt;



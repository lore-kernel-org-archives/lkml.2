Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752790Ab2JVEnC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 00:43:02 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:34513 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751153Ab2JVEnA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 00:43:00 -0400
MIME-Version: 1.0
Date: Mon, 22 Oct 2012 12:42:59 +0800
Message-ID: <CAPgLHd-kHAx5Eb8Jd8iH4=KoCv1mjrtaLWd4D7bWJ2zLQoJe3g@mail.gmail.com>
Subject: [PATCH] TTY: hvcs: fix missing unlock on error in hvcs_initialize()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: gregkh@linuxfoundation.org
Cc: yongjun_wei@trendmicro.com.cn, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Add the missing unlock on the error handling path in function
hvcs_initialize().

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/tty/hvc/hvcs.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/hvc/hvcs.c b/drivers/tty/hvc/hvcs.c
index cab5c7a..744c3b8 100644
--- a/drivers/tty/hvc/hvcs.c
+++ b/drivers/tty/hvc/hvcs.c
@@ -1496,8 +1496,10 @@ static int __devinit hvcs_initialize(void)
 		num_ttys_to_alloc = hvcs_parm_num_devs;
 
 	hvcs_tty_driver = alloc_tty_driver(num_ttys_to_alloc);
-	if (!hvcs_tty_driver)
+	if (!hvcs_tty_driver) {
+		mutex_unlock(&hvcs_init_mutex);
 		return -ENOMEM;
+	}
 
 	if (hvcs_alloc_index_list(num_ttys_to_alloc)) {
 		rc = -ENOMEM;



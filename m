Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756290Ab2ICKJz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 06:09:55 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:55567 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756223Ab2ICKJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 06:09:54 -0400
MIME-Version: 1.0
Date: Mon, 3 Sep 2012 18:09:53 +0800
Message-ID: <CAPgLHd-Ma1Ljzsfo1_G7D8AyrXkPfBbY57RfW4Y0hh6k5=f_Dw@mail.gmail.com>
Subject: [PATCH] parport: fix possible memory leak in parport_gsc_probe_port()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: gregkh@suse.de, willy@parisc-linux.org, kyle@parisc-linux.org
Cc: yongjun_wei@trendmicro.com.cn, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

ops has been allocated in this function and should be freed
before leaving from the error handling cases.

spatch with a semantic match is used to found this problem.
(http://coccinelle.lip6.fr/)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/parport/parport_gsc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/parport/parport_gsc.c b/drivers/parport/parport_gsc.c
index 5d6de38..352f961 100644
--- a/drivers/parport/parport_gsc.c
+++ b/drivers/parport/parport_gsc.c
@@ -271,6 +271,7 @@ struct parport *__devinit parport_gsc_probe_port (unsigned long base,
 	if (!parport_SPP_supported (p)) {
 		/* No port. */
 		kfree (priv);
+		kfree(ops);
 		return NULL;
 	}
 	parport_PS2_supported (p);



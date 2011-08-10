Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752191Ab1HJACk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 20:02:40 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:44674 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751393Ab1HJACj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 20:02:39 -0400
From: Nishanth Aravamudan <nacc@us.ibm.com>
To: "Fabio M . Di Nitto" <fabbione@fabbione.net>
Cc: linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <gregkh@suse.de>
Subject: [PATCH] kernel/printk: do not turn off bootconsole in printk_late_init if keep_bootcon
Date: Tue,  9 Aug 2011 17:02:33 -0700
Message-Id: <1312934553-17085-1-git-send-email-nacc@us.ibm.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It seems that commit 7bf693951a8e5f7e600a45b74d91d962a453146e doesn't
always achieve what it aims, as printk_late_init() runs it
unconditionally turns off all boot consoles. With this patch, I am able
to see more messages on the boot console in KVM guests than I can
without, when keep_bootcon is specified.

Signed-off-by: Nishanth Aravamudan <nacc@us.ibm.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Greg KH <gregkh@suse.de>
---
 kernel/printk.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/printk.c b/kernel/printk.c
index 37dff34..293a6cc 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -1602,7 +1602,7 @@ static int __init printk_late_init(void)
 	struct console *con;
 
 	for_each_console(con) {
-		if (con->flags & CON_BOOT) {
+		if (!keep_bootcon && con->flags & CON_BOOT) {
 			printk(KERN_INFO "turn off boot console %s%d\n",
 				con->name, con->index);
 			unregister_console(con);
-- 
1.7.4.1


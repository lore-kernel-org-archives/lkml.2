Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755732Ab2DJIfh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 04:35:37 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:53295 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752222Ab2DJIfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 04:35:36 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Karsten Keil <isdn@linux-pingi.de>
Subject: [PATCH 1/1] ISDN: remove uses of isdn_tty_revision
Date: Tue, 10 Apr 2012 10:35:29 +0200
Message-Id: <1334046929-31282-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <20120410130637.d9aff141830a3eb71ff21440@canb.auug.org.au>
References: <20120410130637.d9aff141830a3eb71ff21440@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit "ISDN: i4l, remove cvs crap" removed definition of
isdn_tty_revision, but there is still a user. So this causes linking
errors. This was hidden from my radar because the variable was not
declared in any header. Instead isdn_common.c declares it locally.

So remove this variable also from isdn_common.c, because there is
really no way to find out the version. Git commit or tag is...

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Karsten Keil <isdn@linux-pingi.de>
---
 drivers/isdn/i4l/isdn_common.c |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/isdn/i4l/isdn_common.c b/drivers/isdn/i4l/isdn_common.c
index 2ffa0b73..8c610fa 100644
--- a/drivers/isdn/i4l/isdn_common.c
+++ b/drivers/isdn/i4l/isdn_common.c
@@ -46,7 +46,6 @@ static DEFINE_MUTEX(isdn_mutex);
 static char *isdn_revision = "$Revision: 1.1.2.3 $";
 
 extern char *isdn_net_revision;
-extern char *isdn_tty_revision;
 #ifdef CONFIG_ISDN_PPP
 extern char *isdn_ppp_revision;
 #else
@@ -2351,8 +2350,6 @@ static int __init isdn_init(void)
 
 	strcpy(tmprev, isdn_revision);
 	printk(KERN_NOTICE "ISDN subsystem Rev: %s/", isdn_getrev(tmprev));
-	strcpy(tmprev, isdn_tty_revision);
-	printk("%s/", isdn_getrev(tmprev));
 	strcpy(tmprev, isdn_net_revision);
 	printk("%s/", isdn_getrev(tmprev));
 	strcpy(tmprev, isdn_ppp_revision);
-- 
1.7.9.2



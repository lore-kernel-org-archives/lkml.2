Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754793Ab0EUNVP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 09:21:15 -0400
Received: from isilmar-3.linta.de ([188.40.101.200]:49040 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753874Ab0EUNVL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 09:21:11 -0400
Date: Fri, 21 May 2010 15:18:51 +0200
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH]pacmcia:yena_socket.c Remove extra #ifdef
 CONFIG_YENTA_TI
Message-ID: <20100521131851.GB22685@comet.dominikbrodowski.net>
Mail-Followup-To: "Justin P. Mattock" <justinmattock@gmail.com>,
	linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org
References: <1274388002-2132-1-git-send-email-justinmattock@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1274388002-2132-1-git-send-email-justinmattock@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Applied (see below), thanks.

Best,
	Dominik

From: Justin P. Mattock <justinmattock@gmail.com>
Date: Thu, 20 May 2010 13:40:02 -0700
Subject: [PATCH] pcmcia: yenta_socket.c Remove extra #ifdef CONFIG_YENTA_TI

Seems pointless to have two #ifdef's with the same
CONFIG_YENTA_TI.. Remove the extra one and
move CARDBUS_TYPE_ENE with the others.

[linux@dominikbrodowski.net: spelling & whitespace fixes]
Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
Signed-off-by: Dominik Brodowski <linux@dominikbrodowski.net>

diff --git a/drivers/pcmcia/yenta_socket.c b/drivers/pcmcia/yenta_socket.c
index 6bf8b2c..f1d4137 100644
--- a/drivers/pcmcia/yenta_socket.c
+++ b/drivers/pcmcia/yenta_socket.c
@@ -880,6 +880,12 @@ static struct cardbus_type cardbus_type[] = {
 		.restore_state	= ti_restore_state,
 		.sock_init	= ti_init,
 	},
+	[CARDBUS_TYPE_ENE]	= {
+		.override	= ene_override,
+		.save_state	= ti_save_state,
+		.restore_state	= ti_restore_state,
+		.sock_init	= ti_init,
+	},
 #endif
 #ifdef CONFIG_YENTA_RICOH
 	[CARDBUS_TYPE_RICOH]	= {
@@ -902,14 +908,6 @@ static struct cardbus_type cardbus_type[] = {
 		.restore_state	= o2micro_restore_state,
 	},
 #endif
-#ifdef CONFIG_YENTA_TI
-	[CARDBUS_TYPE_ENE]	= {
-		.override	= ene_override,
-		.save_state	= ti_save_state,
-		.restore_state	= ti_restore_state,
-		.sock_init	= ti_init,
-	},
-#endif
 };
 
 


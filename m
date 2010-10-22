Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757509Ab0JVPsU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 11:48:20 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:46079 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755380Ab0JVPsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 11:48:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=kpfwoldWA/lpe5L/n4gzY37eenhXKcqbHYGuTVAFz+FeyOY6IDjAgihVOT3QrbCnZD
         eumvm2PtMYdwOdaor24UP1LbFVrytJLXVUcc4eTGQZ0YyuvVsVSGea7wehpiwdHoXpjv
         BI9xcbdW9t+DkhqwKtD9ifHrJV7dh/Yf9m1B0=
From: Namhyung Kim <namhyung@gmail.com>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: linux-kbuild@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] kconfig: don't select 64 bit option on sparc32 all{yes,mod}config
Date: Sat, 23 Oct 2010 00:48:04 +0900
Message-Id: <1287762484-8154-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The SPARC architecture provides 64BIT config option to select
build type and it is set to 1 on ARCH=sparc64 as a default value.
But in case of 32-bit, it is also set to 1 by the allyesconfig
logic, end result would be the same as of sparc64. So I think
it would be better if plain ARCH=sparc all{yes,mod}config do not
set it then we can test 32-bit build by default.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 scripts/kconfig/confdata.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/scripts/kconfig/confdata.c b/scripts/kconfig/confdata.c
index 515253f..9820c77 100644
--- a/scripts/kconfig/confdata.c
+++ b/scripts/kconfig/confdata.c
@@ -1018,6 +1018,10 @@ void conf_set_all_new_symbols(enum conf_def_mode mode)
 			break;
 		}
 
+		/* Do not set 64 bit option when sparc32 allyesconfig */
+		if (sym->name && strcmp(sym->name, "64BIT") == 0 &&
+		    strcmp(getenv("ARCH"), "sparc") == 0)
+			sym->def[S_DEF_USER].tri = no;
 	}
 
 	sym_clear_all_valid();
-- 
1.7.0.4


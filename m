Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754044Ab1HNUul (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 16:50:41 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:40951 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753737Ab1HNUuU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 16:50:20 -0400
From: Sergei Trofimovich <slyfox@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: Sergei Trofimovich <slyfox@gentoo.org>,
        Marek Belisko <marek.belisko@gmail.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Ondrej Zary <linux@rainbow-software.org>, devel@driverdev.osuosl.org
Subject: [PATCH] staging: ft1000: fix build failure
Date: Sun, 14 Aug 2011 23:52:53 +0300
Message-Id: <1313355177-12605-3-git-send-email-slyfox@gentoo.org>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Found on allmodconfig build (ARCH=alpha)

    drivers/staging/ft1000/ft1000-pcmcia/ft1000.h: In function 'ft1000_read_reg':
    drivers/staging/ft1000/ft1000-pcmcia/ft1000.h:80: error: implicit declaration of function 'inw'
    drivers/staging/ft1000/ft1000-pcmcia/ft1000.h: In function 'ft1000_write_reg':
    drivers/staging/ft1000/ft1000-pcmcia/ft1000.h:86: error: implicit declaration of function 'outw'

Signed-off-by: Sergei Trofimovich <slyfox@gentoo.org>
Cc: Marek Belisko <marek.belisko@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Ondrej Zary <linux@rainbow-software.org>
Cc: devel@driverdev.osuosl.org
---
 drivers/staging/ft1000/ft1000-pcmcia/ft1000.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-pcmcia/ft1000.h b/drivers/staging/ft1000/ft1000-pcmcia/ft1000.h
index 3b0130f..c2f835f 100644
--- a/drivers/staging/ft1000/ft1000-pcmcia/ft1000.h
+++ b/drivers/staging/ft1000/ft1000-pcmcia/ft1000.h
@@ -19,6 +19,7 @@
 #ifndef _FT1000H_
 #define _FT1000H_
 
+#include <linux/io.h>
 #include "../ft1000.h"
 
 #define FT1000_DRV_VER 0x01010300
-- 
1.7.3.4


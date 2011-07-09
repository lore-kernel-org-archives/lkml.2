Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754908Ab1GIVaX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jul 2011 17:30:23 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:13394 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754647Ab1GIVaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jul 2011 17:30:20 -0400
Date: Sat, 9 Jul 2011 23:20:42 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: trivial@kernel.org, "Jean Delvare (PC drivers, core)" <khali@linux-fr.org>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        linux-i2c@vger.kernel.org
Subject: [PATCH 5/7] drivers/i2c: static should be at beginning of
 declaration
In-Reply-To: <alpine.LNX.2.00.1107092304160.25516@swampdragon.chaosbits.net>
Message-ID: <alpine.LNX.2.00.1107092318590.25516@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1107092304160.25516@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-986330640-1310246442=:25516"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-986330640-1310246442=:25516
Content-Type: TEXT/PLAIN; charset=ISO-8859-7
Content-Transfer-Encoding: 8BIT

Make sure that the 'static' keywork is at the beginning of declaration
for drivers/i2c/busses/i2c-omap.c

This gets rid of warnings like
  warning: ¡static¢ is not at beginning of declaration
when building with -Wold-style-declaration (and/or -Wextra which also
enables it).

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/i2c/busses/i2c-omap.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/i2c/busses/i2c-omap.c b/drivers/i2c/busses/i2c-omap.c
index 58a58c7..1a766cf 100644
--- a/drivers/i2c/busses/i2c-omap.c
+++ b/drivers/i2c/busses/i2c-omap.c
@@ -204,7 +204,7 @@ struct omap_i2c_dev {
 	u16			errata;
 };
 
-const static u8 reg_map[] = {
+static const u8 reg_map[] = {
 	[OMAP_I2C_REV_REG] = 0x00,
 	[OMAP_I2C_IE_REG] = 0x01,
 	[OMAP_I2C_STAT_REG] = 0x02,
@@ -225,7 +225,7 @@ const static u8 reg_map[] = {
 	[OMAP_I2C_BUFSTAT_REG] = 0x10,
 };
 
-const static u8 omap4_reg_map[] = {
+static const u8 omap4_reg_map[] = {
 	[OMAP_I2C_REV_REG] = 0x04,
 	[OMAP_I2C_IE_REG] = 0x2c,
 	[OMAP_I2C_STAT_REG] = 0x28,
-- 
1.7.6


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

--8323328-986330640-1310246442=:25516--

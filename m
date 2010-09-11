Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752587Ab0IKNhA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Sep 2010 09:37:00 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:64062 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752194Ab0IKNg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Sep 2010 09:36:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=GYGV9GGDGfIXcDbcARtgMn0uVV46vP9hus9T70H0vYlhcCqeCRwmDJ/uf0++WcAJKK
         4niU/LJfUAo/dk0SittjqbTxMTsG/J5ISnCpYT4tyBhpFFtGtr68jzOR1pO0+XEsBZCl
         sm+BlWSe3d2bDuv2BnqV91PAuFA10gupBpvak=
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux390@de.ibm.com,
        linux-s390@vger.kernel.org
Subject: [PATCH] drivers: s390: remove custom implementation of hex_to_bin()
Date: Sat, 11 Sep 2010 16:36:38 +0300
Message-Id: <1284212198-25849-1-git-send-email-andy.shevchenko@gmail.com>
X-Mailer: git-send-email 1.7.2.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: linux390@de.ibm.com
Cc: linux-s390@vger.kernel.org
---
 drivers/s390/cio/blacklist.c |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/s390/cio/blacklist.c b/drivers/s390/cio/blacklist.c
index 13cb601..76058a5 100644
--- a/drivers/s390/cio/blacklist.c
+++ b/drivers/s390/cio/blacklist.c
@@ -79,17 +79,15 @@ static int pure_hex(char **cp, unsigned int *val, int min_digit,
 		    int max_digit, int max_val)
 {
 	int diff;
-	unsigned int value;
 
 	diff = 0;
 	*val = 0;
 
-	while (isxdigit(**cp) && (diff <= max_digit)) {
+	while (diff <= max_digit) {
+		int value = hex_to_bin(**cp);
 
-		if (isdigit(**cp))
-			value = **cp - '0';
-		else
-			value = tolower(**cp) - 'a' + 10;
+		if (value < 0)
+			break;
 		*val = *val * 16 + value;
 		(*cp)++;
 		diff++;
-- 
1.7.2.2


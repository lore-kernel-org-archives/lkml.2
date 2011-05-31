Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752545Ab1EaJvc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 05:51:32 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52956 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751875Ab1EaJvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 05:51:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=QGJ1zSnQvIpRuF/JeLzeTQmaqgLuIfDYRdRJurXAahdvANqX70VJJi+RSUDW0ySrWy
         DGOhxEedW+Sy9PLARh76WCqDfoAzbe/NdUbbs4JzTKeYpoiVV3kYO3vovO2N8zRvD50d
         TbJWJIMs7/Ogbxl8FRiFG/G9ZfDt1z+uOK7Uk=
From: Andre Bartke <andre.bartke@googlemail.com>
To: tglx@linutronix.de
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Andre Bartke <andre.bartke@gmail.com>
Subject: [PATCH] x86: boot/compressed fix resource leak
Date: Tue, 31 May 2011 11:50:57 +0200
Message-Id: <1306835457-5562-1-git-send-email-andre.bartke@gmail.com>
X-Mailer: git-send-email 1.7.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case fread() fails, we should call fclose
and release the resource properly. Also while at it,
fixed brace coding style issue.

Signed-off-by: Andre Bartke <andre.bartke@gmail.com>
---
 arch/x86/boot/compressed/mkpiggy.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/x86/boot/compressed/mkpiggy.c b/arch/x86/boot/compressed/mkpiggy.c
index 46a8238..33b85be 100644
--- a/arch/x86/boot/compressed/mkpiggy.c
+++ b/arch/x86/boot/compressed/mkpiggy.c
@@ -58,13 +58,12 @@ int main(int argc, char *argv[])
 		return 1;
 	}
 
-
-	if (fseek(f, -4L, SEEK_END)) {
+	if (fseek(f, -4L, SEEK_END))
 		perror(argv[1]);
-	}
 
 	if (fread(&olen, sizeof(olen), 1, f) != 1) {
 		perror(argv[1]);
+		fclose(f);
 		return 1;
 	}
 
-- 
1.7.5.2


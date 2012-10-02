Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932196Ab2JBQlM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 12:41:12 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:53866 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755088Ab2JBQhQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 12:37:16 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@infradead.org
Cc: arm@kernel.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Eric Miao <eric.y.miao@gmail.com>, Marc Zyngier <maz@misterjones.org>
Subject: [PATCH 03/17] ARM: pxa: Wunused-result warning in viper board file
Date: Tue,  2 Oct 2012 18:36:42 +0200
Message-Id: <1349195816-2225-4-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1349195816-2225-1-git-send-email-arnd@arndb.de>
References: <1349195816-2225-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:usoFP0SOu5ILcy84ibuD3ciuJc8x3lRXwcYrvJo2XlC
 rAL1qz4eUhFJpoCpWUX4OHB/aWhyxn0ir0gu2FvXHxSh/RDPpF
 EHUtA8MvIo23zN4bIffFEYyyhPgA27aknQ+HQKL+mYViqxZLh0
 0K/W/WBwPUNn6N6oEJ0a+BbqZ0lflcbQESXVC1KP8V2nnrwKy9
 IKk/zYk20F/3xdooPPRFE3+N8oWOOKn3XxWo9zus6ifdZM3G8Z
 Ab9tXMWJIalINGgan+cInLqp54He0ApyhRQjwovt08lxHM6TGT
 XMNAUJyKSToysi13WqbFXNQlf5bhbVVunlVXWKeL+kM6GPKLGk
 2av89UDUg9dRUpM27DxXdJJphVXJucJdrXHjw1ng0Kz+mjefHF
 IdzPAGlWem20w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Calling kstrtoul requires checking the result. In case of
the viper_tpm_setup function, let's fail the __setup function
if the number was invalid.

Without this patch, building viper_defconfig results in:

arch/arm/mach-pxa/viper.c: In function 'viper_tpm_setup':
arch/arm/mach-pxa/viper.c:771:10: warning: ignoring return value of 'kstrtoul', declared with attribute warn_unused_result [-Wunused-result]

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>
Cc: Eric Miao <eric.y.miao@gmail.com>
Cc: Marc Zyngier <maz@misterjones.org>
---
 arch/arm/mach-pxa/viper.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/arm/mach-pxa/viper.c b/arch/arm/mach-pxa/viper.c
index 130379f..ac733e9 100644
--- a/arch/arm/mach-pxa/viper.c
+++ b/arch/arm/mach-pxa/viper.c
@@ -768,8 +768,7 @@ static unsigned long viper_tpm;
 
 static int __init viper_tpm_setup(char *str)
 {
-	strict_strtoul(str, 10, &viper_tpm);
-	return 1;
+	return strict_strtoul(str, 10, &viper_tpm) >= 0;
 }
 
 __setup("tpm=", viper_tpm_setup);
-- 
1.7.10


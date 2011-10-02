Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752746Ab1JBOq6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Oct 2011 10:46:58 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:54623 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752629Ab1JBOqv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Oct 2011 10:46:51 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Tony Lindgren <tony@atomide.com>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Jarkko Nikula <jarkko.nikula@bitmer.com>
Subject: [PATCH 01/30] sound/omap: omap_mcpdm_remove cannot be __devexit
Date: Sun,  2 Oct 2011 16:45:31 +0200
Message-Id: <1317566760-25681-2-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1317566760-25681-1-git-send-email-arnd@arndb.de>
References: <1317566760-25681-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:IoM3lQEgjExAIL8VpE34qX7ENoJCfonV+nIFGDA3DkW
 B6qhvpaFyShqb7D1IkOENH/kO25tOnXGYxuNTDgKPmjHOrFaLb
 X0lfwTs2MG39b7WeGlQLEYFrQrsNesF5uZteCnAEr9OuLMsIJ7
 +e6sFLkobFczS58BDvIQuHzR7S+hlVa0ZKaOoCdykDBFKBCKgF
 BcDStOEyERsw9dZkuEpOLDZ3cxAhAV8+yDHz/SQnguPsS9qYfq
 XjQEzwyWVaqyY5O9KKjjOQbipdzt45cDcw17i7wJuho2sSm6YX
 uozlc9PWi/JTZXlDHgtpGk99iZcJBw8KGZnHNto7f5Qir9mYHh
 DhQpPdV4wrGngx7RLHo5OGPF6J86dgl57POmvnG2RYEO6AzWOG
 6KaV2TPmnLALg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

omap_mcpdm_remove is used from asoc_mcpdm_probe, which is an
initcall, and must not be discarded when HOTPLUG is disabled.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Jarkko Nikula <jarkko.nikula@bitmer.com>
---
 sound/soc/omap/mcpdm.c |    2 +-
 sound/soc/omap/mcpdm.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/omap/mcpdm.c b/sound/soc/omap/mcpdm.c
index 928f037..50e59194 100644
--- a/sound/soc/omap/mcpdm.c
+++ b/sound/soc/omap/mcpdm.c
@@ -449,7 +449,7 @@ exit:
 	return ret;
 }
 
-int __devexit omap_mcpdm_remove(struct platform_device *pdev)
+int omap_mcpdm_remove(struct platform_device *pdev)
 {
 	struct omap_mcpdm *mcpdm_ptr = platform_get_drvdata(pdev);
 
diff --git a/sound/soc/omap/mcpdm.h b/sound/soc/omap/mcpdm.h
index df3e16f..20c20a8 100644
--- a/sound/soc/omap/mcpdm.h
+++ b/sound/soc/omap/mcpdm.h
@@ -150,4 +150,4 @@ extern int omap_mcpdm_request(void);
 extern void omap_mcpdm_free(void);
 extern int omap_mcpdm_set_offset(int offset1, int offset2);
 int __devinit omap_mcpdm_probe(struct platform_device *pdev);
-int __devexit omap_mcpdm_remove(struct platform_device *pdev);
+int omap_mcpdm_remove(struct platform_device *pdev);
-- 
1.7.5.4


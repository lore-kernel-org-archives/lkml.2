Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759557Ab2CTIyR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 04:54:17 -0400
Received: from smtp5.tech.numericable.fr ([82.216.111.41]:39076 "EHLO
	smtp5.tech.numericable.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964801Ab2CTIyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 04:54:06 -0400
From: Corentin Chary <corentin.chary@gmail.com>
To: Matthew Garrett <mjg@redhat.com>
Cc: platform-driver-x86@vger.kernel.org, David Rientjes <rientjes@google.com>,
        Corentin Chary <corentincj@iksaif.net>, linux-kernel@vger.kernel.org
Subject: [PATCH 05/14] drivers, samsung-laptop: fix initialization of sabi_data in sabi_set_commandb
Date: Tue, 20 Mar 2012 09:53:05 +0100
Message-Id: <1332233594-13099-6-git-send-email-corentin.chary@gmail.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1332233594-13099-1-git-send-email-corentin.chary@gmail.com>
References: <1332233594-13099-1-git-send-email-corentin.chary@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeegvddrgeejucetggdotefuucfrrhhofhhilhgvmecupfgfoffgtffkveetuefngfenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddm
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Rientjes <rientjes@google.com>

Fields d0, d1, d2, and d3 are members of an anonymous struct inside an
anonymous union inside struct sabi_data.  Initialization must be done by
wrapping the anonymous union and structs with brackets to avoid a build
error:

drivers/platform/x86/samsung-laptop.c: In function ‘sabi_set_commandb’:
drivers/platform/x86/samsung-laptop.c:433: error: unknown field ‘d0’ specified in initializer
drivers/platform/x86/samsung-laptop.c:433: warning: missing braces around initializer
drivers/platform/x86/samsung-laptop.c:433: warning: (near initialization for ‘in.<anonymous>’)
...

Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Corentin Chary <corentincj@iksaif.net>
---
 drivers/platform/x86/samsung-laptop.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/platform/x86/samsung-laptop.c b/drivers/platform/x86/samsung-laptop.c
index 7d7109f..b7c67c8 100644
--- a/drivers/platform/x86/samsung-laptop.c
+++ b/drivers/platform/x86/samsung-laptop.c
@@ -430,7 +430,7 @@ exit:
 static int sabi_set_commandb(struct samsung_laptop *samsung,
 			     u16 command, u8 data)
 {
-	struct sabi_data in = { .d0 = 0, .d1 = 0, .d2 = 0, .d3 = 0 };
+	struct sabi_data in = { { { .d0 = 0, .d1 = 0, .d2 = 0, .d3 = 0 } } };
 
 	in.data[0] = data;
 	return sabi_command(samsung, command, &in, NULL);
-- 
1.7.3.4


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759495Ab2CTIyN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 04:54:13 -0400
Received: from smtp5.tech.numericable.fr ([82.216.111.41]:39075 "EHLO
	smtp5.tech.numericable.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964966Ab2CTIyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 04:54:06 -0400
From: Corentin Chary <corentin.chary@gmail.com>
To: Matthew Garrett <mjg@redhat.com>
Cc: platform-driver-x86@vger.kernel.org, David Rientjes <rientjes@google.com>,
        Corentin Chary <corentincj@iksaif.net>, linux-kernel@vger.kernel.org
Subject: [PATCH 06/14] drivers, samsung-laptop: fix usage of isalnum
Date: Tue, 20 Mar 2012 09:53:06 +0100
Message-Id: <1332233594-13099-7-git-send-email-corentin.chary@gmail.com>
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

linux/ctype.h is needed for isalnum() to avoid a build error:

drivers/platform/x86/samsung-laptop.c: In function ‘samsung_sabi_diag’:
drivers/platform/x86/samsung-laptop.c:1306: error: implicit declaration of function ‘isalnum’

Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Corentin Chary <corentincj@iksaif.net>
---
 drivers/platform/x86/samsung-laptop.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/platform/x86/samsung-laptop.c b/drivers/platform/x86/samsung-laptop.c
index b7c67c8..d1142e3 100644
--- a/drivers/platform/x86/samsung-laptop.c
+++ b/drivers/platform/x86/samsung-laptop.c
@@ -25,6 +25,7 @@
 #include <linux/acpi.h>
 #include <linux/seq_file.h>
 #include <linux/debugfs.h>
+#include <linux/ctype.h>
 
 /*
  * This driver is needed because a number of Samsung laptops do not hook
-- 
1.7.3.4


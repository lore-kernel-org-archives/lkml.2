Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757493Ab0ESKhn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 06:37:43 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:38360 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757404Ab0ESKhk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 06:37:40 -0400
From: Daniel Mack <daniel@caiaq.de>
To: linux-kernel@vger.kernel.org
Cc: Daniel Mack <daniel@caiaq.de>, Matthew Garrett <mjg@redhat.com>,
       Yong Wang <yong.y.wang@intel.com>,
       Corentin Chary <corentincj@iksaif.net>, Dmitry Torokhov <dtor@mail.ru>,
       Tejun Heo <tj@kernel.org>, platform-driver-x86@vger.kernel.org
Subject: [PATCH] drivers/platform/x86/eeepc-wmi.c: fix build warning
Date: Wed, 19 May 2010 12:37:01 +0200
Message-Id: <1274265421-26747-1-git-send-email-daniel@caiaq.de>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/platform/x86/eeepc-wmi.c: In function ‘eeepc_wmi_notify’:
drivers/platform/x86/eeepc-wmi.c:209: warning: ‘new’ may be used uninitialized in this function
drivers/platform/x86/eeepc-wmi.c:209: note: ‘new’ was declared here

Signed-off-by: Daniel Mack <daniel@caiaq.de>
Cc: Matthew Garrett <mjg@redhat.com>
Cc: Yong Wang <yong.y.wang@intel.com>
Cc: Corentin Chary <corentincj@iksaif.net>
Cc: Dmitry Torokhov <dtor@mail.ru>
Cc: Tejun Heo <tj@kernel.org>
Cc: platform-driver-x86@vger.kernel.org
---
 drivers/platform/x86/eeepc-wmi.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/platform/x86/eeepc-wmi.c b/drivers/platform/x86/eeepc-wmi.c
index b227eb4..9dc50fb 100644
--- a/drivers/platform/x86/eeepc-wmi.c
+++ b/drivers/platform/x86/eeepc-wmi.c
@@ -206,7 +206,7 @@ static int eeepc_wmi_backlight_notify(struct eeepc_wmi *eeepc, int code)
 {
 	struct backlight_device *bd = eeepc->backlight_device;
 	int old = bd->props.brightness;
-	int new;
+	int new = old;
 
 	if (code >= NOTIFY_BRNUP_MIN && code <= NOTIFY_BRNUP_MAX)
 		new = code - NOTIFY_BRNUP_MIN + 1;
-- 
1.7.1


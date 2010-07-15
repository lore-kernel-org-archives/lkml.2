Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932959Ab0GOJti (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 05:49:38 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:63220 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932874Ab0GOJth (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 05:49:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=qonkAnvtngyt6Yk2AaQPVIhuCpvTMShlpuK6H1KRTa33nAOYgHFrQcs6FlSebmB855
         wY0LaEx89WvY0u5IlB8PZVl0H5F0BF8bBeJarNbwkgY7TYgfrZ5hehU+V3Iaiq2U8wps
         9SseQYr6DHGogXrPTlncooHUT7STh6aB1wiMU=
From: Jike Song <albcamus@gmail.com>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, huangweibing@gmail.com,
        Jike Song <albcamus@gmail.com>
Subject: [PATCH] driver core: fix possible memory leak in bus_register()
Date: Thu, 15 Jul 2010 17:43:54 +0800
Message-Id: <1279187034-11826-1-git-send-email-albcamus@gmail.com>
X-Mailer: git-send-email 1.6.4.GIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reported-by: huangweibing@gmail.com
Signed-off-by: Jike Song <albcamus@gmail.com>
---
 drivers/base/bus.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/base/bus.c b/drivers/base/bus.c
index 12eec3f..eb1b7fa 100644
--- a/drivers/base/bus.c
+++ b/drivers/base/bus.c
@@ -945,8 +945,8 @@ bus_devices_fail:
 	bus_remove_file(bus, &bus_attr_uevent);
 bus_uevent_fail:
 	kset_unregister(&bus->p->subsys);
-	kfree(bus->p);
 out:
+	kfree(bus->p);
 	bus->p = NULL;
 	return retval;
 }
-- 
1.6.4.GIT


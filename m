Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752638Ab0LGPEZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 10:04:25 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:49804 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832Ab0LGPEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 10:04:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=Wn5dUNsUFzIsSAu8BVwFUOPzMqmrgtiOTVAKTeFa2TMooqnHgH3QxRi9q0ogR7nYkx
         5P4QiG2pahARsErBkY7jvthbiTwbTMGqbwLLy7/STDxCJWzGRK8N2XL5MlEhBq8zn3XC
         7tVC94TFUSz+/WO1FSPGiC0uzu5SALMvzZpvE=
From: Namhyung Kim <namhyung@gmail.com>
To: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>,
        Matthew Garrett <mjg@redhat.com>
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] fujitsu-laptop: fix compiler warning on pnp_ids
Date: Wed,  8 Dec 2010 00:04:14 +0900
Message-Id: <1291734254-12250-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Annotate pnp_ids as '__used' to fix following warning:

  CC      drivers/platform/x86/fujitsu-laptop.o
drivers/platform/x86/fujitsu-laptop.c:1243: warning: ‘pnp_ids’ defined but not used

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 drivers/platform/x86/fujitsu-laptop.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/platform/x86/fujitsu-laptop.c b/drivers/platform/x86/fujitsu-laptop.c
index f44cd26..ad88b2e 100644
--- a/drivers/platform/x86/fujitsu-laptop.c
+++ b/drivers/platform/x86/fujitsu-laptop.c
@@ -1240,7 +1240,7 @@ MODULE_ALIAS("dmi:*:svnFUJITSUSIEMENS:*:pvr:rvnFUJITSU:rnFJNB1D3:*:cvrS6410:*");
 MODULE_ALIAS("dmi:*:svnFUJITSUSIEMENS:*:pvr:rvnFUJITSU:rnFJNB1E6:*:cvrS6420:*");
 MODULE_ALIAS("dmi:*:svnFUJITSU:*:pvr:rvnFUJITSU:rnFJNB19C:*:cvrS7020:*");
 
-static struct pnp_device_id pnp_ids[] = {
+static struct pnp_device_id pnp_ids[] __used = {
 	{.id = "FUJ02bf"},
 	{.id = "FUJ02B1"},
 	{.id = "FUJ02E3"},
-- 
1.7.0.4


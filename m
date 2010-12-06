Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753076Ab0LFOBl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 09:01:41 -0500
Received: from mail-fx0-f66.google.com ([209.85.161.66]:34779 "EHLO
	mail-fx0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752542Ab0LFOBk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 09:01:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=a983n//XWCQvEV+YyMKtzQlnAXAB2ZTyjI2Uc80Tl5Cqa1luZF0IkxGi37pztEBpDR
         C0ZiW6TZdRrhAjGlJhAK6lVXqY5dbSI/2FsTO/5DKpSFQNTzQSDFRZJwKzGvMHjEG+ke
         6M9jrfJZlys6SXGjpySHO6NqR6urLV0BV8PRs=
From: Marek Belisko <marek.belisko@open-nandra.com>
To: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@open-nandra.com>
Subject: [PATCH] arm: ecard: Fix compilation warning.
Date: Mon,  6 Dec 2010 15:04:03 +0100
Message-Id: <1291644243-23540-1-git-send-email-marek.belisko@open-nandra.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix following compilation warning:
arch/arm/kernel/ecard.c:1066: warning: ignoring return value of
'device_register', declared with attribute warn_unused_result

Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
---
 arch/arm/kernel/ecard.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/arm/kernel/ecard.c b/arch/arm/kernel/ecard.c
index eed2f79..da882b1 100644
--- a/arch/arm/kernel/ecard.c
+++ b/arch/arm/kernel/ecard.c
@@ -1063,8 +1063,10 @@ ecard_probe(int slot, card_type_t type)
 	*ecp = ec;
 	slot_to_expcard[slot] = ec;
 
-	device_register(&ec->dev);
-
+	rc = device_register(&ec->dev);
+	if (rc)
+		goto nodev;
+
 	return 0;
 
  nodev:
-- 
1.7.1


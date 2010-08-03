Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754805Ab0HCE0m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 00:26:42 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:36392 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400Ab0HCE0g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 00:26:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=di8f7MxYq98AC2PnOxWcwKXXrZMMLwK/itDMnCzpsyPIDAbgDetT0zlxGUesYYj/tf
         ihhjVVzmKN5oNuV4m6YZCTByCnJiBlyJHwLXZ3wODpAQGE4gkRM73x8dwEa5OvsbStQc
         ZT+hlrspXuU20ehlQsrPhG5Ym05EOPH3cZduo=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: linux-usb@vger.kernel.org
Cc: dbrownell@users.sourceforge.net, gregkh@suse.de,
        linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 2/2]drivers/usb/host/ehci-hub.c Fix variable 'i' set but not used
Date: Mon,  2 Aug 2010 21:26:29 -0700
Message-Id: <1280809589-23649-2-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
In-Reply-To: <1280809589-23649-1-git-send-email-justinmattock@gmail.com>
References: <1280809589-23649-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The below fixes a build warning from GCC:

drivers/usb/host/ehci-hub.c: In function 'create_companion_file':
drivers/usb/host/ehci-hub.c:533:6: warning: variable 'i' set but not used

Let me know if these are totally wrong etc.. And I'll try
my best to resend properly..

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/usb/host/ehci-hub.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/host/ehci-hub.c b/drivers/usb/host/ehci-hub.c
index e7d3d8d..dc7290f 100644
--- a/drivers/usb/host/ehci-hub.c
+++ b/drivers/usb/host/ehci-hub.c
@@ -530,11 +530,10 @@ static DEVICE_ATTR(companion, 0644, show_companion, store_companion);
 
 static inline void create_companion_file(struct ehci_hcd *ehci)
 {
-	int	i;
 
 	/* with integrated TT there is no companion! */
 	if (!ehci_is_TDI(ehci))
-		i = device_create_file(ehci_to_hcd(ehci)->self.controller,
+		device_create_file(ehci_to_hcd(ehci)->self.controller,
 				       &dev_attr_companion);
 }
 
-- 
1.7.1.rc1.21.gf3bd6


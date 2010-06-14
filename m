Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755811Ab0FNU05 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 16:26:57 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:43718 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755730Ab0FNU0x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 16:26:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=sxCHVEB5KBOpUf10byrtsi/mKuYJPR7Vk39zVKeUT8b37gE3xQKPx8RCxp6M5sXDVP
         2TG8ESIZccIfgRf5369teRNsEQ2qsH13/wWny8BmxsfdpIyCDY6D9Fd0+WSF2vLr1vVz
         M3hPIY/aqDj8dLuXkAB/Mjqx793Y4y4kmfC0w=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: reiserfs-devel@vger.kernel.org, linux-bluetooth@vger.kernel.org,
       clemens@ladisch.de, debora@linux.vnet.ibm.com,
       dri-devel@lists.freedesktop.org, linux-i2c@vger.kernel.org,
       linux1394-devel@lists.sourceforge.net, linux-media@vger.kernel.org,
       "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 3/8]char/hpet.c Fix variable 'hpet' set but not used
Date: Mon, 14 Jun 2010 13:26:43 -0700
Message-Id: <1276547208-26569-4-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
In-Reply-To: <1276547208-26569-1-git-send-email-justinmattock@gmail.com>
References: <1276547208-26569-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The below fixes this warning:
drivers/char/hpet.c: In function 'hpet_ioctl_common':
drivers/char/hpet.c:559:23: warning: variable 'hpet' set but not used

please have a look.
 Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/char/hpet.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/char/hpet.c b/drivers/char/hpet.c
index a0a1829..7932858 100644
--- a/drivers/char/hpet.c
+++ b/drivers/char/hpet.c
@@ -556,7 +556,6 @@ static int
 hpet_ioctl_common(struct hpet_dev *devp, int cmd, unsigned long arg, int kernel)
 {
 	struct hpet_timer __iomem *timer;
-	struct hpet __iomem *hpet;
 	struct hpets *hpetp;
 	int err;
 	unsigned long v;
@@ -568,7 +567,6 @@ hpet_ioctl_common(struct hpet_dev *devp, int cmd, unsigned long arg, int kernel)
 	case HPET_DPI:
 	case HPET_IRQFREQ:
 		timer = devp->hd_timer;
-		hpet = devp->hd_hpet;
 		hpetp = devp->hd_hpets;
 		break;
 	case HPET_IE_ON:
-- 
1.7.1.rc1.21.gf3bd6


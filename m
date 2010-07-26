Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753929Ab0GZI1M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 04:27:12 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:41604 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752127Ab0GZI1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 04:27:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=DkkQjXhLJCb6cybRmSCcRxOdapvDYOpQA7g5aeyncBvy6iGiMkFX3I7Dgio5Jff+ak
         3RO+zd0R2NiWaFOGsWcvYbkS+qw8+3Nrq2EK9NbdOELWuMiqGDzbcWAxTMjITSH5CSeL
         vLEOd33Nzok0KnuYqWoDRTWK/ZOxKCJ0Se8jo=
From: Kulikov Vasiliy <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Tejun Heo <tj@kernel.org>,
        Martin Fuzzey <mfuzzey@gmail.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] usb: imx21-hcd: set task state with schedule_timeout_uninterruptible()
Date: Mon, 26 Jul 2010 12:26:22 +0400
Message-Id: <1280132783-8182-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

imx21_hc_reset() uses schedule_timeout() without setting state to
STATE_(UN)INTERRUPTIBLE. As it is called in cycle without checking of
pending signals, use schedule_timeout_uninterruptible().

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 drivers/usb/host/imx21-hcd.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/host/imx21-hcd.c b/drivers/usb/host/imx21-hcd.c
index ca0e98d..3e56303 100644
--- a/drivers/usb/host/imx21-hcd.c
+++ b/drivers/usb/host/imx21-hcd.c
@@ -1521,7 +1521,7 @@ static int imx21_hc_reset(struct usb_hcd *hcd)
 			return -ETIMEDOUT;
 		}
 		spin_unlock_irq(&imx21->lock);
-		schedule_timeout(1);
+		schedule_timeout_uninterruptible(1);
 		spin_lock_irq(&imx21->lock);
 	}
 	spin_unlock_irqrestore(&imx21->lock, flags);
-- 
1.7.0.4


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754607Ab0JNErr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 00:47:47 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:49091 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754502Ab0JNErq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 00:47:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=IvEvMH390zH2s/RZQXUdOBWuyY8Jcgrfwr6zqdrlUWUSKYbj9PHY8UgIhxQjA8jxms
         Aui6lgogTvhle5HHIkUDl65jbajM1643tY6anAMYRP7TS3ifBfxEs/WHaB3gwQivO2ta
         AI7Ydal1BJqlmfjBfR/qBHBpUB6k8yMo81UCc=
From: =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <zenczykowski@gmail.com>
To: Dominik Brodowski <linux@dominikbrodowski.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <zenczykowski@gmail.com>
Subject: [PATCH] pcmcia: fix unused function compile warning
Date: Wed, 13 Oct 2010 21:47:14 -0700
Message-Id: <1287031634-25284-1-git-send-email-zenczykowski@gmail.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pcmcia_socket_dev_resume() is only referenced from macro
SET_SYSTEM_SLEEP_PM_OPS(NULL, pcmcia_socket_dev_resume)
which based on CONFIG_PM_SLEEP may or may not actually
use its second parameter.

Signed-off-by: Maciej Żenczykowski <zenczykowski@gmail.com>
---
 drivers/pcmcia/cs.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/pcmcia/cs.c b/drivers/pcmcia/cs.c
index 2ec8ac9..1aaa4a9 100644
--- a/drivers/pcmcia/cs.c
+++ b/drivers/pcmcia/cs.c
@@ -845,7 +845,7 @@ static int pcmcia_socket_dev_resume_noirq(struct device *dev)
 	return __pcmcia_pm_op(dev, socket_early_resume);
 }
 
-static int pcmcia_socket_dev_resume(struct device *dev)
+static int __used pcmcia_socket_dev_resume(struct device *dev)
 {
 	return __pcmcia_pm_op(dev, socket_late_resume);
 }
-- 
1.7.1


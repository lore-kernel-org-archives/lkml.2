Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757695Ab1GKOYo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 10:24:44 -0400
Received: from mailrelay009.isp.belgacom.be ([195.238.6.176]:62244 "EHLO
	mailrelay009.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751151Ab1GKOYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 10:24:41 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAJMFG05tg34q/2dsb2JhbABTpzl4iHy/QA6GLASSVJBJ
Date: Mon, 11 Jul 2011 16:24:39 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: LKML <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 11/11] watchdog: WatchDog Timer Driver Core - Remove llseek
Message-ID: <1310392522-9949-11-git-send-email-wim@iguana.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1310392522-9949-1-git-send-email-wim@iguana.be>
X-Mailer: git-send-email 1.7.6
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No need to set no_llseek any more since it's the default now.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
---
 drivers/watchdog/watchdog_dev.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/watchdog/watchdog_dev.c b/drivers/watchdog/watchdog_dev.c
index f6aa4b5..30a1d36 100644
--- a/drivers/watchdog/watchdog_dev.c
+++ b/drivers/watchdog/watchdog_dev.c
@@ -338,7 +338,6 @@ static int watchdog_release(struct inode *inode, struct file *file)
 
 static const struct file_operations watchdog_fops = {
 	.owner		= THIS_MODULE,
-	.llseek		= no_llseek,
 	.write		= watchdog_write,
 	.unlocked_ioctl	= watchdog_ioctl,
 	.open		= watchdog_open,
-- 
1.7.6


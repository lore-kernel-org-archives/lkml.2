Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754793Ab1ABHfq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:35:46 -0500
Received: from mail.windriver.com ([147.11.1.11]:36990 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754778Ab1ABHZW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:25:22 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Vasiliy Kulikov <segooon@gmail.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 222/260] pcmcia: synclink_cs: fix information leak to userland
Date: Sun,  2 Jan 2011 02:18:38 -0500
Message-Id: <1293952756-15010-223-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:24:12.0276 (UTC) FILETIME=[0D9D1340:01CBAA4E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vasiliy Kulikov <segooon@gmail.com>

commit 5b917a1420d3d1a9c8da49fb0090692dc9aaee86 upstream.

Structure new_line is copied to userland with some padding fields unitialized.
It leads to leaking of stack memory.

Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
Signed-off-by: Dominik Brodowski <linux@dominikbrodowski.net>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/char/pcmcia/synclink_cs.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/char/pcmcia/synclink_cs.c b/drivers/char/pcmcia/synclink_cs.c
index c31a0d9..1165503 100644
--- a/drivers/char/pcmcia/synclink_cs.c
+++ b/drivers/char/pcmcia/synclink_cs.c
@@ -4144,6 +4144,8 @@ static int hdlcdev_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 	if (cmd != SIOCWANDEV)
 		return hdlc_ioctl(dev, ifr, cmd);
 
+	memset(&new_line, 0, size);
+
 	switch(ifr->ifr_settings.type) {
 	case IF_GET_IFACE: /* return current sync_serial_settings */
 
-- 
1.7.3.3


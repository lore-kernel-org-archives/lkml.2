Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754034Ab0DTJLg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 05:11:36 -0400
Received: from mail200.messagelabs.com ([216.82.254.195]:16130 "EHLO
	mail200.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753833Ab0DTJLf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 05:11:35 -0400
X-VirusChecked: Checked
X-Env-Sender: Hector.Palacios@digi.com
X-Msg-Ref: server-14.tower-200.messagelabs.com!1271754694!57313694!1
X-StarScan-Version: 6.2.4; banners=-,-,-
X-Originating-IP: [66.77.174.13]
From: Hector Palacios <hector.palacios@digi.com>
To: <dbrownell@users.sourceforge.net>
CC: <linux-kernel@vger.kernel.org>, Hector Palacios <hector.palacios@digi.com>
Subject: [PATCH] spi: spidev_test gives error upon 1-byte transfer
Date: Tue, 20 Apr 2010 11:11:08 +0200
Message-ID: <1271754668-4391-1-git-send-email-hector.palacios@digi.com>
X-Mailer: git-send-email 1.7.0.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The sample application spidev_test.c is using SPI_IOC_MESSAGE
ioctl to do an SPI transfer. This ioctl returns the number of
bytes successfully transmitted or a negative error code upon
erroneous completion. The application however is returning an
error if the result of the ioclt if the return value is 1.
This makes the application to fail upon 1-byte length transfers.

Signed-off-by: Hector Palacios <hector.palacios@digi.com>
---
 Documentation/spi/spidev_test.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/spi/spidev_test.c b/Documentation/spi/spidev_test.c
index c1a5aad..8c9d02e 100644
--- a/Documentation/spi/spidev_test.c
+++ b/Documentation/spi/spidev_test.c
@@ -58,7 +58,7 @@ static void transfer(int fd)
 	};
 
 	ret = ioctl(fd, SPI_IOC_MESSAGE(1), &tr);
-	if (ret == 1)
+	if (ret < 1)
 		pabort("can't send spi message");
 
 	for (ret = 0; ret < ARRAY_SIZE(tx); ret++) {
-- 
1.7.0.5


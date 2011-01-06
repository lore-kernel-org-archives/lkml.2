Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754827Ab1AFW2x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 17:28:53 -0500
Received: from kroah.org ([198.145.64.141]:55666 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754535Ab1AFWXt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 17:23:49 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Vasiliy Kulikov <segoon@openwall.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 19/36] serial: ifx6x60: fix memory leak
Date: Thu,  6 Jan 2011 14:23:08 -0800
Message-Id: <1294352605-31906-19-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110106215404.GA30624@kroah.com>
References: <20110106215404.GA30624@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vasiliy Kulikov <segoon@openwall.com>

If tty_register_driver() failed then tty_driver is still alive.
Free it with put_tty_driver().

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/serial/ifx6x60.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/serial/ifx6x60.c b/drivers/serial/ifx6x60.c
index 3f8d5ee..ab93763 100644
--- a/drivers/serial/ifx6x60.c
+++ b/drivers/serial/ifx6x60.c
@@ -1384,6 +1384,7 @@ static int __init ifx_spi_init(void)
 	if (result) {
 		pr_err("%s: tty_register_driver failed(%d)",
 			DRVNAME, result);
+		put_tty_driver(tty_drv);
 		return result;
 	}
 
-- 
1.7.3.2


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756362Ab0KSSlx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 13:41:53 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:37517 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756326Ab0KSSlv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 13:41:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=QVEPB2ZEDZeKtbnKOSte42CikfblWFpAS1XUbhHqE9QiX24EWmTdFgdQK5VFyypxpb
         v6qXk4RnZzd7ERp5gi8qJp1XlgoYQ8SJESEk4r6+RPHjpCDRim6Q6eNP/05FNZkJTtlK
         jJov5Av/Ww7jmbvb/w0RjWLknQrVtRxwArTZI=
From: Vasiliy Kulikov <segoon@openwall.com>
To: kernel-janitors@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Alan Cox <alan@linux.intel.com>,
        Russ Gorby <richardx.r.gorby@intel.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] serial: ifx6x60: fix memory leak
Date: Fri, 19 Nov 2010 21:41:45 +0300
Message-Id: <1290192105-11494-1-git-send-email-segoon@openwall.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If tty_register_driver() failed then tty_driver is still alive.
Free it with put_tty_driver().

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
---
 Compile tested only.

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
1.7.0.4


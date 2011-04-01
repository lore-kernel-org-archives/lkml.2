Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758093Ab1DAP5Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 11:57:16 -0400
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:40794 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752508Ab1DAP5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 11:57:14 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=Wwnf1I4Ugo0K6aCENrkPK96wtR+VCnBWZNmsawy9kuk7nWOZRXQ6D9WSnrSVLbW1O7fZPMLi9PCxzk4cbBEiGmlKrHi/orpSJKxbAz25n3z4Sak7iKsDUUoiMDzE8dqK;
Date: Fri, 1 Apr 2011 08:57:12 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Joachim Eastwood <manabian@gmail.com>
Subject: [PATCH -mm] leds: fix pca9532 build when GPIOLIB is disabled
Message-Id: <20110401085712.2eb1d567.rdunlap@xenotime.net>
In-Reply-To: <201103312224.p2VMOA5g000983@imap1.linux-foundation.org>
References: <201103312224.p2VMOA5g000983@imap1.linux-foundation.org>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix build when GPIOLIB is not enabled:

drivers/leds/leds-pca9532.c:39: error: field 'gpio' has incomplete type

for: drivers-leds-leds-pca9532c-add-gpio-capability.patch

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Joachim Eastwood <manabian@gmail.com>
---
 drivers/leds/leds-pca9532.c |    2 ++
 1 file changed, 2 insertions(+)

--- mmotm-2011-0331-1448.orig/drivers/leds/leds-pca9532.c
+++ mmotm-2011-0331-1448/drivers/leds/leds-pca9532.c
@@ -36,7 +36,9 @@ struct pca9532_data {
 	struct mutex update_lock;
 	struct input_dev *idev;
 	struct work_struct work;
+#ifdef CONFIG_LEDS_PCA9532_GPIO
 	struct gpio_chip gpio;
+#endif
 	u8 pwm[2];
 	u8 psc[2];
 };

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932350Ab1DLOif (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 10:38:35 -0400
Received: from kroah.org ([198.145.64.141]:57677 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932306Ab1DLOid (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 10:38:33 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Apr 12 07:35:55 2011
Message-Id: <20110412143555.549263406@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Tue, 12 Apr 2011 07:35:00 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Matti Aaltonen <matti.j.aaltonen@nokia.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Mike Frysinger <vapier.adi@gmail.com>
Subject: [071/105] [media] media/radio/wl1273: fix build errors
In-Reply-To: <20110412143613.GA19478@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Randy Dunlap <randy.dunlap@oracle.com>

commit 1b149bbe9156d2eb2afd5a072bd61ad0d4bfaca7 upstream.

RADIO_WL1273 needs to make sure that the mfd core is built to avoid
build errors:

ERROR: "mfd_add_devices" [drivers/mfd/wl1273-core.ko] undefined!
ERROR: "mfd_remove_devices" [drivers/mfd/wl1273-core.ko] undefined!

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Matti Aaltonen <matti.j.aaltonen@nokia.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/radio/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/media/radio/Kconfig
+++ b/drivers/media/radio/Kconfig
@@ -441,6 +441,7 @@ config RADIO_TIMBERDALE
 config RADIO_WL1273
 	tristate "Texas Instruments WL1273 I2C FM Radio"
 	depends on I2C && VIDEO_V4L2
+	select MFD_CORE
 	select MFD_WL1273_CORE
 	select FW_LOADER
 	---help---



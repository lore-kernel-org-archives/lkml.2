Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422658Ab2LNXCU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 18:02:20 -0500
Received: from mail.kernel.org ([198.145.19.201]:40473 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932601Ab2LNXCO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 18:02:14 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        =?UTF-8?q?Samuel=20Iglesias=20Gons=C3=A1lvez?= 
	<siglesias@igalia.com>
Subject: [ 06/37] Staging: ipack/bridges/tpci200: avoid kernel bug when uninstalling a device
Date: Fri, 14 Dec 2012 15:00:43 -0800
Message-Id: <20121214222254.266747144@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20121214222252.781413287@linuxfoundation.org>
References: <20121214222252.781413287@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Samuel Iglesias Gonsálvez <siglesias@igalia.com>

commit 9e58d05a1b24d2c0471c3b4df8f473a7543d7647 upstream.

Signed-off-by: Samuel Iglesias Gonsálvez <siglesias@igalia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/ipack/bridges/tpci200.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/staging/ipack/bridges/tpci200.c
+++ b/drivers/staging/ipack/bridges/tpci200.c
@@ -604,8 +604,8 @@ static int tpci200_slot_unregister(struc
 	if (mutex_lock_interruptible(&tpci200->mutex))
 		return -ERESTARTSYS;
 
-	ipack_device_unregister(dev);
 	tpci200->slots[dev->slot].dev = NULL;
+	ipack_device_unregister(dev);
 	mutex_unlock(&tpci200->mutex);
 
 	return 0;



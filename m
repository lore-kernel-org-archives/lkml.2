Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760754Ab2J2ULZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 16:11:25 -0400
Received: from mail.kernel.org ([198.145.19.201]:42834 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760712Ab2J2UJO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 16:09:14 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Arend Van Spriel <arend@broadcom.com>,
        Piotr Haber <phaber@broadcom.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 29/34] bcma: fix unregistration of cores
Date: Mon, 29 Oct 2012 13:08:00 -0700
Message-Id: <20121029200423.782080965@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
In-Reply-To: <20121029200420.550338074@linuxfoundation.org>
References: <20121029200420.550338074@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Piotr Haber <phaber@broadcom.com>

commit 1fffa905adffbf0d3767fc978ef09afb830275eb upstream.

When cores are unregistered, entries
need to be removed from cores list in a safe manner.

Reported-by: Stanislaw Gruszka <sgruszka@redhat.com>
Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Signed-off-by: Piotr Haber <phaber@broadcom.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/bcma/main.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/bcma/main.c
+++ b/drivers/bcma/main.c
@@ -110,9 +110,10 @@ static int bcma_register_cores(struct bc
 
 static void bcma_unregister_cores(struct bcma_bus *bus)
 {
-	struct bcma_device *core;
+	struct bcma_device *core, *tmp;
 
-	list_for_each_entry(core, &bus->cores, list) {
+	list_for_each_entry_safe(core, tmp, &bus->cores, list) {
+		list_del(&core->list);
 		if (core->dev_registered)
 			device_unregister(&core->dev);
 	}



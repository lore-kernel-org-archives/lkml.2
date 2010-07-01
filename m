Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932296Ab0GAScU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 14:32:20 -0400
Received: from kroah.org ([198.145.64.141]:40755 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757739Ab0GASYN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 14:24:13 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:32:16 2010
Message-Id: <20100701173216.764789302@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:32:24 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Grazvydas Ignotas <notasas@gmail.com>, Kalle Valo <kvalo@adurom.com>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: [patch 118/149] wl1251: fix a memory leak in probe
In-Reply-To: <20100701175144.GA2116@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Grazvydas Ignotas <notasas@gmail.com>

commit aa679c36756003f1fabdb9fc6f00eb159559f7c3 upstream.

wl1251_sdio_probe() error path is missing wl1251_free_hw, add it.

Signed-off-by: Grazvydas Ignotas <notasas@gmail.com>
Acked-by: Kalle Valo <kvalo@adurom.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/wl12xx/wl1251_sdio.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/wireless/wl12xx/wl1251_sdio.c
+++ b/drivers/net/wireless/wl12xx/wl1251_sdio.c
@@ -160,6 +160,7 @@ disable:
 	sdio_disable_func(func);
 release:
 	sdio_release_host(func);
+	wl1251_free_hw(wl);
 	return ret;
 }
 



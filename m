Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757218Ab2KZVic (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 16:38:32 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:51054 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754138Ab2KZVib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 16:38:31 -0500
MIME-Version: 1.0
Date: Mon, 26 Nov 2012 16:38:29 -0500
Message-ID: <CAMW5UfZmptBK5sLq3zMdPJ6C3Arqfyy4SY5BOPfqcOB1T-sbSg@mail.gmail.com>
Subject: [RFC v2 1/1] RTL8712 alignment bug in 3.6 and up on ARMV5
From: Josh Coombs <josh.coombs@gmail.com>
To: Andrew Lunn <andrew@lunn.ch>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux ARM <linux-arm-kernel@lists.infradead.org>, wlanfae@realtek.com,
        Larry.Finger@lwfinger.net, florian.c.schilhabel@googlemail.com,
        gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've been banging on my test setup for the past week.  I haven't
tracked down the cause yet, but something in my prior build system
results in this problem being masked with some builds.  Doing pure
vanilla builds from git I'm able to reproduce with 3.6 and the 3.7-rc
series reliably.  Support for my GFN doesn't exist officially prior to
3.6 and I didn't want to introduce new variables by back porting
support and trying to test with that patch set so I was unable to
isolate a start point for the failure I found.  I can reproduce the
failure with 3.7-rc6 currently.

Currently I'm running stable on 3.7-rc6 with the below patch and my
RealTek 8712 USB NIC.

I'm open to any and all suggestions on how to test further.

Signed-off-by: Joshua Coombs <josh.coombs@gmail.com>
--
diff -ruN a/drivers/staging/rtl8712/rtl871x_sta_mgt.c
b/drivers/staging/rtl8712/rtl871x_sta_mgt.c
--- a/drivers/staging/rtl8712/rtl871x_sta_mgt.c 2012-11-17
16:21:23.000000000 -0500
+++ b/drivers/staging/rtl8712/rtl871x_sta_mgt.c 2012-11-18
14:58:27.000000000 -0500
@@ -52,11 +52,11 @@
  s32 i;

  pstapriv->pallocated_stainfo_buf = _malloc(sizeof(struct sta_info) *
-   NUM_STA + 4);
+   NUM_STA + 8);
  if (pstapriv->pallocated_stainfo_buf == NULL)
  return _FAIL;
- pstapriv->pstainfo_buf = pstapriv->pallocated_stainfo_buf + 4 -
- ((addr_t)(pstapriv->pallocated_stainfo_buf) & 3);
+ pstapriv->pstainfo_buf = pstapriv->pallocated_stainfo_buf + 8 -
+ ((addr_t)(pstapriv->pallocated_stainfo_buf) & 7);
  _init_queue(&pstapriv->free_sta_queue);
  spin_lock_init(&pstapriv->sta_hash_lock);
  pstapriv->asoc_sta_count = 0;

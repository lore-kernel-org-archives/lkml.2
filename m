Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756035Ab2HFLtD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 07:49:03 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:50417 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752948Ab2HFLtB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 07:49:01 -0400
MIME-Version: 1.0
Date: Mon, 6 Aug 2012 11:49:00 +0000
Message-ID: <CAGh4K3Lym9yETNbMutfjNuANrgwtvfrGes6emr3Mvhx47D3B2g@mail.gmail.com>
Subject: [PATCH]: Mac80211 driver and I checked the patch
From: Christopher Sacchi <chris.sacchi@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The source file needed a change  that was told in the description to
know that the #include needed to be fixed, and the function changed
another value to 0 (yes) in the description (that said FIXME.) The
patch fixes a typo-like error and has been checked with checkpatch.pl
in the scripts directory.
Here's the patch:
--
--- main.c	2012-07-21 20:58:29.000000000 +0000
+++ mainnew.c	2012-08-05 20:00:37.000000000 +0000
@@ -32,7 +32,7 @@
 #include "led.h"
 #include "cfg.h"
 #include "debugfs.h"
-
+#include "net/rfkill/rfkill.h"
 static struct lock_class_key ieee80211_rx_skb_queue_class;

 void ieee80211_configure_filter(struct ieee80211_local *local)
@@ -183,6 +183,7 @@ int ieee80211_hw_config(struct ieee80211
 		 *
 		 */
 		/* WARN_ON(ret); */
+		WARN_ON(1)
 	}

 	return ret;
Signed-off-by: Christopher P. Sacchi <chris.sacchi@gmail.com>
--

-- 
Christopher

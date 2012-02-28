Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030374Ab2B1Wdo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 17:33:44 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:46873 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966085Ab2B1Wdn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 17:33:43 -0500
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 2/5] watchdog: Add a flag to indicate the watchdog doesn't
 reboot things
To: wim@iguana.be, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Tue, 28 Feb 2012 22:47:55 +0000
Message-ID: <20120228224741.8961.11982.stgit@bob.linux.org.uk>
In-Reply-To: <20120228224710.8961.46003.stgit@bob.linux.org.uk>
References: <20120228224710.8961.46003.stgit@bob.linux.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

Some watchdogs merely trigger external alarms and controls. In a managed
environment this is very useful but we want drivers to be able to figure
out which is which now multiple dogs can be loaded. Thus add an ALARMONLY
feature flag.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 include/linux/watchdog.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)


diff --git a/include/linux/watchdog.h b/include/linux/watchdog.h
index 4167fd3..c80e1ae 100644
--- a/include/linux/watchdog.h
+++ b/include/linux/watchdog.h
@@ -45,6 +45,8 @@ struct watchdog_info {
 #define	WDIOF_SETTIMEOUT	0x0080  /* Set timeout (in seconds) */
 #define	WDIOF_MAGICCLOSE	0x0100	/* Supports magic close char */
 #define	WDIOF_PRETIMEOUT	0x0200  /* Pretimeout (in seconds), get/set */
+#define WDIOF_ALARMONLY		0x0400	/* Watchdog triggers a management or
+					   other external alarm not a reboot */
 #define	WDIOF_KEEPALIVEPING	0x8000	/* Keep alive ping reply */
 
 #define	WDIOS_DISABLECARD	0x0001	/* Turn off the watchdog timer */


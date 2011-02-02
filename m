Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752776Ab1BBAnj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 19:43:39 -0500
Received: from mga09.intel.com ([134.134.136.24]:41311 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752569Ab1BBAnd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 19:43:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,412,1291622400"; 
   d="scan'208";a="598622320"
From: Andi Kleen <andi@firstfloor.org>
References: <20110201443.618138584@firstfloor.org>
In-Reply-To: <20110201443.618138584@firstfloor.org>
To: tiwai@suse.de, rjw@sisk.pl, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [27/139] PM / Hibernate: Fix PM_POST_* notification with user-space suspend
Message-Id: <20110202004342.1393F3E09C6@tassilo.jf.intel.com>
Date: Tue,  1 Feb 2011 16:43:42 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Takashi Iwai <tiwai@suse.de>

commit 1497dd1d29c6a53fcd3c80f7ac8d0e0239e7389e upstream.

The user-space hibernation sends a wrong notification after the image
restoration because of thinko for the file flag check.  RDONLY
corresponds to hibernation and WRONLY to restoration, confusingly.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 kernel/power/user.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.35.y/kernel/power/user.c
===================================================================
--- linux-2.6.35.y.orig/kernel/power/user.c
+++ linux-2.6.35.y/kernel/power/user.c
@@ -137,7 +137,7 @@ static int snapshot_release(struct inode
 	free_all_swap_pages(data->swap);
 	if (data->frozen)
 		thaw_processes();
-	pm_notifier_call_chain(data->mode == O_WRONLY ?
+	pm_notifier_call_chain(data->mode == O_RDONLY ?
 			PM_POST_HIBERNATION : PM_POST_RESTORE);
 	atomic_inc(&snapshot_device_available);
 

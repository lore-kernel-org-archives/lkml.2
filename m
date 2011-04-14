Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759280Ab1DNSH7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 14:07:59 -0400
Received: from mail.windriver.com ([147.11.1.11]:42203 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964987Ab1DNR6o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:58:44 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Takashi Iwai <tiwai@suse.de>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 170/209] PM / Hibernate: Fix PM_POST_* notification with user-space suspend
Date: Thu, 14 Apr 2011 13:55:28 -0400
Message-Id: <1302803767-9715-57-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1302803767-9715-1-git-send-email-paul.gortmaker@windriver.com>
References: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
 <1302803767-9715-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

  =====================================================================
  | This is a commit scheduled for the next v2.6.34 longterm release. |
  | If you see a problem with using this for longterm, please comment.|
  =====================================================================

commit 1497dd1d29c6a53fcd3c80f7ac8d0e0239e7389e upstream.

The user-space hibernation sends a wrong notification after the image
restoration because of thinko for the file flag check.  RDONLY
corresponds to hibernation and WRONLY to restoration, confusingly.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 kernel/power/user.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/power/user.c b/kernel/power/user.c
index a8c9621..16a7d95 100644
--- a/kernel/power/user.c
+++ b/kernel/power/user.c
@@ -137,7 +137,7 @@ static int snapshot_release(struct inode *inode, struct file *filp)
 	free_all_swap_pages(data->swap);
 	if (data->frozen)
 		thaw_processes();
-	pm_notifier_call_chain(data->mode == O_WRONLY ?
+	pm_notifier_call_chain(data->mode == O_RDONLY ?
 			PM_POST_HIBERNATION : PM_POST_RESTORE);
 	atomic_inc(&snapshot_device_available);
 
-- 
1.7.4.4


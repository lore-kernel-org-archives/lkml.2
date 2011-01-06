Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754069Ab1AFA6A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 19:58:00 -0500
Received: from kroah.org ([198.145.64.141]:35521 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753972Ab1AFA3Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 19:29:16 -0500
X-Mailbox-Line: From gregkh@clark.site Wed Jan  5 16:22:59 2011
Message-Id: <20110106002259.675903543@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 05 Jan 2011 16:22:11 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Takashi Iwai <tiwai@suse.de>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [032/152] PM / Hibernate: Fix PM_POST_* notification with user-space suspend
In-Reply-To: <20110106002500.GA3172@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 1497dd1d29c6a53fcd3c80f7ac8d0e0239e7389e upstream.

The user-space hibernation sends a wrong notification after the image
restoration because of thinko for the file flag check.  RDONLY
corresponds to hibernation and WRONLY to restoration, confusingly.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/power/user.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/power/user.c
+++ b/kernel/power/user.c
@@ -137,7 +137,7 @@ static int snapshot_release(struct inode
 	free_all_swap_pages(data->swap);
 	if (data->frozen)
 		thaw_processes();
-	pm_notifier_call_chain(data->mode == O_WRONLY ?
+	pm_notifier_call_chain(data->mode == O_RDONLY ?
 			PM_POST_HIBERNATION : PM_POST_RESTORE);
 	atomic_inc(&snapshot_device_available);
 



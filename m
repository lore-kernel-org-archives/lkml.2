Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753407Ab0L0RuK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Dec 2010 12:50:10 -0500
Received: from cantor.suse.de ([195.135.220.2]:53555 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751885Ab0L0RuH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Dec 2010 12:50:07 -0500
From: David Sterba <dsterba@suse.cz>
To: gregkh@suse.de
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Sterba <dsterba@suse.cz>, Oliver Neukum <oliver@neukum.org>,
        Marcel Holtmann <marcel@holtmann.org>
Subject: [PATCH] USB: cdc-wdm: fix misuse of logical operation in place of bitop
Date: Mon, 27 Dec 2010 18:49:58 +0100
Message-Id: <1293472198-29619-1-git-send-email-dsterba@suse.cz>
X-Mailer: git-send-email 1.7.3.4.626.g73e7b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC: Greg Kroah-Hartman <gregkh@suse.de>
CC: Oliver Neukum <oliver@neukum.org>
CC: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: David Sterba <dsterba@suse.cz>
---
 drivers/usb/class/cdc-wdm.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/class/cdc-wdm.c b/drivers/usb/class/cdc-wdm.c
index 6ee4451..47085e5 100644
--- a/drivers/usb/class/cdc-wdm.c
+++ b/drivers/usb/class/cdc-wdm.c
@@ -342,7 +342,7 @@ static ssize_t wdm_write
 		goto outnp;
 	}
 
-	if (!file->f_flags && O_NONBLOCK)
+	if (!(file->f_flags & O_NONBLOCK))
 		r = wait_event_interruptible(desc->wait, !test_bit(WDM_IN_USE,
 								&desc->flags));
 	else
-- 
1.7.3.4.626.g73e7b


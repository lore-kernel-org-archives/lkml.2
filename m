Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755307Ab2AXAJc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 19:09:32 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42103 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755259Ab2AWXqg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 18:46:36 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Jan 23 15:42:03 2012
Message-Id: <20120123234203.284146075@clark.kroah.org>
User-Agent: quilt/0.50-11.1
Date: Mon, 23 Jan 2012 15:41:05 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Oliver Neukum <oliver@neukum.org>,
        Marcel Holtmann <marcel@holtmann.org>, David Sterba <dsterba@suse.cz>,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>
Subject: [19/27] USB: cdc-wdm: fix misuse of logical operation in place of bitop
In-Reply-To: <20120123234224.GA19510@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: David Sterba <dsterba@suse.cz>

commit 0cdfb819b6a97e79c7a0aa0c471cd7000367103b upstream.

CC: Greg Kroah-Hartman <gregkh@suse.de>
CC: Oliver Neukum <oliver@neukum.org>
CC: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: David Sterba <dsterba@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Bjørn Mork <bjorn@mork.no>

---
 drivers/usb/class/cdc-wdm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/class/cdc-wdm.c
+++ b/drivers/usb/class/cdc-wdm.c
@@ -314,7 +314,7 @@ static ssize_t wdm_write
 	if (r < 0)
 		goto outnp;
 
-	if (!file->f_flags && O_NONBLOCK)
+	if (!(file->f_flags & O_NONBLOCK))
 		r = wait_event_interruptible(desc->wait, !test_bit(WDM_IN_USE,
 								&desc->flags));
 	else



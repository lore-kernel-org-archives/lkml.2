Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932625Ab0LHBDI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:03:08 -0500
Received: from kroah.org ([198.145.64.141]:33585 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932388Ab0LHBDB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 20:03:01 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:42 2010
Message-Id: <20101208005742.059488410@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:59:43 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alek Du <alek.du@intel.com>, Jacob Pan <jacob.jun.pan@intel.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: [206/289] USB: ehci: fix debugfs lpm permissions
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Greg Kroah-Hartman <gregkh@suse.de>

commit 723b991a62d94f74c9f19abd3da6e937288eb969 upstream.

The permissions for the lpm debugfs file is incorrect, this fixes it.

Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alek Du <alek.du@intel.com>
Cc: Jacob Pan <jacob.jun.pan@intel.com>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Cc: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/host/ehci-dbg.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/host/ehci-dbg.c
+++ b/drivers/usb/host/ehci-dbg.c
@@ -1063,7 +1063,7 @@ static inline void create_debug_files (s
 						    &debug_registers_fops))
 		goto file_error;
 
-	if (!debugfs_create_file("lpm", S_IRUGO|S_IWUGO, ehci->debug_dir, bus,
+	if (!debugfs_create_file("lpm", S_IRUGO|S_IWUSR, ehci->debug_dir, bus,
 						    &debug_lpm_fops))
 		goto file_error;
 



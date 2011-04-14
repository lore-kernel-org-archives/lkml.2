Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933502Ab1DNRw2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 13:52:28 -0400
Received: from mail.windriver.com ([147.11.1.11]:38540 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933411Ab1DNRrR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:47:17 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        David Taht <d@teklibre.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 099/209] Staging: frontier: fix up my fixup for some sysfs attribute permissions
Date: Thu, 14 Apr 2011 13:42:09 -0400
Message-Id: <1302803039-9400-100-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
References: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@suse.de>

  =====================================================================
  | This is a commit scheduled for the next v2.6.34 longterm release. |
  | If you see a problem with using this for longterm, please comment.|
  =====================================================================

commit 2a767fda5d0d8dcff465724dfad6ee131489b3f2 upstream.

They should be writable by root, not readable.
Doh, stupid me with the wrong flags.

Reported-by: Jonathan Cameron <jic23@cam.ac.uk>
Cc: David Taht <d@teklibre.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/staging/frontier/tranzport.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/frontier/tranzport.c b/drivers/staging/frontier/tranzport.c
index 7218334..9d60e92 100644
--- a/drivers/staging/frontier/tranzport.c
+++ b/drivers/staging/frontier/tranzport.c
@@ -202,7 +202,7 @@ static void usb_tranzport_abort_transfers(struct usb_tranzport *dev)
     t->value = temp;							\
     return count;							\
   }									\
-  static DEVICE_ATTR(value, S_IRUSR | S_IRUGO, show_##value, set_##value);
+  static DEVICE_ATTR(value, S_IWUSR | S_IRUGO, show_##value, set_##value);
 
 show_int(enable);
 show_int(offline);
-- 
1.7.4.4


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755918Ab2ACWis (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 17:38:48 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39844 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755904Ab2ACWip (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 17:38:45 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Jan  3 14:33:22 2012
Message-Id: <20120103223322.013182217@clark.kroah.org>
User-Agent: quilt/0.50-25.1
Date: Tue, 03 Jan 2012 14:32:45 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Thomas Gleixner <tglx@linutronix.de>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [12/75] SCSI: fcoe: Fix preempt count leak in fcoe_filter_frames()
In-Reply-To: <20120103223332.GA4112@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

commit 7e1e7ead88dff75b11b86ee0d5232c4591be1326 upstream.

The error exit path leaks preempt count. Add the missing put_cpu().

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Yi Zou <yi.zou@intel.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/fcoe/fcoe.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -1635,6 +1635,7 @@ static inline int fcoe_filter_frames(str
 	stats->InvalidCRCCount++;
 	if (stats->InvalidCRCCount < 5)
 		printk(KERN_WARNING "fcoe: dropping frame with CRC error\n");
+	put_cpu();
 	return -EINVAL;
 }
 



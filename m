Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755226Ab2F0JAq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 05:00:46 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:27642 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754598Ab2F0JAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 05:00:44 -0400
Date: Wed, 27 Jun 2012 12:00:30 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Neela Syam Kolli <megaraidlinux@lsi.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Subject: [patch -resend] [SCSI] megaraid: remove a spurious IRQ enable
Message-ID: <20120627090030.GC31212@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120627085800.GA3007@mwanda>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We took this lock with spin_lock() so we should unlock it with
spin_unlock() instead of spin_unlock_irq().  This was introduced in
f2c8dc402b "[SCSI] megaraid_mbox: remove scsi_assign_lock usage".

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
This was originally sent on Sat, 30 Jul 2011.  I have cleaned up the
commit message a bit and added Christoph to the CC list.

diff --git a/drivers/scsi/megaraid/megaraid_mbox.c b/drivers/scsi/megaraid/megaraid_mbox.c
index 35bd138..54b1c5b 100644
--- a/drivers/scsi/megaraid/megaraid_mbox.c
+++ b/drivers/scsi/megaraid/megaraid_mbox.c
@@ -2731,7 +2731,7 @@ megaraid_reset_handler(struct scsi_cmnd *scp)
 	}
 
  out:
-	spin_unlock_irq(&adapter->lock);
+	spin_unlock(&adapter->lock);
 	return rval;
 }
 

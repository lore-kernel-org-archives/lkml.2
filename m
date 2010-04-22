Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756744Ab0DVT3l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 15:29:41 -0400
Received: from kroah.org ([198.145.64.141]:41219 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756695Ab0DVT3P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 15:29:15 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:09:19 2010
Message-Id: <20100422190919.136742005@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:09:43 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Mike Christie <michaelc@cs.wisc.edu>,
       James Bottomley <James.Bottomley@suse.de>,
       maximilian attems <max@stro.at>
Subject: [132/197] SCSI: add scsi target reset support to scsi ioctl
In-Reply-To: <20100422191857.GA13268@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Mike Christie <michaelc@cs.wisc.edu>

commit 3f9daedfcb197d784c6e7ecd731e3aa9859bc951 upstream.

The scsi ioctl code path was missing scsi target reset
support. This patch just adds it.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: James Bottomley <James.Bottomley@suse.de>
Cc: maximilian attems <max@stro.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/scsi_ioctl.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/scsi/scsi_ioctl.c
+++ b/drivers/scsi/scsi_ioctl.c
@@ -308,6 +308,9 @@ int scsi_nonblockable_ioctl(struct scsi_
 		case SG_SCSI_RESET_DEVICE:
 			val = SCSI_TRY_RESET_DEVICE;
 			break;
+		case SG_SCSI_RESET_TARGET:
+			val = SCSI_TRY_RESET_TARGET;
+			break;
 		case SG_SCSI_RESET_BUS:
 			val = SCSI_TRY_RESET_BUS;
 			break;



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756862Ab0DVT3r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 15:29:47 -0400
Received: from kroah.org ([198.145.64.141]:41262 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756711Ab0DVT3S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 15:29:18 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:09:19 2010
Message-Id: <20100422190919.487435363@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:09:47 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Giridhar Malavali <giridhar.malavali@qlogic.com>,
       James Bottomley <James.Bottomley@suse.de>,
       maximilian attems <max@stro.at>
Subject: [136/197] SCSI: fc-transport: Use packed modifier for fc_bsg_request structure.
In-Reply-To: <20100422191857.GA13268@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Harish Zunjarrao <harish.zunjarrao@qlogic.com>

commit eda05a28ec52be40086400a1b606d211276f0e41 upstream.

The 32bit kernel does not add padding bytes in the fc_bsg_request structure
whereas the 64bit kernel adds padding bytes in the fc_bsg_request structure.
Due to this, structure elements gets mismatched with 32bit application and
64bit kernel.To resolve this, used packed modifier to avoid adding padding bytes.
Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
Signed-off-by: James Bottomley <James.Bottomley@suse.de>
Cc: maximilian attems <max@stro.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/scsi/scsi_bsg_fc.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/scsi/scsi_bsg_fc.h
+++ b/include/scsi/scsi_bsg_fc.h
@@ -292,7 +292,7 @@ struct fc_bsg_request {
 		struct fc_bsg_rport_els		r_els;
 		struct fc_bsg_rport_ct		r_ct;
 	} rqst_data;
-};
+} __attribute__((packed));
 
 
 /* response (request sense data) structure of the sg_io_v4 */



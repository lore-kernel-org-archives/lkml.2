Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758365Ab0KSWGn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 17:06:43 -0500
Received: from kroah.org ([198.145.64.141]:53108 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758223Ab0KSWEf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 17:04:35 -0500
X-Mailbox-Line: From gregkh@clark.site Fri Nov 19 14:01:27 2010
Message-Id: <20101119220126.957162525@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 19 Nov 2010 14:01:29 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Anil Ravindranath <anil_ravindranath@pmc-sierra.com>,
        James Bottomley <James.Bottomley@suse.de>
Subject: [58/66] [SCSI] pmcraid: remove duplicate struct member
In-Reply-To: <20101119220309.GA15562@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Anil Ravindranath <anil_ravindranath@pmc-sierra.com>

commit df30e5059681ed0671c9cc6ff702fe9ca7f20042 upstream.

sense_buffer is both a direct member of struct pmcraid_cmd as well as
an indirect one via an anonymous union and struct.  Fix this clash by
eliminating the direct member in favour of the anonymous struct/union
one.  The name duplication apparently isn't noticed by gcc versions
earlier than 4.4

Reported-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Anil Ravindranath <anil_ravindranath@pmc-sierra.com>
Signed-off-by: James Bottomley <James.Bottomley@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/pmcraid.h |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/scsi/pmcraid.h
+++ b/drivers/scsi/pmcraid.h
@@ -568,7 +568,6 @@ struct pmcraid_cmd {
 	struct pmcraid_control_block *ioa_cb;
 	dma_addr_t ioa_cb_bus_addr;
 	dma_addr_t dma_handle;
-	u8 *sense_buffer;
 
 	/* pointer to mid layer structure of SCSI commands */
 	struct scsi_cmnd *scsi_cmd;



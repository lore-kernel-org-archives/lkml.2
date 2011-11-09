Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965027Ab1KJEhd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 23:37:33 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43634 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935874Ab1KJDgP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:36:15 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:31:45 2011
Message-Id: <20111109213145.542997599@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:31:21 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jeff Skirvin <jeffrey.d.skirvin@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [034/264] [SCSI] isci: fix missed unlock in apc_agent_timeout()
In-Reply-To: <20111109213508.GA3476@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Skirvin <jeffrey.d.skirvin@intel.com>

commit 983d3fdd332742167d0482c06fd29cf4b8a687c0 upstream.

Needed to jump to scic_lock unlock.

Also spotted by coccicheck.

Signed-off-by: Jeff Skirvin <jeffrey.d.skirvin@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/isci/port_config.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/scsi/isci/port_config.c
+++ b/drivers/scsi/isci/port_config.c
@@ -678,7 +678,7 @@ static void apc_agent_timeout(unsigned l
 	configure_phy_mask = ~port_agent->phy_configured_mask & port_agent->phy_ready_mask;
 
 	if (!configure_phy_mask)
-		return;
+		goto done;
 
 	for (index = 0; index < SCI_MAX_PHYS; index++) {
 		if ((configure_phy_mask & (1 << index)) == 0)



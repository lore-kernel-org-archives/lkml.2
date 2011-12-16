Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932716Ab1LPUH4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 15:07:56 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44907 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760655Ab1LPTtE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 14:49:04 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Dec 16 11:45:58 2011
Message-Id: <20111216194557.925945935@clark.kroah.org>
User-Agent: quilt/0.50-24.1
Date: Fri, 16 Dec 2011 11:45:21 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Roland Dreier <roland@purestorage.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [24/53] target: Fix page length in emulated INQUIRY VPD page 86h
In-Reply-To: <20111216194613.GA18395@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roland Dreier <roland@purestorage.com>

commit 1289a0571c037b4757f60597d646aedb70361ec3 upstream.

The LSB of the page length is at offset 3, not 2.

Signed-off-by: Roland Dreier <roland@purestorage.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/target/target_core_cdb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/target/target_core_cdb.c
+++ b/drivers/target/target_core_cdb.c
@@ -477,7 +477,7 @@ target_emulate_evpd_86(struct se_cmd *cm
 	if (cmd->data_length < 60)
 		return 0;
 
-	buf[2] = 0x3c;
+	buf[3] = 0x3c;
 	/* Set HEADSUP, ORDSUP, SIMPSUP */
 	buf[5] = 0x07;
 



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753596Ab1GFHhl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 03:37:41 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:61449 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752141Ab1GFHhk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 03:37:40 -0400
Date: Wed, 6 Jul 2011 10:36:33 +0300
From: Dan Carpenter <error27@gmail.com>
To: Jing Huang <huangj@brocade.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>,
        "open list:BROCADE BFA FC SC..." <linux-scsi@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Subject: [patch 1/2] [SCSI] bfa: off by one in bfa_ioc_mbox_isr()
Message-ID: <20110706073633.GD18655@shale.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If mc == BFI_MC_MAX then we're reading past the end of the
mod->mbhdlr[] array.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/scsi/bfa/bfa_ioc.c b/drivers/scsi/bfa/bfa_ioc.c
index d6c2bf3..052373b 100644
--- a/drivers/scsi/bfa/bfa_ioc.c
+++ b/drivers/scsi/bfa/bfa_ioc.c
@@ -2378,7 +2378,7 @@ bfa_ioc_mbox_isr(struct bfa_ioc_s *ioc)
 			return;
 		}
 
-		if ((mc > BFI_MC_MAX) || (mod->mbhdlr[mc].cbfn == NULL))
+		if ((mc >= BFI_MC_MAX) || (mod->mbhdlr[mc].cbfn == NULL))
 			return;
 
 		mod->mbhdlr[mc].cbfn(mod->mbhdlr[mc].cbarg, &m);

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934060Ab0HEUSr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 16:18:47 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:55334 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933589Ab0HEUSl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 16:18:41 -0400
Date: Thu, 5 Aug 2010 22:18:39 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Willem Riede <osst@riede.org>,
        "James E.J. Bottomley" <James.Bottomley@suse.de>,
        osst-users@lists.sourceforge.net, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 6/42] drivers/scsi: Adjust confusing if indentation
Message-ID: <Pine.LNX.4.64.1008052218190.31692@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Indent the branch of an if.

The semantic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@r disable braces4@
position p1,p2;
statement S1,S2;
@@

(
if (...) { ... }
|
if (...) S1@p1 S2@p2
)

@script:python@
p1 << r.p1;
p2 << r.p2;
@@

if (p1[0].column == p2[0].column):
  cocci.print_main("branch",p1)
  cocci.print_secs("after",p2)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/scsi/osst.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/osst.c b/drivers/scsi/osst.c
index d64b717..f974c10 100644
--- a/drivers/scsi/osst.c
+++ b/drivers/scsi/osst.c
@@ -4694,7 +4694,7 @@ static int __os_scsi_tape_open(struct inode * inode, struct file * filp)
 						    STp->timeout, MAX_RETRIES, 1);
 			if ((SRpnt->sense[0] & 0x70) != 0x70 ||
 			    (SRpnt->sense[2] & 0x0f) == NOT_READY)
-			break;
+				break;
 
 			if ((SRpnt->sense[2] & 0x0f) == UNIT_ATTENTION) {
 				STp->pos_unknown = 0;

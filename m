Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1163169Ab1FAIeQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 04:34:16 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44537 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161620Ab1FAI1j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:27:39 -0400
X-Mailbox-Line: From linux@blue.kroah.org Wed Jun  1 17:12:15 2011
Message-Id: <20110601081215.365650460@blue.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 01 Jun 2011 17:11:51 +0900
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Mike Snitzer <snitzer@redhat.com>, Alasdair G Kergon <agk@redhat.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [141/165] dm mpath: do not fail paths after integrity errors
In-Reply-To: <20110601081349.GA10017@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------
Content-Length: 899
Lines: 29

From: "Martin K. Petersen" <martin.petersen@oracle.com>

commit 6f13f6fba76edc7d0e7580c5deee829d59a41b2f upstream.

Integrity errors need to be passed to the owner of the integrity
metadata for processing. Consequently EILSEQ should be passed up the
stack.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Acked-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/md/dm-mpath.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -1290,7 +1290,7 @@ static int do_end_io(struct multipath *m
 	if (!error && !clone->errors)
 		return 0;	/* I/O complete */
 
-	if (error == -EOPNOTSUPP || error == -EREMOTEIO)
+	if (error == -EOPNOTSUPP || error == -EREMOTEIO || error == -EILSEQ)
 		return error;
 
 	if (mpio->pgpath)



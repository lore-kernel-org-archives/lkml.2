Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933558Ab0LUEBx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 23:01:53 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:59908 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933506Ab0LUEBv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 23:01:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=bFxELaErJ+DX0OT7AkTW22LUcBvqHm29EXhj2POPJ7awtkYtyHGmRjMsmefDq5ZEcl
         kjeIqNeNTl0Xu5VA9NAv7hSJwNWigMlX+8C25NXsqD+tbj3H4wJa4rQu/X4Rn3rckEBp
         Ah2p/TGzDHmUOiCF851CCaVs8Qw6HB0Wd76iE=
Date: Tue, 21 Dec 2010 07:01:37 +0300
From: Dan Carpenter <error27@gmail.com>
To: Robert Love <robert.w.love@intel.com>
Cc: "James E.J. Bottomley" <James.Bottomley@suse.de>, devel@open-fcoe.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [patch -next] libfc: dereferencing ERR_PTR in fc_tm_done()
Message-ID: <20101221040137.GE1936@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Robert Love <robert.w.love@intel.com>,
	"James E.J. Bottomley" <James.Bottomley@suse.de>,
	devel@open-fcoe.org, linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we goto out, then it tries to call kfree_skb() on an ERR_PTR which
will oops.  Just return directly.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index 5962d1a..a918807 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -1321,7 +1321,7 @@ static void fc_tm_done(struct fc_seq *seq, struct fc_frame *fp, void *arg)
 		 *
 		 * scsi-eh will escalate for when either happens.
 		 */
-		goto out;
+		return;
 	}
 
 	if (fc_fcp_lock_pkt(fsp))

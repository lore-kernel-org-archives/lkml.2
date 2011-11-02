Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935033Ab1KCBoF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 21:44:05 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51601 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935040Ab1KCBny (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 21:43:54 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  2 15:27:46 2011
Message-Id: <20111102222746.727195520@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 02 Nov 2011 15:27:00 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, "J. Bruce Fields" <bfields@redhat.com>
Subject: [076/101] nfsd4: ignore WANT bits in open downgrade
In-Reply-To: <20111102222755.GA10893@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: "J. Bruce Fields" <bfields@redhat.com>

commit c30e92df30d7d5fe65262fbce5d1b7de675fe34e upstream.

We don't use WANT bits yet--and sending them can probably trigger a
BUG() further down.

Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/nfsd/nfs4state.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -3062,6 +3062,8 @@ nfsd4_open_downgrade(struct svc_rqst *rq
 	if (!access_valid(od->od_share_access, cstate->minorversion)
 			|| !deny_valid(od->od_share_deny))
 		return nfserr_inval;
+	/* We don't yet support WANT bits: */
+	od->od_share_access &= NFS4_SHARE_ACCESS_MASK;
 
 	nfs4_lock_state();
 	if ((status = nfs4_preprocess_seqid_op(cstate,



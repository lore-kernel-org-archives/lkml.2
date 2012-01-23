Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755465Ab2AXAIs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 19:08:48 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42183 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755341Ab2AWXqv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 18:46:51 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Jan 23 15:40:24 2012
Message-Id: <20120123234024.173443195@clark.kroah.org>
User-Agent: quilt/0.50-11.1
Date: Mon, 23 Jan 2012 15:39:00 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Andy Adamson <andros@netapp.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [14/90] NFSv4.1: fix backchannel slotid off-by-one bug
In-Reply-To: <20120123234211.GA19504@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Adamson <andros@netapp.com>

commit 61f2e5106582d02f30b6807e3f9c07463c572ccb upstream.

Signed-off-by: Andy Adamson <andros@netapp.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/nfs/callback_proc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/nfs/callback_proc.c
+++ b/fs/nfs/callback_proc.c
@@ -324,7 +324,7 @@ validate_seqid(struct nfs4_slot_table *t
 	dprintk("%s enter. slotid %d seqid %d\n",
 		__func__, args->csa_slotid, args->csa_sequenceid);
 
-	if (args->csa_slotid > NFS41_BC_MAX_CALLBACKS)
+	if (args->csa_slotid >= NFS41_BC_MAX_CALLBACKS)
 		return htonl(NFS4ERR_BADSLOT);
 
 	slot = tbl->slots + args->csa_slotid;



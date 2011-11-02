Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934079Ab1KCBjC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 21:39:02 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51006 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933997Ab1KCBi4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 21:38:56 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  2 15:27:41 2011
Message-Id: <20111102222741.397547422@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 02 Nov 2011 15:26:03 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Eric Van Hensbergen <ericvh@gmail.com>
Subject: [019/101] fs/9p: Fid is not valid after a failed clunk.
In-Reply-To: <20111102222755.GA10893@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>

commit 5034990e28efb2d232ee82443a9edd62defd17ba upstream.

free the fid even in case of failed clunk.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Eric Van Hensbergen <ericvh@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/9p/client.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/net/9p/client.c
+++ b/net/9p/client.c
@@ -1038,9 +1038,11 @@ int p9_client_clunk(struct p9_fid *fid)
 	P9_DPRINTK(P9_DEBUG_9P, "<<< RCLUNK fid %d\n", fid->fid);
 
 	p9_free_req(clnt, req);
-	p9_fid_destroy(fid);
-
 error:
+	/*
+	 * Fid is not valid even after a failed clunk
+	 */
+	p9_fid_destroy(fid);
 	return err;
 }
 EXPORT_SYMBOL(p9_client_clunk);



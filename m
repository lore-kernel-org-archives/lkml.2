Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932363Ab1I1Wla (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 18:41:30 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53886 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932313Ab1I1WlT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:41:19 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:34 2011
Message-Id: <20110928220134.056592394@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 15:00:47 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Eric Van Hensbergen <ericvh@gmail.com>
Subject: [083/244] fs/9p: Fid is not valid after a failed clunk.
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

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
@@ -1250,9 +1250,11 @@ int p9_client_clunk(struct p9_fid *fid)
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



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932342Ab2L1ThY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 14:37:24 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55410 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932258Ab2L1TS5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 14:18:57 -0500
Message-Id: <20121228190346.129347293@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 28 Dec 2012 20:04:46 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "J. Bruce Fields" <bfields@redhat.com>
Subject: [ 076/173] nfsd: fix v4 reply caching
In-Reply-To: <20121228190330.025298996@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.217.219.220
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "J. Bruce Fields" <bfields@redhat.com>

commit 57d276d71aef7d8305ff002a070cb98deb2edced upstream.

Very embarassing: 1091006c5eb15cba56785bd5b498a8d0b9546903 "nfsd: turn
on reply cache for NFSv4" missed a line, effectively leaving the reply
cache off in the v4 case.  I thought I'd tested that, but I guess not.

This time, wrote a pynfs test to confirm it works.

Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/nfsd/nfssvc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfsd/nfssvc.c b/fs/nfsd/nfssvc.c
index 2013aa00..30d3784 100644
--- a/fs/nfsd/nfssvc.c
+++ b/fs/nfsd/nfssvc.c
@@ -640,7 +640,7 @@ nfsd_dispatch(struct svc_rqst *rqstp, __be32 *statp)
 	}
 
 	/* Store reply in cache. */
-	nfsd_cache_update(rqstp, proc->pc_cachetype, statp + 1);
+	nfsd_cache_update(rqstp, rqstp->rq_cachetype, statp + 1);
 	return 1;
 }
 



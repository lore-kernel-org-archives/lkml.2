Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933638Ab3AIVUE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 16:20:04 -0500
Received: from mail.kernel.org ([198.145.19.201]:42684 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933552Ab3AIUjW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 15:39:22 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        "J. Bruce Fields" <bfields@redhat.com>
Subject: [ 40/80] nfsd: fix v4 reply caching
Date: Wed,  9 Jan 2013 12:35:32 -0800
Message-Id: <20130109201505.562904671@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130109201500.410171651@linuxfoundation.org>
References: <20130109201500.410171651@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "J. Bruce Fields" <bfields@redhat.com>

commit 57d276d71aef7d8305ff002a070cb98deb2edced upstream.

Very embarassing: 1091006c5eb15cba56785bd5b498a8d0b9546903 "nfsd: turn
on reply cache for NFSv4" missed a line, effectively leaving the reply
cache off in the v4 case.  I thought I'd tested that, but I guess not.

This time, wrote a pynfs test to confirm it works.

Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfsd/nfssvc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/nfsd/nfssvc.c
+++ b/fs/nfsd/nfssvc.c
@@ -650,7 +650,7 @@ nfsd_dispatch(struct svc_rqst *rqstp, __
 	}
 
 	/* Store reply in cache. */
-	nfsd_cache_update(rqstp, proc->pc_cachetype, statp + 1);
+	nfsd_cache_update(rqstp, rqstp->rq_cachetype, statp + 1);
 	return 1;
 }
 



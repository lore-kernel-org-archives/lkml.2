Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934831Ab1KJFJ1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 00:09:27 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42331 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934739Ab1KJD0z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:26:55 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:27:09 2011
Message-Id: <20111109212709.651759648@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:26:53 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>,
        "J. Bruce Fields" <bfields@redhat.com>
Subject: [091/262] nfsd4: Remove check for a 32-bit cookie in nfsd4_readdir()
In-Reply-To: <20111109212847.GA20838@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>

commit 832023bffb4b493f230be901f681020caf3ed1f8 upstream.

Fan Yong <yong.fan@whamcloud.com> noticed setting
FMODE_32bithash wouldn't work with nfsd v4, as
nfsd4_readdir() checks for 32 bit cookies. However, according to RFC 3530
cookies have a 64 bit type and cookies are also defined as u64 in
'struct nfsd4_readdir'. So remove the test for >32-bit values.

Signed-off-by: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/nfsd/nfs4proc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -682,7 +682,7 @@ nfsd4_readdir(struct svc_rqst *rqstp, st
 	readdir->rd_bmval[1] &= nfsd_suppattrs1(cstate->minorversion);
 	readdir->rd_bmval[2] &= nfsd_suppattrs2(cstate->minorversion);
 
-	if ((cookie > ~(u32)0) || (cookie == 1) || (cookie == 2) ||
+	if ((cookie == 1) || (cookie == 2) ||
 	    (cookie == 0 && memcmp(readdir->rd_verf.data, zeroverf.data, NFS4_VERIFIER_SIZE)))
 		return nfserr_bad_cookie;
 



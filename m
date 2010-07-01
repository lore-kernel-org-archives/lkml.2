Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755271Ab0GAWES (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 18:04:18 -0400
Received: from kroah.org ([198.145.64.141]:33743 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758753Ab0GAVMw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 17:12:52 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:42:47 2010
Message-Id: <20100701174247.548099643@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:41:43 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Pavel Emelyanov <xemul@openvz.org>, NeilBrown <neilb@suse.de>,
       "J. Bruce Fields" <bfields@citi.umich.edu>
Subject: [013/200] NFSD: dont report compiled-out versions as present
In-Reply-To: <20100701175201.GA2149@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Emelyanov <xemul@openvz.org>

commit 15ddb4aec54422ead137b03ea4e9b3f5db3f7cc2 upstream.

The /proc/fs/nfsd/versions file calls nfsd_vers() to check whether
the particular nfsd version is present/available. The problem is
that once I turn off e.g. NFSD-V4 this call returns -1 which is
true from the callers POV which is wrong.

The proposal is to report false in that case.

The bug has existed since 6658d3a7bbfd1768 "[PATCH] knfsd: remove
nfsd_versbits as intermediate storage for desired versions".

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Acked-by: NeilBrown <neilb@suse.de>
Signed-off-by: J. Bruce Fields <bfields@citi.umich.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/nfsd/nfssvc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/nfsd/nfssvc.c
+++ b/fs/nfsd/nfssvc.c
@@ -120,7 +120,7 @@ u32 nfsd_supported_minorversion;
 int nfsd_vers(int vers, enum vers_op change)
 {
 	if (vers < NFSD_MINVERS || vers >= NFSD_NRVERS)
-		return -1;
+		return 0;
 	switch(change) {
 	case NFSD_SET:
 		nfsd_versions[vers] = nfsd_version[vers];



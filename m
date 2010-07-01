Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757577Ab0GASzu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 14:55:50 -0400
Received: from kroah.org ([198.145.64.141]:35275 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755840Ab0GASWf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 14:22:35 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:32:07 2010
Message-Id: <20100701173207.164795446@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:30:30 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Pavel Emelyanov <xemul@openvz.org>, NeilBrown <neilb@suse.de>,
       "J. Bruce Fields" <bfields@citi.umich.edu>
Subject: [patch 004/149] NFSD: dont report compiled-out versions as present
In-Reply-To: <20100701175144.GA2116@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

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
@@ -136,7 +136,7 @@ u32 nfsd_supported_minorversion;
 int nfsd_vers(int vers, enum vers_op change)
 {
 	if (vers < NFSD_MINVERS || vers >= NFSD_NRVERS)
-		return -1;
+		return 0;
 	switch(change) {
 	case NFSD_SET:
 		nfsd_versions[vers] = nfsd_version[vers];



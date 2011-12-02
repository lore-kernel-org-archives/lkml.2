Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932176Ab1LBSnF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 13:43:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:15721 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752694Ab1LBSnC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 13:43:02 -0500
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 02/21] MPILIB: Add a missing ENOMEM check [ver #3]
To: keyrings@linux-nfs.org
Cc: linux-crypto@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, dmitry.kasatkin@intel.com,
        zohar@linux.vnet.ibm.com, arjan.van.de.ven@intel.com,
        alan.cox@intel.com, David Howells <dhowells@redhat.com>
Date: Fri, 02 Dec 2011 18:42:54 +0000
Message-ID: <20111202184254.21874.48740.stgit@warthog.procyon.org.uk>
In-Reply-To: <20111202184229.21874.25782.stgit@warthog.procyon.org.uk>
References: <20111202184229.21874.25782.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a missing ENOMEM check.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 lib/mpi/mpicoder.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)


diff --git a/lib/mpi/mpicoder.c b/lib/mpi/mpicoder.c
index fe84bb9..716802b 100644
--- a/lib/mpi/mpicoder.c
+++ b/lib/mpi/mpicoder.c
@@ -255,6 +255,8 @@ void *mpi_get_buffer(MPI a, unsigned *nbytes, int *sign)
 	if (!n)
 		n++;		/* avoid zero length allocation */
 	p = buffer = kmalloc(n, GFP_KERNEL);
+	if (!p)
+		return NULL;
 
 	for (i = a->nlimbs - 1; i >= 0; i--) {
 		alimb = a->d[i];


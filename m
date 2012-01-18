Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757346Ab2ARKEF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 05:04:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64410 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757198Ab2ARKEC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 05:04:02 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] MPILIB: Add a missing ENOMEM check
To: jmorris@namei.org
Cc: keyrings@linux-nfs.org, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@kernel.org,
        David Howells <dhowells@redhat.com>, Mimi Zohar <zohar@us.ibm.com>
Date: Wed, 18 Jan 2012 10:03:54 +0000
Message-ID: <20120118100354.20549.9321.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a missing ENOMEM check.

Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Mimi Zohar <zohar@us.ibm.com>
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


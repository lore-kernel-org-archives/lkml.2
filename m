Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753558Ab0CXRJb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 13:09:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58374 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751679Ab0CXRJa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 13:09:30 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] do_sync_read/write() should set kiocb.ki_nbytes to be
	consistent
To: torvalds@osdl.org, akpm@linux-foundation.org, viro@zeniv.linux.org.uk
Cc: bcrl@kvack.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, David Howells <dhowells@redhat.com>
Date: Wed, 24 Mar 2010 17:09:19 +0000
Message-ID: <20100324170919.10928.26518.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

do_sync_read/write() should set kiocb.ki_nbytes to be consistent with
do_sync_readv_writev().

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/read_write.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)


diff --git a/fs/read_write.c b/fs/read_write.c
index b7f4a1f..113386d 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -258,6 +258,7 @@ ssize_t do_sync_read(struct file *filp, char __user *buf, size_t len, loff_t *pp
 	init_sync_kiocb(&kiocb, filp);
 	kiocb.ki_pos = *ppos;
 	kiocb.ki_left = len;
+	kiocb.ki_nbytes = len;
 
 	for (;;) {
 		ret = filp->f_op->aio_read(&kiocb, &iov, 1, kiocb.ki_pos);
@@ -313,6 +314,7 @@ ssize_t do_sync_write(struct file *filp, const char __user *buf, size_t len, lof
 	init_sync_kiocb(&kiocb, filp);
 	kiocb.ki_pos = *ppos;
 	kiocb.ki_left = len;
+	kiocb.ki_nbytes = len;
 
 	for (;;) {
 		ret = filp->f_op->aio_write(&kiocb, &iov, 1, kiocb.ki_pos);


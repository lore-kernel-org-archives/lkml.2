Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754417Ab2BEWkO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 17:40:14 -0500
Received: from 1wt.eu ([62.212.114.60]:62011 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753848Ab2BEW0k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 17:26:40 -0500
Message-Id: <20120205220951.845011258@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Sun, 05 Feb 2012 23:10:45 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: [PATCH 56/91] hfs: add sanity check for file name length
In-Reply-To: <0635750f5f06ed2ca212b91fcb5c4483@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-longterm review patch.  If anyone has any objections, please let us know.

------------------

commit bc5b8a9003132ae44559edd63a1623b7b99dfb68 upstream.

On a corrupted file system the ->len field could be wrong leading to
a buffer overflow.

Reported-and-acked-by: Clement LECIGNE <clement.lecigne@netasq.com>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/hfs/trans.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

Index: longterm-2.6.27/fs/hfs/trans.c
===================================================================
--- longterm-2.6.27.orig/fs/hfs/trans.c	2012-02-05 22:34:33.296915074 +0100
+++ longterm-2.6.27/fs/hfs/trans.c	2012-02-05 22:34:42.844914477 +0100
@@ -40,6 +40,8 @@
 
 	src = in->name;
 	srclen = in->len;
+	if (srclen > HFS_NAMELEN)
+		srclen = HFS_NAMELEN;
 	dst = out;
 	dstlen = HFS_MAX_NAMELEN;
 	if (nls_io) {



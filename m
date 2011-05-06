Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932438Ab1EFAZt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 20:25:49 -0400
Received: from kroah.org ([198.145.64.141]:37199 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932406Ab1EFAZn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 20:25:43 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May  5 17:22:16 2011
Message-Id: <20110506002215.952123804@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 05 May 2011 17:21:34 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Hagen Paul Pfeifer <hagen@jauu.net>,
        "David S. Miller" <davem@davemloft.net>
Subject: [109/143] econet: Fix redeclaration of symbol len
In-Reply-To: <20110506002311.GA15354@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Hagen Paul Pfeifer <hagen@jauu.net>

commit 9e8342971d44ce86d8567047f5366fc1c06a75ed upstream.

Function argument len was redeclarated within the
function. This patch fix the redeclaration of symbol 'len'.

Signed-off-by: Hagen Paul Pfeifer <hagen@jauu.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
[Adjusted to apply to 2.6.32 by dann frazier <dannf@debian.org>]
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/econet/af_econet.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/net/econet/af_econet.c
+++ b/net/econet/af_econet.c
@@ -447,15 +447,15 @@ static int econet_sendmsg(struct kiocb *
 	iov[0].iov_len = size;
 	for (i = 0; i < msg->msg_iovlen; i++) {
 		void __user *base = msg->msg_iov[i].iov_base;
-		size_t len = msg->msg_iov[i].iov_len;
+		size_t iov_len = msg->msg_iov[i].iov_len;
 		/* Check it now since we switch to KERNEL_DS later. */
-		if (!access_ok(VERIFY_READ, base, len)) {
+		if (!access_ok(VERIFY_READ, base, iov_len)) {
 			mutex_unlock(&econet_mutex);
 			return -EFAULT;
 		}
 		iov[i+1].iov_base = base;
-		iov[i+1].iov_len = len;
-		size += len;
+		iov[i+1].iov_len = iov_len;
+		size += iov_len;
 	}
 
 	/* Get a skbuff (no data, just holds our cb information) */



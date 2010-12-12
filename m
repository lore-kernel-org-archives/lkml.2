Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755744Ab0LLXs3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 18:48:29 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36802 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755093Ab0LLXs1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:48:27 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: torvalds@linux-foundation.org, davem@davemloft.net, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [199/223] net: Truncate recvfrom and sendto length to INT_MAX.
Message-Id: <20101212234825.AD122B27BF@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:48:25 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Linus Torvalds <torvalds@linux-foundation.org>

commit 253eacc070b114c2ec1f81b067d2fed7305467b0 upstream.

Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 net/socket.c |    4 ++++
 1 file changed, 4 insertions(+)

Index: linux/net/socket.c
===================================================================
--- linux.orig/net/socket.c
+++ linux/net/socket.c
@@ -1652,6 +1652,8 @@ SYSCALL_DEFINE6(sendto, int, fd, void __
 	struct iovec iov;
 	int fput_needed;
 
+	if (len > INT_MAX)
+		len = INT_MAX;
 	sock = sockfd_lookup_light(fd, &err, &fput_needed);
 	if (!sock)
 		goto out;
@@ -1709,6 +1711,8 @@ SYSCALL_DEFINE6(recvfrom, int, fd, void
 	int err, err2;
 	int fput_needed;
 
+	if (size > INT_MAX)
+		size = INT_MAX;
 	sock = sockfd_lookup_light(fd, &err, &fput_needed);
 	if (!sock)
 		goto out;

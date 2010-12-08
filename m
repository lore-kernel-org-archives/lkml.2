Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756560Ab0LHAuV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 19:50:21 -0500
Received: from kroah.org ([198.145.64.141]:58733 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756499Ab0LHAsU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 19:48:20 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:44:36 2010
Message-Id: <20101208004436.230641263@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:45:05 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "David S. Miller" <davem@davemloft.net>
Subject: [119/127] net: Truncate recvfrom and sendto length to INT_MAX.
In-Reply-To: <20101208004456.GA23578@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

commit 253eacc070b114c2ec1f81b067d2fed7305467b0 upstream.

Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/socket.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/net/socket.c
+++ b/net/socket.c
@@ -1673,6 +1673,8 @@ SYSCALL_DEFINE6(sendto, int, fd, void __
 	struct iovec iov;
 	int fput_needed;
 
+	if (len > INT_MAX)
+		len = INT_MAX;
 	sock = sockfd_lookup_light(fd, &err, &fput_needed);
 	if (!sock)
 		goto out;
@@ -1730,6 +1732,8 @@ SYSCALL_DEFINE6(recvfrom, int, fd, void
 	int err, err2;
 	int fput_needed;
 
+	if (size > INT_MAX)
+		size = INT_MAX;
 	sock = sockfd_lookup_light(fd, &err, &fput_needed);
 	if (!sock)
 		goto out;



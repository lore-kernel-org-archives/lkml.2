Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964974Ab1DNSNx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 14:13:53 -0400
Received: from mail.windriver.com ([147.11.1.11]:41942 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964932Ab1DNR6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:58:17 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 126/209] net: Truncate recvfrom and sendto length to INT_MAX.
Date: Thu, 14 Apr 2011 13:54:44 -0400
Message-Id: <1302803767-9715-13-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1302803767-9715-1-git-send-email-paul.gortmaker@windriver.com>
References: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
 <1302803767-9715-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

  =====================================================================
  | This is a commit scheduled for the next v2.6.34 longterm release. |
  | If you see a problem with using this for longterm, please comment.|
  =====================================================================

commit 253eacc070b114c2ec1f81b067d2fed7305467b0 upstream.

Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 net/socket.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/net/socket.c b/net/socket.c
index 5e8d0af..c63ebf4 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -1672,6 +1672,8 @@ SYSCALL_DEFINE6(sendto, int, fd, void __user *, buff, size_t, len,
 	struct iovec iov;
 	int fput_needed;
 
+	if (len > INT_MAX)
+		len = INT_MAX;
 	sock = sockfd_lookup_light(fd, &err, &fput_needed);
 	if (!sock)
 		goto out;
@@ -1729,6 +1731,8 @@ SYSCALL_DEFINE6(recvfrom, int, fd, void __user *, ubuf, size_t, size,
 	int err, err2;
 	int fput_needed;
 
+	if (size > INT_MAX)
+		size = INT_MAX;
 	sock = sockfd_lookup_light(fd, &err, &fput_needed);
 	if (!sock)
 		goto out;
-- 
1.7.4.4


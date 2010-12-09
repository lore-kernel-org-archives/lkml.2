Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754123Ab0LIQ0n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 11:26:43 -0500
Received: from chrocht.moloch.sk ([62.176.169.44]:45788 "EHLO mail.moloch.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750972Ab0LIQ0m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 11:26:42 -0500
X-Greylist: delayed 545 seconds by postgrey-1.27 at vger.kernel.org; Thu, 09 Dec 2010 11:26:42 EST
Date: Thu, 9 Dec 2010 17:17:34 +0100
From: Martin Lucina <mato@kotelna.sk>
To: linux-kernel@vger.kernel.org
Cc: Martin Sustrik <sustrik@250bpm.com>
Subject: [PATCH] Document the kernel_recvmsg() function
Message-ID: <20101209161734.GA16822@dezo.moloch.sk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

so, today we spent all day figuring out how the kernel_sendmsg() function
*actually* works. This patch adds some documentation to help the next poor
sod.

-mato

>From b29ccddeec4b782d710ffe34e0e5e4a0f5e9c24b Mon Sep 17 00:00:00 2001
From: Martin Lucina <mato@kotelna.sk>
Date: Thu, 9 Dec 2010 17:11:18 +0100
Subject: [PATCH] Document the kernel_recvmsg() function

Signed-off-by: Martin Lucina <mato@kotelna.sk>
---
 net/socket.c |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/net/socket.c b/net/socket.c
index 3ca2fd9..b17333d 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -732,6 +732,21 @@ static int sock_recvmsg_nosec(struct socket *sock, struct msghdr *msg,
 	return ret;
 }
 
+/**
+ * kernel_recvmsg() - Receive a message from a socket (kernel space)
+ * @sock:       The socket to receive the message from
+ * @msg:        Received message
+ * @vec:        Input s/g array for message data
+ * @num:        Size of input s/g array
+ * @size:       Number of bytes to read
+ * @flags:      Message flags (MSG_DONTWAIT, etc...)
+ *
+ * On return the msg structure contains the scatter/gather array passed in the
+ * vec argument. The array is modified so that it consists of the unfilled
+ * portion of the original array.
+ *
+ * The returned value is the total number of bytes received, or an error.
+ */
 int kernel_recvmsg(struct socket *sock, struct msghdr *msg,
 		   struct kvec *vec, size_t num, size_t size, int flags)
 {
-- 
1.7.1


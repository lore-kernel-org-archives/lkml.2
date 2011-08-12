Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753645Ab1HNQGc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 12:06:32 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36332 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753650Ab1HNQG3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 12:06:29 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Aug 12 14:05:53 2011
Message-Id: <20110812210553.507379033@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 12 Aug 2011 14:04:01 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Anton Blanchard <anton@samba.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [16/90] net: Cap number of elements for sendmmsg
In-Reply-To: <20110812210626.GA4725@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Anton Blanchard <anton@samba.org>

commit 98382f419f32d2c12d021943b87dea555677144b upstream.

To limit the amount of time we can spend in sendmmsg, cap the
number of elements to UIO_MAXIOV (currently 1024).

For error handling an application using sendmmsg needs to retry at
the first unsent message, so capping is simpler and requires less
application logic than returning EINVAL.

Signed-off-by: Anton Blanchard <anton@samba.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/socket.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/socket.c
+++ b/net/socket.c
@@ -1999,6 +1999,9 @@ int __sys_sendmmsg(int fd, struct mmsghd
 	struct compat_mmsghdr __user *compat_entry;
 	struct msghdr msg_sys;
 
+	if (vlen > UIO_MAXIOV)
+		vlen = UIO_MAXIOV;
+
 	datagrams = 0;
 
 	sock = sockfd_lookup_light(fd, &err, &fput_needed);



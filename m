Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755501Ab2BBK2f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 05:28:35 -0500
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:1153 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755459Ab2BBK2d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 05:28:33 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Al Viro <viro@zeniv.linux.org.uk>, Jonathan Corbet <corbet@lwn.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Davide Libenzi <davidel@xmailserver.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Enke Chen <enkechen@cisco.com>, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv7 PATCH 4/4] unix/af_unix.c: use poll_requested_events() in unix_dgram_poll()
Date: Thu,  2 Feb 2012 11:26:57 +0100
Message-Id: <7c1c5f836b511ead7c5b232fd5133a84ecf8fd37.1328176079.git.hans.verkuil@cisco.com>
X-Mailer: git-send-email 1.7.8.3
In-Reply-To: <1328178417-3876-1-git-send-email-hverkuil@xs4all.nl>
References: <1328178417-3876-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <a92b9a00741769f3c38a54d3a6799509f9089452.1328176079.git.hans.verkuil@cisco.com>
References: <a92b9a00741769f3c38a54d3a6799509f9089452.1328176079.git.hans.verkuil@cisco.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hans Verkuil <hans.verkuil@cisco.com>

Rather than accessing the poll_table internals use the new
poll_requested_events() function.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 net/unix/af_unix.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 85d3bb7..59f5202 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -2175,7 +2175,7 @@ static unsigned int unix_dgram_poll(struct file *file, struct socket *sock,
 	}
 
 	/* No write status requested, avoid expensive OUT tests. */
-	if (wait && !(wait->key & (POLLWRBAND | POLLWRNORM | POLLOUT)))
+	if (!(poll_requested_events(wait) & (POLLWRBAND | POLLWRNORM | POLLOUT)))
 		return mask;
 
 	writable = unix_writable(sk);
-- 
1.7.8.3


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755775Ab2HOQYx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 12:24:53 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:21193 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755159Ab2HOQYv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 12:24:51 -0400
Subject: [RFC PATCH 3/5] net: new protocol operation fbind() introduced
To: tglx@linutronix.de, mingo@redhat.com, davem@davemloft.net, hpa@zytor.com
From: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: thierry.reding@avionic-design.de, bfields@redhat.com,
        eric.dumazet@gmail.com, xemul@parallels.com, neilb@suse.de,
        netdev@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        paul.gortmaker@windriver.com, viro@zeniv.linux.org.uk,
        gorcunov@openvz.org, akpm@linux-foundation.org,
        tim.c.chen@linux.intel.com, devel@openvz.org, ebiederm@xmission.com
Date: Wed, 15 Aug 2012 20:22:14 +0400
Message-ID: <20120815162214.7598.44496.stgit@localhost.localdomain>
In-Reply-To: <20120815161141.7598.16682.stgit@localhost.localdomain>
References: <20120815161141.7598.16682.stgit@localhost.localdomain>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This operation is used to bind socket to specified file.

Signed-off-by: Stanislav Kinsbursky <skinsbursky@parallels.com>
---
 include/linux/net.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/net.h b/include/linux/net.h
index e9ac2df..843cb75 100644
--- a/include/linux/net.h
+++ b/include/linux/net.h
@@ -157,6 +157,7 @@ struct kiocb;
 struct sockaddr;
 struct msghdr;
 struct module;
+struct path;
 
 struct proto_ops {
 	int		family;
@@ -165,6 +166,7 @@ struct proto_ops {
 	int		(*bind)	     (struct socket *sock,
 				      struct sockaddr *myaddr,
 				      int sockaddr_len);
+	int		(*fbind)     (struct file *file, struct socket *sock);
 	int		(*connect)   (struct socket *sock,
 				      struct sockaddr *vaddr,
 				      int sockaddr_len, int flags);


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755436Ab1IBT5o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 15:57:44 -0400
Received: from 50-56-35-84.static.cloud-ips.com ([50.56.35.84]:39528 "EHLO
	mail" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755263Ab1IBTz7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 15:55:59 -0400
From: Serge Hallyn <serge@hallyn.com>
To: akpm@osdl.org, segooon@gmail.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, containers@lists.linux-foundation.org,
        dhowells@redhat.com, ebiederm@xmission.com, rdunlap@xenotime.net
Cc: "Serge E. Hallyn" <serge.hallyn@canonical.com>
Subject: [PATCH 12/15] user_ns: target af_key capability check
Date: Fri,  2 Sep 2011 19:56:37 +0000
Message-Id: <1314993400-6910-15-git-send-email-serge@hallyn.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1314993400-6910-1-git-send-email-serge@hallyn.com>
References: <1314993400-6910-1-git-send-email-serge@hallyn.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Serge E. Hallyn" <serge.hallyn@canonical.com>

This presumes that it really is complete wrt network namespaces.  Looking
at the code it appears to be.

Signed-off-by: Serge E. Hallyn <serge.hallyn@canonical.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
---
 net/key/af_key.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/key/af_key.c b/net/key/af_key.c
index 1e733e9..1f90f4e 100644
--- a/net/key/af_key.c
+++ b/net/key/af_key.c
@@ -141,7 +141,7 @@ static int pfkey_create(struct net *net, struct socket *sock, int protocol,
 	struct sock *sk;
 	int err;
 
-	if (!capable(CAP_NET_ADMIN))
+	if (!ns_capable(net->user_ns, CAP_NET_ADMIN))
 		return -EPERM;
 	if (sock->type != SOCK_RAW)
 		return -ESOCKTNOSUPPORT;
-- 
1.7.5.4


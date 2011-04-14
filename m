Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933399Ab1DNRrM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 13:47:12 -0400
Received: from mail.windriver.com ([147.11.1.11]:38462 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932892Ab1DNRrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:47:10 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Dan Rosenberg <drosenberg@vsecurity.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 094/209] DECnet: don't leak uninitialized stack byte
Date: Thu, 14 Apr 2011 13:42:04 -0400
Message-Id: <1302803039-9400-95-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
References: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Rosenberg <drosenberg@vsecurity.com>

  =====================================================================
  | This is a commit scheduled for the next v2.6.34 longterm release. |
  | If you see a problem with using this for longterm, please comment.|
  =====================================================================

commit 3c6f27bf33052ea6ba9d82369fb460726fb779c0 upstream.

A single uninitialized padding byte is leaked to userspace.

Signed-off-by: Dan Rosenberg <drosenberg@vsecurity.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 net/decnet/af_decnet.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/net/decnet/af_decnet.c b/net/decnet/af_decnet.c
index 2b494fa..7cc13e1 100644
--- a/net/decnet/af_decnet.c
+++ b/net/decnet/af_decnet.c
@@ -1556,6 +1556,8 @@ static int __dn_getsockopt(struct socket *sock, int level,int optname, char __us
 			if (r_len > sizeof(struct linkinfo_dn))
 				r_len = sizeof(struct linkinfo_dn);
 
+			memset(&link, 0, sizeof(link));
+
 			switch(sock->state) {
 				case SS_CONNECTING:
 					link.idn_linkstate = LL_CONNECTING;
-- 
1.7.4.4


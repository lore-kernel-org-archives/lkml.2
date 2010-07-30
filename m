Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753155Ab0G3XzG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 19:55:06 -0400
Received: from prod-mail-xrelay02.akamai.com ([72.246.2.14]:38970 "EHLO
	prod-mail-xrelay02.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752012Ab0G3XzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 19:55:03 -0400
X-Greylist: delayed 326 seconds by postgrey-1.27 at vger.kernel.org; Fri, 30 Jul 2010 19:55:03 EDT
From: Josh Hunt <johunt@akamai.com>
To: davem@davemloft.net, kuznet@ms2.inr.ac.ru, jmorris@namei.org,
        kaber@trash.net
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, juhlenko@akamai.com,
        apetlund@simula.no
Subject: [PATCH] net: Add getsockopt support for TCP thin-streams
Date: Fri, 30 Jul 2010 16:49:35 -0700
Message-Id: <1280533775-7700-1-git-send-email-johunt@akamai.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Initial TCP thin-stream commit did not add getsockopt support for the new
socket options: TCP_THIN_LINEAR_TIMEOUTS and TCP_THIN_DUPACK. This adds support
for them.

Signed-off-by: Josh Hunt <johunt@akamai.com>
---
 net/ipv4/tcp.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 65afeae..3ed3525 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -2591,6 +2591,12 @@ static int do_tcp_getsockopt(struct sock *sk, int level,
 			return -EFAULT;
 		return 0;
 	}
+	case TCP_THIN_LINEAR_TIMEOUTS:
+		val = tp->thin_lto;
+		break;
+	case TCP_THIN_DUPACK:
+		val = tp->thin_dupack;
+		break;
 	default:
 		return -ENOPROTOOPT;
 	}
-- 
1.7.0.4


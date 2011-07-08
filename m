Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753476Ab1GIF7N (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jul 2011 01:59:13 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:37335 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752362Ab1GIFy2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jul 2011 01:54:28 -0400
X-Sasl-enc: lbnq2LpauFm+6XiEf5/ga+M9biSFBjHdQaJB95fTDtjM 1310190868
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Jul  8 15:51:21 2011
Message-Id: <20110708225121.696445484@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 08 Jul 2011 15:50:19 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Joe Perches <joe@perches.com>, "David S. Miller" <davem@davemloft.net>
Subject: [30/35] net: filter: Use WARN_RATELIMIT
In-Reply-To: <20110708225343.GA14402@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------


From: Joe Perches <joe@perches.com>

[ Upstream commit 6c4a5cb219520c7bc937ee186ca53f03733bd09f ]

A mis-configured filter can spam the logs with lots of stack traces.

Rate-limit the warnings and add printout of the bogus filter information.

Original-patch-by: Ben Greear <greearb@candelatech.com>
Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/core/filter.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -291,7 +291,9 @@ load_b:
 			mem[f_k] = X;
 			continue;
 		default:
-			WARN_ON(1);
+			WARN_RATELIMIT(1, "Unknown code:%u jt:%u tf:%u k:%u\n",
+				       fentry->code, fentry->jt,
+				       fentry->jf, fentry->k);
 			return 0;
 		}
 



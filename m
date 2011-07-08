Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753189Ab1GIGES (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jul 2011 02:04:18 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:48877 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753873Ab1GIGBU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jul 2011 02:01:20 -0400
X-Sasl-enc: a6xyKsskDlWiLgdK1I/VQhQ5dcxCGOh6Ver2Y0LeiW31 1310191279
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Jul  8 16:01:12 2011
Message-Id: <20110708230112.534484341@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 08 Jul 2011 16:00:46 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Joe Perches <joe@perches.com>, "David S. Miller" <davem@davemloft.net>
Subject: [30/35] net: filter: Use WARN_RATELIMIT
In-Reply-To: <20110708230122.GA18807@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

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
@@ -285,7 +285,9 @@ load_b:
 			mem[fentry->k] = X;
 			continue;
 		default:
-			WARN_ON(1);
+			WARN_RATELIMIT(1, "Unknown code:%u jt:%u tf:%u k:%u\n",
+				       fentry->code, fentry->jt,
+				       fentry->jf, fentry->k);
 			return 0;
 		}
 



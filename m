Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933071Ab1I1Wr1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 18:47:27 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54671 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933046Ab1I1WrV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:47:21 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:44 2011
Message-Id: <20110928220144.846430459@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 15:02:29 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Zheng Yan <zheng.z.yan@intel.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [185/244] tcp: fix validation of D-SACK
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Zheng Yan <zheng.z.yan@intel.com>

[ Upstream commit f779b2d60ab95c17f1e025778ed0df3ec2f05d75 ]

D-SACK is allowed to reside below snd_una. But the corresponding check
in tcp_is_sackblock_valid() is the exact opposite. It looks like a typo.

Signed-off-by: Zheng Yan <zheng.z.yan@intel.com>
Acked-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/ipv4/tcp_input.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -1115,7 +1115,7 @@ static int tcp_is_sackblock_valid(struct
 		return 0;
 
 	/* ...Then it's D-SACK, and must reside below snd_una completely */
-	if (!after(end_seq, tp->snd_una))
+	if (after(end_seq, tp->snd_una))
 		return 0;
 
 	if (!before(start_seq, tp->undo_marker))



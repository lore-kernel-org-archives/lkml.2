Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754286Ab1HNQIR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 12:08:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36625 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754254Ab1HNQIO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 12:08:14 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Aug 12 14:05:56 2011
Message-Id: <20110812210556.137927030@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 12 Aug 2011 14:04:31 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Julian Anastasov <ja@ssi.bg>,
        Hans Schillstrom <hans.schillstrom@ericsson.com>,
        Simon Horman <horms@verge.net.au>
Subject: [46/90] IPVS: Free resources on module removal
In-Reply-To: <20110812210626.GA4725@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Simon Horman <horms@verge.net.au>

[ Upstream commit 7676e345824f162191b1fe2058ad948a6cf91c20 ]

This resolves a panic on module removal.

Reported-by: Dave Jones <davej@redhat.com>
Acked-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Hans Schillstrom <hans.schillstrom@ericsson.com>
Signed-off-by: Simon Horman <horms@verge.net.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/netfilter/ipvs/ip_vs_ctl.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -3771,6 +3771,7 @@ err_sock:
 void ip_vs_control_cleanup(void)
 {
 	EnterFunction(2);
+	unregister_netdevice_notifier(&ip_vs_dst_notifier);
 	ip_vs_genl_unregister();
 	nf_unregister_sockopt(&ip_vs_sockopts);
 	LeaveFunction(2);



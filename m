Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756472Ab2J1X1N (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 19:27:13 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:41854 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756375Ab2J1X1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 19:27:09 -0400
Message-Id: <20121028231607.762079593@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 28 Oct 2012 23:17:15 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [ 099/105] Revert "lockd: use rpc clients cl_nodename for id encoding"
In-Reply-To: <20121028231536.970033833@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Hutchings <ben@decadent.org.uk>

This reverts 5ff39e971c87ea9f4c4c7b253898abafa960e32b which was commit
303a7ce92064c285a04c870f2dc0192fdb2968cb upstream.

It is not necessary for kernel versions without per-netns RPC clients.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/lockd/mon.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/fs/lockd/mon.c
+++ b/fs/lockd/mon.c
@@ -40,7 +40,6 @@ struct nsm_args {
 	u32			proc;
 
 	char			*mon_name;
-	char			*nodename;
 };
 
 struct nsm_res {
@@ -94,7 +93,6 @@ static int nsm_mon_unmon(struct nsm_hand
 		.vers		= 3,
 		.proc		= NLMPROC_NSM_NOTIFY,
 		.mon_name	= nsm->sm_mon_name,
-		.nodename	= utsname()->nodename,
 	};
 	struct rpc_message msg = {
 		.rpc_argp	= &args,
@@ -431,7 +429,7 @@ static void encode_my_id(struct xdr_stre
 {
 	__be32 *p;
 
-	encode_nsm_string(xdr, argp->nodename);
+	encode_nsm_string(xdr, utsname()->nodename);
 	p = xdr_reserve_space(xdr, 4 + 4 + 4);
 	*p++ = cpu_to_be32(argp->prog);
 	*p++ = cpu_to_be32(argp->vers);



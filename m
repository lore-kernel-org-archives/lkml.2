Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754942Ab0EYFOw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 01:14:52 -0400
Received: from ringil.hengli.com.au ([216.59.3.182]:44604 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751266Ab0EYFOv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 01:14:51 -0400
Date: Tue, 25 May 2010 15:14:42 +1000
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: David Miller <davem@davemloft.net>
Cc: sfr@canb.auug.org.au, netdev@vger.kernel.org, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the final tree
Message-ID: <20100525051442.GA8480@gondor.apana.org.au>
References: <20100525141046.975afe1f.sfr@canb.auug.org.au> <20100524.215851.207470612.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100524.215851.207470612.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 24, 2010 at 09:58:51PM -0700, David Miller wrote:
> 
> Herbert, can you take a look?

Sorry, I hadn't tested the built-in case.

cls_cgroup: Fix build error when built-in

There is a typo in cgroup_cls_state when cls_cgroup is built-in.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/include/net/cls_cgroup.h b/include/net/cls_cgroup.h
index f9a0b01..4e75a1f 100644
--- a/include/net/cls_cgroup.h
+++ b/include/net/cls_cgroup.h
@@ -31,7 +31,7 @@ static inline u32 task_cls_classid(struct task_struct *p)
 		return 0;
 
 	return container_of(task_subsys_state(p, net_cls_subsys_id),
-			    struct cgroup_cls_state, css).classid;
+			    struct cgroup_cls_state, css)->classid;
 }
 #else
 extern int net_cls_subsys_id;

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755864Ab0I2UgB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 16:36:01 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:34123 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752120Ab0I2Uf7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 16:35:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=oMv3PsP0Artbwln4NBy0KbwdwmH4cf7f7mo4f+8iNMceLlGALD1ctYZSDXj9PsJf0F
         L6MyDR6GQ5gi3DYkueRz5OH00FRSJMTJqZEyK6qFdh9HxBspCYI+tYBMFrOQdnplV0yL
         JZHJkg4oldQiJV2dujLDvNGD0FI9euIGNd5Lw=
Message-ID: <4CA3BFA3.1060204@gmail.com>
Date: Thu, 30 Sep 2010 00:37:23 +0200
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Thunderbird/3.1.4
MIME-Version: 1.0
To: "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] [XFRM]: Don't dereference error pointer dst1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't dereference dst1 when it's an error pointer.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 net/xfrm/xfrm_policy.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

I just noticed this by code analysis. It wasn't tested in any way.

diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index cbab6e1..b186c3d 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -1414,13 +1414,14 @@ static struct dst_entry *xfrm_bundle_create(struct xfrm_policy *policy,
 
 	for (; i < nx; i++) {
 		struct xfrm_dst *xdst = xfrm_alloc_dst(net, family);
-		struct dst_entry *dst1 = &xdst->u.dst;
+		struct dst_entry *dst1;
 
 		err = PTR_ERR(xdst);
 		if (IS_ERR(xdst)) {
 			dst_release(dst);
 			goto put_states;
 		}
+		dst1 = &xdst->u.dst;
 
 		if (!dst_prev)
 			dst0 = dst1;


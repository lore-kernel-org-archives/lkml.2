Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932798Ab0C3X1e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 19:27:34 -0400
Received: from kroah.org ([198.145.64.141]:46801 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756965Ab0C3XWE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:22:04 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:48:52 2010
Message-Id: <20100330224851.632237211@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:42:54 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Pablo Neira Ayuso <pablo@netfilter.org>,
       "David S. Miller" <davem@davemloft.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [140/156] netlink: fix unaligned access in nla_get_be64()
In-Reply-To: <20100330230630.GA28824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit f5d410f2ea7ba340f11815a56e05b9fa9421c421 ]

This patch fixes a unaligned access in nla_get_be64() that was
introduced by myself in a17c859849402315613a0015ac8fbf101acf0cc1.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/net/netlink.h |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/include/net/netlink.h
+++ b/include/net/netlink.h
@@ -945,7 +945,11 @@ static inline u64 nla_get_u64(const stru
  */
 static inline __be64 nla_get_be64(const struct nlattr *nla)
 {
-	return *(__be64 *) nla_data(nla);
+	__be64 tmp;
+
+	nla_memcpy(&tmp, nla, sizeof(tmp));
+
+	return tmp;
 }
 
 /**



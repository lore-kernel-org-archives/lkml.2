Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755794Ab2J1X0i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 19:26:38 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:41719 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751612Ab2J1X0g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 19:26:36 -0400
Message-Id: <20121028231537.411940652@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 28 Oct 2012 23:15:37 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jan Engelhardt <jengelh@medozas.de>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [ 001/105] netfilter: ipset: avoid use of kernel-only types
In-Reply-To: <20121028231536.970033833@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Engelhardt <jengelh@medozas.de>

commit 5276e16bb6f35412583518d6f04651dd9dc114be upstream.

When using the xt_set.h header in userspace, one will get these gcc
reports:

ipset/ip_set.h:184:1: error: unknown type name "u16"
In file included from libxt_SET.c:21:0:
netfilter/xt_set.h:61:2: error: unknown type name "u32"
netfilter/xt_set.h:62:2: error: unknown type name "u32"

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 include/linux/netfilter/xt_set.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/netfilter/xt_set.h b/include/linux/netfilter/xt_set.h
index c0405ac..e3a9978 100644
--- a/include/linux/netfilter/xt_set.h
+++ b/include/linux/netfilter/xt_set.h
@@ -58,8 +58,8 @@ struct xt_set_info_target_v1 {
 struct xt_set_info_target_v2 {
 	struct xt_set_info add_set;
 	struct xt_set_info del_set;
-	u32 flags;
-	u32 timeout;
+	__u32 flags;
+	__u32 timeout;
 };
 
 #endif /*_XT_SET_H*/



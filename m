Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935614Ab1KJDdg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 22:33:36 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43182 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935593Ab1KJDdd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:33:33 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:27:25 2011
Message-Id: <20111109212725.342271409@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:29:28 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, David Ward <david.ward@ll.mit.edu>,
        "David S. Miller" <davem@davemloft.net>,
        Kim Phillips <kim.phillips@freescale.com>
Subject: [246/262] net: Align AF-specific flowi structs to long
In-Reply-To: <20111109212847.GA20838@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Ward <david.ward@ll.mit.edu>

commit 728871bc05afc8ff310b17dba3e57a2472792b13 upstream.

AF-specific flowi structs are now passed to flow_key_compare, which must
also be aligned to a long.

Signed-off-by: David Ward <david.ward@ll.mit.edu>
Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: Kim Phillips <kim.phillips@freescale.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/net/flow.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/include/net/flow.h
+++ b/include/net/flow.h
@@ -68,7 +68,7 @@ struct flowi4 {
 #define fl4_ipsec_spi		uli.spi
 #define fl4_mh_type		uli.mht.type
 #define fl4_gre_key		uli.gre_key
-};
+} __attribute__((__aligned__(BITS_PER_LONG/8)));
 
 static inline void flowi4_init_output(struct flowi4 *fl4, int oif,
 				      __u32 mark, __u8 tos, __u8 scope,
@@ -112,7 +112,7 @@ struct flowi6 {
 #define fl6_ipsec_spi		uli.spi
 #define fl6_mh_type		uli.mht.type
 #define fl6_gre_key		uli.gre_key
-};
+} __attribute__((__aligned__(BITS_PER_LONG/8)));
 
 struct flowidn {
 	struct flowi_common	__fl_common;
@@ -127,7 +127,7 @@ struct flowidn {
 	union flowi_uli		uli;
 #define fld_sport		uli.ports.sport
 #define fld_dport		uli.ports.dport
-};
+} __attribute__((__aligned__(BITS_PER_LONG/8)));
 
 struct flowi {
 	union {



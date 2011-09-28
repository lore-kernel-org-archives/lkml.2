Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932102Ab1I1WjV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 18:39:21 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53644 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755639Ab1I1WjR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:39:17 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:30 2011
Message-Id: <20110928220130.427645088@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 15:00:13 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Srinivas Kandagatla <srinivas.kandagatla@st.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [049/244] ARM: 7014/1: cache-l2x0: Fix L2 Cache size calculation.
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Srinivas Kandagatla <srinivas.kandagatla@st.com>

commit 43c734be5571a4daad9f0a3e0b3229a1c0049917 upstream.

This patch fixes L2 Cache size calculations for L2C-210, L2C-310 and
PL310, by changing the L2X0_AUX_CTRL_WAY_SIZE_MASK from 2 bits to 3
bits.

The Auxiliary Control Register for L2C-210, L2C-310 and PL310 has 3bits
[19:17] for Way size, however the existing code only uses 2 bits to
get this value. This results in incorrect cachesize calculations.

It also results in performing operations on the whole cache when we
erroneously decide that the range is big enough (due to l2x0_size being
too small) and also prints incorrect cachesize.

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@st.com>
Acked-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/arm/include/asm/hardware/cache-l2x0.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/include/asm/hardware/cache-l2x0.h
+++ b/arch/arm/include/asm/hardware/cache-l2x0.h
@@ -64,7 +64,7 @@
 #define L2X0_AUX_CTRL_MASK			0xc0000fff
 #define L2X0_AUX_CTRL_ASSOCIATIVITY_SHIFT	16
 #define L2X0_AUX_CTRL_WAY_SIZE_SHIFT		17
-#define L2X0_AUX_CTRL_WAY_SIZE_MASK		(0x3 << 17)
+#define L2X0_AUX_CTRL_WAY_SIZE_MASK		(0x7 << 17)
 #define L2X0_AUX_CTRL_SHARE_OVERRIDE_SHIFT	22
 #define L2X0_AUX_CTRL_NS_LOCKDOWN_SHIFT		26
 #define L2X0_AUX_CTRL_NS_INT_CTRL_SHIFT		27



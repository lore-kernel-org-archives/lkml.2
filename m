Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753247Ab1AEXG2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 18:06:28 -0500
Received: from kroah.org ([198.145.64.141]:50755 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753079Ab1AEXGY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 18:06:24 -0500
X-Mailbox-Line: From gregkh@clark.site Wed Jan  5 15:03:25 2011
Message-Id: <20110105230324.955715805@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 05 Jan 2011 15:00:33 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [15/49] amd64_edac: Fix interleaving check
In-Reply-To: <20110105230438.GA26241@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Borislav Petkov <borislav.petkov@amd.com>

commit e726f3c368e7c1919a7166ec09c5705759f1a69d upstream.

When matching error address to the range contained by one memory node,
we're in valid range when node interleaving

1. is disabled, or
2. enabled and when the address bits we interleave on match the
interleave selector on this node (see the "Node Interleaving" section in
the BKDG for an enlightening example).

Thus, when we early-exit, we need to reverse the compound logic
statement properly.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/edac/amd64_edac.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -1628,7 +1628,7 @@ static int f10_match_to_this_node(struct
 	debugf1("   HoleOffset=0x%x  HoleValid=0x%x IntlvSel=0x%x\n",
 			hole_off, hole_valid, intlv_sel);
 
-	if (intlv_en ||
+	if (intlv_en &&
 	    (intlv_sel != ((sys_addr >> 12) & intlv_en)))
 		return -EINVAL;
 



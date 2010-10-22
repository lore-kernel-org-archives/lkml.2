Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932456Ab0JVSnP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 14:43:15 -0400
Received: from kroah.org ([198.145.64.141]:45992 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758914Ab0JVSlh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:41:37 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Oct 22 11:40:33 2010
Message-Id: <20101022184033.486292826@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 22 Oct 2010 11:39:36 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
        Florian Fainelli <florian@openwrt.org>
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        600155@bugs.debian.org, Jason Heeris <jason.heeris@gmail.com>,
        David Miller <davem@davemloft.net>, spamalot@hispeed.ch,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [11/17] r6040: Fix multicast list iteration when hash filter is used
In-Reply-To: <20101022184048.GA25391@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Ben Hutchings <ben@decadent.org.uk>

This was fixed in mainline by the interface change made in commit
f9dcbcc9e338d08c0f7de7eba4eaafbbb7f81249.

After walking the multicast list to set up the hash filter, this
function will walk off the end of the list when filling the
exact-match entries.  This was fixed in mainline by the interface
change made in commit f9dcbcc9e338d08c0f7de7eba4eaafbbb7f81249.

Reported-by: spamalot@hispeed.ch
Reference: https://bugzilla.kernel.org/show_bug.cgi?id=15355
Reported-by: Jason Heeris <jason.heeris@gmail.com>
Reference: http://bugs.debian.org/600155
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/r6040.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/r6040.c
+++ b/drivers/net/r6040.c
@@ -976,6 +976,7 @@ static void r6040_multicast_list(struct
 		iowrite16(hash_table[3], ioaddr + MAR3);
 	}
 	/* Multicast Address 1~4 case */
+	dmi = dev->mc_list;
 	for (i = 0, dmi; (i < dev->mc_count) && (i < MCAST_MAX); i++) {
 		adrp = (u16 *)dmi->dmi_addr;
 		iowrite16(adrp[0], ioaddr + MID_1L + 8*i);



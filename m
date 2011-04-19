Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753974Ab1DSU0i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 16:26:38 -0400
Received: from kroah.org ([198.145.64.141]:35526 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754663Ab1DSURN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 16:17:13 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Apr 19 13:10:46 2011
Message-Id: <20110419201046.335213242@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Tue, 19 Apr 2011 13:08:39 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ben Hutchings <ben@decadent.org.uk>,
        "David S. Miller" <davem@davemloft.net>
Subject: [30/70] sparc: Fix .size directive for do_int_load
In-Reply-To: <20110419201501.GA8865@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Ben Hutchings <ben@decadent.org.uk>

[ Upstream commit 35043c428f1fcb92feb5792f5878a8852ee00771 ]

gas used to accept (and ignore?) .size directives which referred to
undefined symbols, as this does.  In binutils 2.21 these are treated
as errors.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/sparc/kernel/una_asm_64.S |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/sparc/kernel/una_asm_64.S
+++ b/arch/sparc/kernel/una_asm_64.S
@@ -127,7 +127,7 @@ do_int_load:
 	wr	%o5, 0x0, %asi
 	retl
 	 mov	0, %o0
-	.size	__do_int_load, .-__do_int_load
+	.size	do_int_load, .-do_int_load
 
 	.section	__ex_table,"a"
 	.word		4b, __retl_efault



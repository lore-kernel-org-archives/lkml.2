Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752296Ab0K3Xnf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 18:43:35 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:46767 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751689Ab0K3Xne (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 18:43:34 -0500
Date: Wed, 1 Dec 2010 10:43:29 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paul Mundt <lethal@linux-sh.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Jean-Christop PLAGNIOL-VILLARD" <plagnioj@jcrosoft.com>,
        Russell King <rmk@arm.linux.org.uk>
Subject: linux-next: manual merge of the rmobile tree with the arm tree
Message-Id: <20101201104329.3fdbe25d.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

Today's linux-next merge of the rmobile tree got a conflict in
arch/arm/mach-shmobile/Kconfig between commit
6d803ba736abb5e122dede70a4720e4843dd6df4 ("ARM: 6483/1: arm & sh:
factorised duplicated clkdev.c") from the arm tree and commit
6d72ad35f1bfaf6e52ca7133cb51ce0e36f17528 ("ARM: mach-shmobile: Tidy up
the Kconfig bits") from the rmobile tree.

The latter removed the lines modified by the former, so I used the
latter.  I also applied this merge fixup:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 1 Dec 2010 10:40:34 +1100
Subject: [PATCH] rmobile: merge fixup for clkdev changes

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 arch/arm/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 1b219e4..9d0ba44 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -609,7 +609,7 @@ config ARCH_MSM
 config ARCH_SHMOBILE
 	bool "Renesas SH-Mobile / R-Mobile"
 	select HAVE_CLK
-	select COMMON_CLKDEV
+	select CLKDEV_LOOKUP
 	select GENERIC_CLOCKEVENTS
 	select NO_IOPORT
 	select SPARSE_IRQ
-- 
1.7.2.3


-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

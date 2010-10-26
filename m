Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759635Ab0JZKUt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 06:20:49 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:60762 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759324Ab0JZKST (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 06:18:19 -0400
From: Julia Lawall <julia@diku.dk>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: kernel-janitors@vger.kernel.org, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 6/14] arch/mips/pmc-sierra/yosemite/setup.c: delete double assignment
Date: Tue, 26 Oct 2010 12:25:35 +0200
Message-Id: <1288088743-3725-7-git-send-email-julia@diku.dk>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1288088743-3725-1-git-send-email-julia@diku.dk>
References: <1288088743-3725-1-git-send-email-julia@diku.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Delete successive assignments to the same location.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
expression i;
@@

*i = ...;
 i = ...;
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
This change also makes the variable cpu_clock_freq be not used in the
current file.  If this is the correct change to plat_time_init, then
perhaps the declaration of that variable should be moved elsewhere, or the
variable should be deleted completely.

 arch/mips/pmc-sierra/yosemite/setup.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/mips/pmc-sierra/yosemite/setup.c b/arch/mips/pmc-sierra/yosemite/setup.c
index 3498ac9..b56a924 100644
--- a/arch/mips/pmc-sierra/yosemite/setup.c
+++ b/arch/mips/pmc-sierra/yosemite/setup.c
@@ -140,8 +140,7 @@ int rtc_mips_set_time(unsigned long tim)
 
 void __init plat_time_init(void)
 {
-	mips_hpt_frequency = cpu_clock_freq / 2;
-mips_hpt_frequency = 33000000 * 3 * 5;
+	mips_hpt_frequency = 33000000 * 3 * 5;
 }
 
 unsigned long ocd_base;


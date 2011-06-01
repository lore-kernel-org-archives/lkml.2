Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162498Ab1FAJDW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 05:03:22 -0400
Received: from cantor.suse.de ([195.135.220.2]:44053 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1162048Ab1FAIRS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:17:18 -0400
X-Mailbox-Line: From linux@blue.kroah.org Wed Jun  1 17:04:39 2011
Message-Id: <20110601080437.551923090@blue.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 01 Jun 2011 17:00:58 +0900
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Paul Mundt <lethal@linux-sh.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [122/146] sh: clkfwk: fixup clk_rate_table_build parameter in div6
In-Reply-To: <20110601080606.GA522@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------
 clock

From: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>

commit 52c10ad22b7e317960b4d411c9a9ddeaf3d5ae39 upstream.

div6 clock should not use arch_flags for clk_rate_table_build,
because SH_CLK_DIV6_EXT doesn't care .arch_flags.
clk->freq_table[] will be all CPUFREQ_ENTRY_INVALID without this patch.

Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Signed-off-by: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/sh/clk/cpg.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/sh/clk/cpg.c
+++ b/drivers/sh/clk/cpg.c
@@ -105,7 +105,7 @@ static int sh_clk_div6_set_parent(struct
 
 	/* Rebuild the frequency table */
 	clk_rate_table_build(clk, clk->freq_table, table->nr_divisors,
-			     table, &clk->arch_flags);
+			     table, NULL);
 
 	return 0;
 }



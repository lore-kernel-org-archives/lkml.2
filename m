Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754225Ab1DRKlN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 06:41:13 -0400
Received: from h5.dl5rb.org.uk ([81.2.74.5]:38987 "EHLO duck.linux-mips.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753072Ab1DRKlH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 06:41:07 -0400
X-Greylist: delayed 1515 seconds by postgrey-1.27 at vger.kernel.org; Mon, 18 Apr 2011 06:41:07 EDT
Date: Mon, 18 Apr 2011 11:12:18 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>, Greg KH <gregkh@suse.de>,
        Kay Sievers <kay.sievers@suse.de>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>, linux-omap@vger.kernel.org,
        Kevin Hilman <khilman@ti.com>, linux-arm-kernel@lists.infradead.org,
        Ben Dooks <ben-linux@fluff.org>, Mike Frysinger <vapier@gentoo.org>,
        Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linuxppc-dev@lists.ozlabs.org, Jiri Kosina <jkosina@suse.cz>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 10/14] PM / MIPS: Use struct syscore_ops instead of
 sysdevs for PM
Message-ID: <20110418101218.GA25325@linux-mips.org>
References: <201103280125.11750.rjw@sisk.pl>
 <201104172301.54115.rjw@sisk.pl>
 <201104172312.35060.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201104172312.35060.rjw@sisk.pl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch breaks the Alchemy kernel compile; below patch on top of it fixes
that again.

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>

---
 arch/mips/alchemy/common/irq.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-mips/arch/mips/alchemy/common/irq.c
===================================================================
--- linux-mips.orig/arch/mips/alchemy/common/irq.c
+++ linux-mips/arch/mips/alchemy/common/irq.c
@@ -619,8 +619,8 @@ static struct syscore_ops alchemy_ic_sys
 
 static int __init alchemy_ic_syscore_init(void)
 {
-	alchemy_ic_data[0].base = ioremap(icbase[IC0_PHYS_ADDR], 0x1000);
-	alchemy_ic_data[1].base = ioremap(icbase[IC1_PHYS_ADDR], 0x1000);
+	alchemy_ic_data[0].base = ioremap(IC0_PHYS_ADDR, 0x1000);
+	alchemy_ic_data[1].base = ioremap(IC1_PHYS_ADDR, 0x1000);
 
 	register_syscore_ops(&alchemy_ic_syscore_ops);
 

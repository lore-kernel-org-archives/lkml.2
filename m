Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752215Ab0HCBs6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 21:48:58 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:46507 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750957Ab0HCBs5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 21:48:57 -0400
Date: Tue, 3 Aug 2010 11:48:53 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Kevin Hilman <khilman@deeprootsystems.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sekhar Nori <nsekhar@ti.com>
Subject: linux-next: manual merge of the davinci tree with Linus' tree
Message-Id: <20100803114853.27a29365.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kevin,

Today's linux-next merge of the davinci tree got a conflict in
arch/arm/mach-davinci/board-da850-evm.c between commit
8b24599e72c9aee1ea1187e29cb9c5de9f449cce ("davinci: da850/omap-l138 evm:
account for DEFDCDC{2,3} being tied high") from Linus' tree and commit
ebd1e7808b2fe72d627bdab7bcf61126a831ca5a ("davinci: da850 evm: sparse
cleanup: make file local variables static") from the davinci tree.

Just context changes.  I fixed it up (see below) and can carry the fix
for a while.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-davinci/board-da850-evm.c
index b280efb,f6942dd..0000000
--- a/arch/arm/mach-davinci/board-da850-evm.c
+++ b/arch/arm/mach-davinci/board-da850-evm.c
@@@ -470,12 -469,7 +470,12 @@@ static struct regulator_consumer_suppl
  	},
  };
  
 +/* We take advantage of the fact that both defdcdc{2,3} are tied high */
 +static struct tps6507x_reg_platform_data tps6507x_platform_data = {
 +	.defdcdc_default = true,
 +};
 +
- struct regulator_init_data tps65070_regulator_data[] = {
+ static struct regulator_init_data tps65070_regulator_data[] = {
  	/* dcdc1 */
  	{
  		.constraints = {

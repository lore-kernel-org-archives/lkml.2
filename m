Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751363Ab1IWFDg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 01:03:36 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:34961 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833Ab1IWFDe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 01:03:34 -0400
Date: Fri, 23 Sep 2011 15:03:28 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>, Chris Ball <cjb@laptop.org>
Subject: linux-next: manual merge of the moduleh tree with the mmc tree
Message-Id: <20110923150328.8fdbd13d7386d843ac382e2f@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

Today's linux-next merge of the moduleh tree got a conflict in
drivers/mmc/host/sdhci-pci.c between commit 28f7cbd110e0 ("mmc:
sdhci-pci: add eMMC hardware reset support") from the mmc tree and commit
a93136688a2e ("mmc: Add module.h to drivers/mmc users assuming implicit
presence") from the moduleh tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.

[Chris: Of course, this file should be including module.h anyway ...]
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/mmc/host/sdhci-pci.c
index 3b30c51,2551326..0000000
--- a/drivers/mmc/host/sdhci-pci.c
+++ b/drivers/mmc/host/sdhci-pci.c
@@@ -21,8 -21,7 +21,9 @@@
  #include <linux/mmc/host.h>
  #include <linux/scatterlist.h>
  #include <linux/io.h>
 +#include <linux/gpio.h>
 +#include <linux/sfi.h>
+ #include <linux/module.h>
  
  #include "sdhci.h"
  

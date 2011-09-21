Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752391Ab1IUDfA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 23:35:00 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:41015 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751561Ab1IUDe7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 23:34:59 -0400
Date: Wed, 21 Sep 2011 13:34:56 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Russell King <rmk@arm.linux.org.uk>,
        Viresh Kumar <viresh.kumar@st.com>
Subject: linux-next: manual merge of the spi tree with the arm tree
Message-Id: <20110921133456.3072657340220296eec6d7b6@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant,

Today's linux-next merge of the spi tree got a conflict in
drivers/spi/spi-pl022.c between commit 67fc8b9fe70c ("PM: add runtime PM
support to core Primecell driver") from the arm tree and commit
4eb389a89154 ("spi/spi-pl022: Resolve formatting issues") from the spi
tree.

The former removes the lines modified by the latter, so I just removed
the lines (see below).
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/spi/spi-pl022.c
index 3520cf9,02b2eda..0000000
--- a/drivers/spi/spi-pl022.c
+++ b/drivers/spi/spi-pl022.c
@@@ -2235,8 -2237,11 +2225,10 @@@ pl022_probe(struct amba_device *adev, c
   err_start_queue:
   err_init_queue:
  	destroy_queue(pl022);
- 	pl022_dma_remove(pl022);
+ 	if (platform_info->enable_dma)
+ 		pl022_dma_remove(pl022);
+ 
  	free_irq(adev->irq[0], pl022);
 -	pm_runtime_disable(&adev->dev);
   err_no_irq:
  	clk_put(pl022->clk);
   err_no_clk:
@@@ -2429,9 -2404,10 +2422,8 @@@ static struct amba_driver pl022_driver 
  	.id_table	= pl022_ids,
  	.probe		= pl022_probe,
  	.remove		= __devexit_p(pl022_remove),
 -	.suspend	= pl022_suspend,
 -	.resume		= pl022_resume,
  };
  
- 
  static int __init pl022_init(void)
  {
  	return amba_driver_register(&pl022_driver);

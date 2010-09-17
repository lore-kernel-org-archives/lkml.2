Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754792Ab0IQCF4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 22:05:56 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:57778 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754484Ab0IQCFx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 22:05:53 -0400
Date: Fri, 17 Sep 2010 12:05:48 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Arnd Hannemann <arnd@arndnet.de>, Paul Mundt <lethal@linux-sh.org>
Subject: linux-next: manual merge of the mfd tree with the sh tree
Message-Id: <20100917120548.5dc723ec.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Samuel,

Today's linux-next merge of the mfd tree got a conflict in
drivers/mfd/sh_mobile_sdhi.c between commit
25ab998e2eff46d2e6ede80c9fc02a349fa005a3 ("mfd: Fix up section mismatches
in SH SDHI") from the sh tree and commit
6d1b291f5f2728547a8d681b46657ed9528145bf ("mfd: Allow the platform to
specify the sh_mobile_sdhi get_cd handler") from the mfd tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/mfd/sh_mobile_sdhi.c
index 49b4d06,9d43316..0000000
--- a/drivers/mfd/sh_mobile_sdhi.c
+++ b/drivers/mfd/sh_mobile_sdhi.c
@@@ -65,7 -65,18 +65,18 @@@ static void sh_mobile_sdhi_set_pwr(stru
  		p->set_pwr(pdev, state);
  }
  
+ static int sh_mobile_sdhi_get_cd(struct platform_device *tmio)
+ {
+ 	struct platform_device *pdev = to_platform_device(tmio->dev.parent);
+ 	struct sh_mobile_sdhi_info *p = pdev->dev.platform_data;
+ 
+ 	if (p && p->get_cd)
+ 		return p->get_cd(pdev);
+ 	else
+ 		return -ENOSYS;
+ }
+ 
 -static int __init sh_mobile_sdhi_probe(struct platform_device *pdev)
 +static int __devinit sh_mobile_sdhi_probe(struct platform_device *pdev)
  {
  	struct sh_mobile_sdhi *priv;
  	struct tmio_mmc_data *mmc_data;

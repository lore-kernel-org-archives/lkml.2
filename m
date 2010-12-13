Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756653Ab0LMCpE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 21:45:04 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:58452 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756189Ab0LMCpC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 21:45:02 -0500
Date: Mon, 13 Dec 2010 13:44:57 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Tony Lindgren <tony@atomide.com>, <linux-omap@vger.kernel.org>,
        Lionel Debroux <lionel_debroux@yahoo.fr>
Subject: linux-next: manual merge of the trivial tree with the omap tree
Message-Id: <20101213134457.d0fb1e13.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

Today's linux-next merge of the trivial tree got a conflict in
arch/arm/mach-omap2/pm24xx.c between commit
e83df17f178360a8e7874441bca04a710c869e42 ("OMAP2+: PM/serial: fix console
semaphore acquire during suspend") from the omap tree and commit
2f55ac072f5344519348c0c94b3d2f4cca46847b ("suspend: constify
platform_suspend_ops") from the trivial tree.

I fixed it up (see below) and can carry the fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-omap2/pm24xx.c
index aaeea49,aa9764e..0000000
--- a/arch/arm/mach-omap2/pm24xx.c
+++ b/arch/arm/mach-omap2/pm24xx.c
@@@ -354,13 -326,7 +354,13 @@@ static void omap2_pm_finish(void
  	enable_hlt();
  }
  
 +static void omap2_pm_end(void)
 +{
 +	suspend_state = PM_SUSPEND_ON;
 +}
 +
- static struct platform_suspend_ops omap_pm_ops = {
+ static const struct platform_suspend_ops omap_pm_ops = {
 +	.begin		= omap2_pm_begin,
  	.prepare	= omap2_pm_prepare,
  	.enter		= omap2_pm_enter,
  	.finish		= omap2_pm_finish,

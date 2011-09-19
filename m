Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756851Ab1ISGW5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 02:22:57 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:43341 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152Ab1ISGWz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 02:22:55 -0400
Date: Mon, 19 Sep 2011 16:22:51 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-fbdev@vger.kernel.org
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Manuel Lauss <manuel.lauss@googlemail.com>,
        Ralf Baechle <ralf@linux-mips.org>, Paul Mundt <lethal@linux-sh.org>
Subject: linux-next: manual merge of the fbdev tree with the mips tree
Message-Id: <20110919162251.aa920a691f34b76d36acd61b@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Today's linux-next merge of the fbdev tree got a conflict in
drivers/video/Kconfig between commit 9d7dec27ace1 ("MIPS: Alchemy: remove
all CONFIG_SOC_AU1??? defines") from the mips tree and commit
4ee584615102 ("au1200fb: switch to FB_SYS helpers") from the fbdev tree.

Just context changes. I fixed it up (see below) and can carry the fix as
necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/video/Kconfig
index 55a7df4,8165c55..0000000
--- a/drivers/video/Kconfig
+++ b/drivers/video/Kconfig
@@@ -1755,10 -1764,11 +1764,11 @@@ config FB_AU110
  
  config FB_AU1200
  	bool "Au1200 LCD Driver"
 -	depends on (FB = y) && MIPS && SOC_AU1200
 +	depends on (FB = y) && MIPS_ALCHEMY
- 	select FB_CFB_FILLRECT
- 	select FB_CFB_COPYAREA
- 	select FB_CFB_IMAGEBLIT
+ 	select FB_SYS_FILLRECT
+ 	select FB_SYS_COPYAREA
+ 	select FB_SYS_IMAGEBLIT
+ 	select FB_SYS_FOPS
  	help
  	  This is the framebuffer driver for the AMD Au1200 SOC.  It can drive
  	  various panels and CRTs by passing in kernel cmd line option

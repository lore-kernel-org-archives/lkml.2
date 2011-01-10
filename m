Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753673Ab1AJM1x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 07:27:53 -0500
Received: from mailrelay010.isp.belgacom.be ([195.238.6.177]:8296 "EHLO
	mailrelay010.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753197Ab1AJM1v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 07:27:51 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAC6JKk3CTtAn/2dsb2JhbACkPnO7VoVMBIsK
Date: Mon, 10 Jan 2011 13:27:35 +0100
From: Philippe De Muyter <phdm@macqel.be>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] watchdog,m68knommu: allow M548x watchdog compilation only
	for M548x
Message-ID: <20110110122735.GA23114@frolo.macqel>
References: <20110110141250.78947d61.sfr@canb.auug.org.au> <20110110072750.GL3801@infomag.iguana.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110110072750.GL3801@infomag.iguana.be>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wim and Stephen,

On Mon, Jan 10, 2011 at 08:27:50AM +0100, Wim Van Sebroeck wrote:
> Hi Stephen,
> 
> > After merging the watchdog tree, today's linux-next build (x86_64
> > allmodconfig) failed like this:
> 
> This driver is for the m68K architecture. I apparently missed checking
> the dependancy in Kconfig. I'll fix it today.

Here is my attempt :

allow M548x watchdog compilation only for M548x

Signed-off-by: Philippe De Muyter <phdm@macqel.be>
---
 drivers/watchdog/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index b742f8b..d54bea0 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -831,7 +831,7 @@ config SBC_EPX_C3_WATCHDOG
 
 config M548x_WATCHDOG 
  	tristate "MCF548x watchdog support" 
- 	depends on WATCHDOG 
+ 	depends on M548x
  	help 
  	  To compile this driver as a module, choose M here: the 
  	  module will be called m548x_wdt.
-- 
1.7.1


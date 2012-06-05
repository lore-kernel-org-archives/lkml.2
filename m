Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752912Ab2FEU5Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 16:57:24 -0400
Received: from li158-162.members.linode.com ([173.230.148.162]:52093 "EHLO
	strelka.plastictigers.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751428Ab2FEU5W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 16:57:22 -0400
Date: Tue, 5 Jun 2012 16:57:21 -0400
From: Marc Butler <marc@plastictigers.com>
To: Sagar Dharia <sdharia@codeaurora.org>
Cc: davidb@codeaurora.org, bryanh@codeaurora.org, kheitke@codeaurora.org,
        gclemson@audience.com, broonie@opensource.wolfsonmicro.com,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        rob@landley.net, grant.likely@secretlab.ca, rob.herring@calxeda.com,
        ohad@wizery.com, gregkh@linuxfoundation.org, linus.walleij@linaro.org,
        rusty@rustcorp.com.au, joerg.roedel@amd.com, trenn@suse.de,
        ak@linux.intel.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH] slimbus: Linux driver framework for SLIMbus.
Message-ID: <20120605205721.GA20560@plastictigers.com>
References: <1338340310-4473-1-git-send-email-sdharia@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1338340310-4473-1-git-send-email-sdharia@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below fixes an bug where devices that have not be matched
to a driver will result in a segv when the bus is shutdown.

I am not sure what the policy on patches-on-patches is, it just
doesn't seem workable. So I this will be the first and last. Instead I
am maintaing a git repository that tracks Linus's tree:

git://git.plastictigers.com/slimbus.git

or it can be browsed via the web:

http://git.plastictigers.com/

Currently there are 3 branches:

slimbus-rfc-patch   : the original rfc patch (for reference)
slimbus-patch       : the current patch (as posted by Sagar)
slimbus-patch-fixes : slimbus-patch + fixes (like the one below)

There will likely be a couple of new branches in the future.

If anyone has a suggestion on a better way of doing this I am all
ears.

---
 drivers/slimbus/slimbus.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/slimbus/slimbus.c b/drivers/slimbus/slimbus.c
index 6d20241..673222c 100644
--- a/drivers/slimbus/slimbus.c
+++ b/drivers/slimbus/slimbus.c
@@ -125,6 +125,9 @@ static void slim_device_shutdown(struct device *dev)
 	struct slim_device *slim_dev;
 	struct slim_driver *driver;
 
+	if (!dev->driver)
+		return;
+
 	if (dev->type == &slim_dev_type)
 		slim_dev = to_slim_device(dev);
 	else
-- 
1.7.7


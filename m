Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754081Ab1BFVPq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 16:15:46 -0500
Received: from void.printf.net ([89.145.121.20]:40682 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753775Ab1BFVPp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 16:15:45 -0500
Date: Sun, 6 Feb 2011 21:15:44 +0000
From: Chris Ball <cjb@laptop.org>
To: Pierre Tardy <pierre.tardy@intel.com>
Cc: linux-pm@lists.linux-foundation.org, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yunpeng Gao <yunpeng.gao@intel.com>
Subject: Re: [PATCH v2 2/3] sdhci-pci : Enable runtime PM support
Message-ID: <20110206211544.GA23898@void.printf.net>
References: <cover.1297014479.git.pierre.tardy@intel.com> <6722fa7986194808f4d69a1e5ba6d3f163b77da9.1297014479.git.pierre.tardy@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6722fa7986194808f4d69a1e5ba6d3f163b77da9.1297014479.git.pierre.tardy@intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, Feb 06, 2011 at 07:02:49PM +0100, Pierre Tardy wrote:
> From: Yunpeng Gao <yunpeng.gao@intel.com>
> 
> Follow the kernel runtime PM framework, enable runtime PM support of the
> sdhci host controller with pci interface.
> 
> Note that this patch implements runtime_pm but now actually detects
> activity.
> It relies on higher level (childrens) to do actual waking up
> Activity detection is put in following patch
> 
> Original version from: Yunpeng Gao <yunpeng.gao@intel.com>
> with modifications by: Pierre Tardy <pierre.tardy@intel.com>
> 
> Signed-off-by: Pierre Tardy <pierre.tardy@intel.com>

I had to add a:

diff --git a/drivers/mmc/host/sdhci-pci.c b/drivers/mmc/host/sdhci-pci.c
index 22581a1..48061b3 100644
--- a/drivers/mmc/host/sdhci-pci.c
+++ b/drivers/mmc/host/sdhci-pci.c
@@ -18,6 +18,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/slab.h>
 #include <linux/device.h>
+#include <linux/pm_runtime.h>
 
 #include <linux/mmc/host.h>
 
to prevent a compile error.

-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child

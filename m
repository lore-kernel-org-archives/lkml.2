Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755382Ab1LVRZI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 12:25:08 -0500
Received: from mga02.intel.com ([134.134.136.20]:49133 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753164Ab1LVRZE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 12:25:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="89456459"
Date: Thu, 22 Dec 2011 18:30:20 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Benoit Cousson <b-cousson@ti.com>
Subject: Re: linux-next: build failure after merge of the final tree (mfd
 tree related)
Message-ID: <20111222173020.GI5183@sortiz-mobl>
References: <20111221173301.1111dc371e11d5c7025f03ea@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111221173301.1111dc371e11d5c7025f03ea@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Wed, Dec 21, 2011 at 05:33:01PM +1100, Stephen Rothwell wrote:
> Hi all,
> 
> After merging the final tree, today's linux-next build (powerpc
> allyesconfig) failed like this:
> 
> drivers/mfd/twl-core.c: In function 'twl_probe':
> drivers/mfd/twl-core.c:1212:22: error: 'TWL6030_IRQ_BASE' undeclared (first use in this function)
> drivers/mfd/twl-core.c:1212:22: note: each undeclared identifier is reported only once for each function it appears in
> drivers/mfd/twl-core.c:1213:39: error: 'TWL6030_BASE_NR_IRQS' undeclared (first use in this function)
> drivers/mfd/twl-core.c:1215:22: error: 'TWL4030_IRQ_BASE' undeclared (first use in this function)
> drivers/mfd/twl-core.c:1216:39: error: 'TWL4030_BASE_NR_IRQS' undeclared (first use in this function)
> drivers/mfd/twl-core.c:1218:3: error: implicit declaration of function 'irq_domain_add_simple' [-Werror=implicit-function-declaration]
> 
> Caused by commit 4eea8b1d717d ("mfd: Add initial DT support for
> twl4030/twl6030").  A missing include?  Or a CONFIG problem?
> 
> This build does not have CONFIG_IRQ_DOMAIN set.
> 
> I have reverted that commit for today.
I just pushed Benoit's new patch, this build failure should be fixed now.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/

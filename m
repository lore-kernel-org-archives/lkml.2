Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753275Ab1LUMTP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 07:19:15 -0500
Received: from mga11.intel.com ([192.55.52.93]:9300 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751245Ab1LUMTL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 07:19:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="104616736"
Date: Wed, 21 Dec 2011 13:24:30 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: "Cousson, Benoit" <b-cousson@ti.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the final tree (mfd
 tree related)
Message-ID: <20111221122430.GE5183@sortiz-mobl>
References: <20111221173301.1111dc371e11d5c7025f03ea@canb.auug.org.au>
 <4EF1BA2F.9090304@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EF1BA2F.9090304@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benoit,

On Wed, Dec 21, 2011 at 11:51:27AM +0100, Cousson, Benoit wrote:
> Hi Stephen,
> 
> On 12/21/2011 7:33 AM, Stephen Rothwell wrote:
> >Hi all,
> >
> >After merging the final tree, today's linux-next build (powerpc
> >allyesconfig) failed like this:
> >
> >drivers/mfd/twl-core.c: In function 'twl_probe':
> >drivers/mfd/twl-core.c:1212:22: error: 'TWL6030_IRQ_BASE' undeclared (first use in this function)
> >drivers/mfd/twl-core.c:1212:22: note: each undeclared identifier is reported only once for each function it appears in
> >drivers/mfd/twl-core.c:1213:39: error: 'TWL6030_BASE_NR_IRQS' undeclared (first use in this function)
> >drivers/mfd/twl-core.c:1215:22: error: 'TWL4030_IRQ_BASE' undeclared (first use in this function)
> >drivers/mfd/twl-core.c:1216:39: error: 'TWL4030_BASE_NR_IRQS' undeclared (first use in this function)
> >drivers/mfd/twl-core.c:1218:3: error: implicit declaration of function 'irq_domain_add_simple' [-Werror=implicit-function-declaration]
> >
> >Caused by commit 4eea8b1d717d ("mfd: Add initial DT support for
> >twl4030/twl6030").  A missing include?  Or a CONFIG problem?
> 
> Both in fact...
> 
> There are some nasty dependencies with that TWL driver and the IRQ
> defined in OMAP headers only. I was fooled by the name of these
> macros.
> I naively thought this could be fixed later as written in the
> comment I added. I appears this is not the case :-(.
> 
> >This build does not have CONFIG_IRQ_DOMAIN set.
> 
> Ooops, I was not aware of that domain CONFIG. That one is an easy fix.
> 
> 
> Samuel,
> 
> Just let me know if you will have time for an updated version before Xmas.
I have time to merge an updated version, yes.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/

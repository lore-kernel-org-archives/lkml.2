Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755491Ab1HRKeL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 06:34:11 -0400
Received: from mga14.intel.com ([143.182.124.37]:58468 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755228Ab1HRKeI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 06:34:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,244,1312182000"; 
   d="scan'208";a="8482240"
Date: Thu, 18 Aug 2011 13:34:41 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org, cjb@laptop.org
Subject: Re: [PATCH 1/2] mmc: add functions to enable/disable aggressive
 clock gating
Message-ID: <20110818103441.GX16790@intel.com>
References: <e13e177c732ee8ad2d6fe389c9bac21877f60c59.1313400777.git.mika.westerberg@linux.intel.com>
 <CACRpkdZ5oCmRupNn9HjZj534zXJQWD8OpycpMxG4Jhgsvk=kEQ@mail.gmail.com>
 <20110817121914.GW16790@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110817121914.GW16790@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 17, 2011 at 03:19:14PM +0300, Mika Westerberg wrote:
> On Wed, Aug 17, 2011 at 09:51:31AM +0200, Linus Walleij wrote:
> > 
> > I would suggest that in all patches using these functions, try
> > to replace:
> > 
> > mmc_host_clk_disable() -> mmc_host_clk_ungate()
> > mmc_host_clk_enable() -> mmc_host_clk_gate()
> > 
> 
> Wow, that is indeed *much* cleaner way of doing this!
> 
> One thing is that if I call these from those ios functions,
> mmc_host_clk_ungate() will always try to restore the clock
> even if there is really no need. Do you see this as a problem?
> 
> > Please tell us if this works!
> 
> Certainly. I'll try this overnight and see whether it works.

The device survived overnight reboot loop test, so this scheme seems to
work.

I'll prepare a new series which uses mmc_host_clk_{ungate|gate}().

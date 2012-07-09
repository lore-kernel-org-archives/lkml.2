Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753158Ab2GIKla (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 06:41:30 -0400
Received: from mga09.intel.com ([134.134.136.24]:54116 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752721Ab2GIKl3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 06:41:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="163203162"
Date: Mon, 9 Jul 2012 12:52:58 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the mfd tree
Message-ID: <20120709105258.GJ15345@sortiz-mobl>
References: <20120709135719.5c8b0f033520f5981efb2c93@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120709135719.5c8b0f033520f5981efb2c93@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen, Mark,

On Mon, Jul 09, 2012 at 01:57:19PM +1000, Stephen Rothwell wrote:
> Hi Samuel,
> 
> After merging the mfd tree, today's linux-next build (x86_64 allmodconfig)
> failed like this:
> 
> ERROR: "arizona_dai_ops" [sound/soc/codecs/snd-soc-wm5102.ko] undefined!
> ERROR: "wm5102_aod" [drivers/mfd/arizona-irq.ko] undefined!
> ERROR: "wm5102_irq" [drivers/mfd/arizona-irq.ko] undefined!
> ERROR: "irq_set_chip_and_handler_name" [drivers/mfd/arizona-irq.ko] undefined!
> ERROR: "wm5102_patch" [drivers/mfd/arizona-core.ko] undefined!
> ERROR: "arizona_irq_init" [drivers/mfd/arizona-core.ko] undefined!
> ERROR: "arizona_irq_exit" [drivers/mfd/arizona-core.ko] undefined!
>
I pushed a patch that fixes the following build failures:

ERROR: "wm5102_aod" [drivers/mfd/arizona-irq.ko] undefined!
ERROR: "wm5102_irq" [drivers/mfd/arizona-irq.ko] undefined!
ERROR: "irq_set_chip_and_handler_name" [drivers/mfd/arizona-irq.ko] undefined!
ERROR: "wm5102_patch" [drivers/mfd/arizona-core.ko] undefined!
ERROR: "arizona_irq_init" [drivers/mfd/arizona-core.ko] undefined!
ERROR: "arizona_irq_exit" [drivers/mfd/arizona-core.ko] undefined!

This one:

ERROR: "arizona_dai_ops" [sound/soc/codecs/snd-soc-wm5102.ko] undefined!

comes from the fact that arizon_dai_ops is not an exported symbol while
snd-soc-wm5102 is built as a module. This is coming from Mark's sound tree.

Cheers,
Samuel.


-- 
Intel Open Source Technology Centre
http://oss.intel.com/

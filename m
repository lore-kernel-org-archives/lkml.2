Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754837Ab0IMOJT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 10:09:19 -0400
Received: from mga09.intel.com ([134.134.136.24]:9399 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754544Ab0IMOJS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 10:09:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,359,1280732400"; 
   d="scan'208";a="554001042"
Date: Mon, 13 Sep 2010 16:09:41 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mattias Wallin <mattias.wallin@stericsson.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        Linus WALLEIJ <linus.walleij@stericsson.com>
Subject: Re: [PATCH 2/3] MFD: AB8500 debugfs
Message-ID: <20100913140940.GJ2555@sortiz-mobl>
References: <4C8DE1BE.30304@stericsson.com>
 <20100913132618.GB2555@sortiz-mobl>
 <4C8E2CA2.9020703@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C8E2CA2.9020703@stericsson.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 13, 2010 at 03:52:34PM +0200, Mattias Wallin wrote:
> 
> 
> On 09/13/2010 03:26 PM, Samuel Ortiz wrote:
> > Hi Mattias,
> > 
> > I have some addtional comments:
> > 
> > On Mon, Sep 13, 2010 at 10:33:02AM +0200, Mattias Wallin wrote:
> >> +static struct platform_driver ab8500_debug_driver = {
> >> +       .driver = {
> >> +               .name = "ab8500-debug",
> >> +               .owner = THIS_MODULE,
> >> +       },
> >> +       .probe  = ab8500_debug_probe,
> >> +       .remove = __devexit_p(ab8500_debug_remove)
> >> +};
> >> +
> >> +static int __init ab8500_debug_init(void)
> >> +{
> >> +       return platform_driver_register(&ab8500_debug_driver);
> >> +}
> >> +
> >> +static void __exit ab8500_debug_exit(void)
> >> +{
> >> +       platform_driver_unregister(&ab8500_debug_driver);
> >> +}
> > It seems a bit awkward to me to have this code as an actual platform driver.
> > Why not defining ab8500_debug_[probe|remove] in ab8500.h as no-op when
> > CONFIG_AB8500_DEBUG is not defined and as extern otherwise ?
> In the register access interface abx500_get_register_interruptible() the first
> argument is a struct *device. This struct *device needs to be a (platform) device "child" to
> the ab8500-core (dev->parent is used).
Obviously. All 3 patches applied, many thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/

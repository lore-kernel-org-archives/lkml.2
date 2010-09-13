Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754440Ab0IMNZ4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 09:25:56 -0400
Received: from mga03.intel.com ([143.182.124.21]:54850 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751708Ab0IMNZz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 09:25:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,359,1280732400"; 
   d="scan'208";a="323932557"
Date: Mon, 13 Sep 2010 15:26:19 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mattias Wallin <mattias.wallin@stericsson.com>
Cc: linux-kernel@vger.kernel.org, broonie@opensource.wolfsonmicro.com,
        elinwal <linus.walleij@stericsson.com>
Subject: Re: [PATCH 2/3] MFD: AB8500 debugfs
Message-ID: <20100913132618.GB2555@sortiz-mobl>
References: <4C8DE1BE.30304@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C8DE1BE.30304@stericsson.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mattias,

I have some addtional comments:

On Mon, Sep 13, 2010 at 10:33:02AM +0200, Mattias Wallin wrote:
> +static struct platform_driver ab8500_debug_driver = {
> +       .driver = {
> +               .name = "ab8500-debug",
> +               .owner = THIS_MODULE,
> +       },
> +       .probe  = ab8500_debug_probe,
> +       .remove = __devexit_p(ab8500_debug_remove)
> +};
> +
> +static int __init ab8500_debug_init(void)
> +{
> +       return platform_driver_register(&ab8500_debug_driver);
> +}
> +
> +static void __exit ab8500_debug_exit(void)
> +{
> +       platform_driver_unregister(&ab8500_debug_driver);
> +}
It seems a bit awkward to me to have this code as an actual platform driver.
Why not defining ab8500_debug_[probe|remove] in ab8500.h as no-op when
CONFIG_AB8500_DEBUG is not defined and as extern otherwise ?

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/

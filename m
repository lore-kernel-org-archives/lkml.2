Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754931Ab0I1OXI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 10:23:08 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:26211 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753534Ab0I1OXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 10:23:06 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Thomas Renninger <trenn@suse.de>
Subject: Re: Dynamic Debug module.ddebug fake param enhancements V4
Date: Tue, 28 Sep 2010 08:22:11 -0600
User-Agent: KMail/1.13.2 (Linux/2.6.32-24-generic; KDE/4.4.2; x86_64; ; )
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, jbaron@redhat.com
References: <20100920184441.GA2915@redhat.com> <201009270909.18490.bjorn.helgaas@hp.com> <201009281425.19070.trenn@suse.de>
In-Reply-To: <201009281425.19070.trenn@suse.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201009280822.11675.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, September 28, 2010 06:25:18 am Thomas Renninger wrote:
> Greg: Do you mind pushing the first (1/4, V4) and the last (4/4)
> patch into your tree for linux-next and leave the two PNP patches
> out, please.
> 
> More PNP related discussion, below.
> 
> On Monday 27 September 2010 17:09:18 Bjorn Helgaas wrote:
> > On Monday, September 27, 2010 02:25:46 am Thomas Renninger wrote:
> > 
> > > What do you think (dev_dbg vs printk(KERN_DEBUG...)?
> ...
> > With the exception of the ones in pnp/resource.c that I want to convert
> > to dev_printk(KERN_DEBUG), I think all the pnp_dbg() uses are things
> > I used during PNP development and haven't ever needed since.
> 
> Ok. Sounds sane.
> I used the PNP parts as it nicely showed what the
> module.ddebug boot param is doing, but I agree it hasn't much
> advantage for PNP.
> 
> Whatabout compiling pnp in one module namespace, the first
> of the two PNP patches?

[2/4] looks reasonable to me.

> E.g. attached patch would be an on top patch which provides no
> functional change, just that a pnp.debug would be a module param:
> cat /sys/module/pnp/parameters/debug

As does the one below.

> ---------
> PNP: Set up pnp_debug via module and not via boot param.
> 
> Cleanup only, no functional change (pnp.debug can be enabled
> and disabled at runtime, but that's not a real enhancement).
> 
> This one depends on another PNP cleanup patch:
> PNP: Compile all pnp built-in stuff in one module namespace
> 
> Signed-off-by: Thomas Renninger <trenn@suse.de>
> 
> diff --git a/drivers/pnp/core.c b/drivers/pnp/core.c
> index 88b3cde..9801918 100644
> --- a/drivers/pnp/core.c
> +++ b/drivers/pnp/core.c
> @@ -218,10 +218,5 @@ subsys_initcall(pnp_init);
>  int pnp_debug;
>  
>  #if defined(CONFIG_PNP_DEBUG_MESSAGES)
> -static int __init pnp_debug_setup(char *__unused)
> -{
> -	pnp_debug = 1;
> -	return 1;
> -}
> -__setup("pnp.debug", pnp_debug_setup);
> +module_param_named(debug, pnp_debug, int, 0644);
>  #endif
> 

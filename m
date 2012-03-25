Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753653Ab2CYBFa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2012 21:05:30 -0400
Received: from mail1.windriver.com ([147.11.146.13]:45606 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752667Ab2CYBF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2012 21:05:29 -0400
Date: Sat, 24 Mar 2012 21:05:13 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: <linux-kernel@vger.kernel.org>
Subject: Re: On patch "device.h: audit and cleanup users in main include dir"
Message-ID: <20120325010513.GC12203@windriver.com>
References: <20120324212125.460c89d3@stein>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20120324212125.460c89d3@stein>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[On patch "device.h: audit and cleanup users in main include dir"] On 24/03/2012 (Sat 21:21) Stefan Richter wrote:

> Hi Paul,
> 
> commit 313162d0b83836e2f57e51b9b8650fb4b9c396ea is not 100.00% correct.
> 
> --- a/include/linux/firewire.h
> +++ b/include/linux/firewire.h
> @@ -2,7 +2,6 @@
>  #define _LINUX_FIREWIRE_H
>  
>  #include <linux/completion.h>
> -#include <linux/device.h>
>  #include <linux/dma-mapping.h>
>  #include <linux/kernel.h>
>  #include <linux/kref.h>
> @@ -68,6 +67,8 @@
>  #define CSR_MODEL              0x17
>  #define CSR_DIRECTORY_ID       0x20
>  
> +struct device;
> +
>  struct fw_csr_iterator {
>         const u32 *p;
>         const u32 *end;
> 
> But struct fw_device and struct fw_unit, defined in include/firewire.h,
> incorporate struct device.

Hi Stefan,

You are correct.  I did read them all and check instances of device, so
I'm not sure how I misread this file.  Did you have a specific build
that triggered a failure, or you just happened to spot it?  I'm guessing
that it gets device.h by another path and hence won't show up in build
coverage.

If so I'll definitely get it fixed, but I might wait a day or two to see
if anything else pops up, if it isn't explicitly causing any breakage.

Thanks for the report,
Paul.
--

> 
> Furthermore, the inline function definitions
>     fw_device,
>     fw_unit,
>     fw_unit_get,
>     fw_unit_put,
>     fw_parent_device
> all require definitions from linux/device.h.
> -- 
> Stefan Richter
> -=====-===-- --== ==---
> http://arcgraph.de/sr/

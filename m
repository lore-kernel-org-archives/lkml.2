Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758055Ab2EANpz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 09:45:55 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:36181 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756657Ab2EANpx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 09:45:53 -0400
X-Sasl-enc: jyzZ1omCCzwxPnnTjoAySbu9DLZzL8dTYoSKrnFXu0KJ 1335879952
Date: Tue, 1 May 2012 09:45:52 -0400
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Jim Cromie <jim.cromie@gmail.com>,
        Roland Dreier <roland@purestorage.com>
Subject: Re: linux-next: build failure after merge of the driver-core tree
Message-ID: <20120501134552.GB31954@kroah.com>
References: <20120501145922.14f2235dff099d20acf3b54a@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120501145922.14f2235dff099d20acf3b54a@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 01, 2012 at 02:59:22PM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> After merging the driver-core tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
> 
> In file included from include/linux/kernel.h:23:0,
>                  from include/linux/cache.h:4,
>                  from include/linux/time.h:7,
>                  from include/linux/stat.h:60,
>                  from include/linux/module.h:10,
>                  from drivers/infiniband/ulp/srp/ib_srp.c:35:
> include/linux/dynamic_debug.h: In function 'ddebug_dyndbg_module_param_cb':
> include/linux/dynamic_debug.h:112:3: error: expected ')' before 'PFX'
> 
> Caused by commit b48420c1d301 ("dynamic_debug: make dynamic-debug work
> for module initialization") interacting with commit e0bda7d8c33e
> ("IB/srp: Use pr_fmt() and pr_err()/pr_warn()") from Linus' tree (added
> before v3.4-rc1).
> 
> I have used the driver-core tree from next-20120430 for today.

Thanks, but this is a driver-core tree problem, not an IB tree problem,
so should you should have dropped my tree :)

I've applied a patch to the driver-core tree that should solve this
issue now, thanks for letting us know.

greg k-h

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752202Ab2EAHPG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 03:15:06 -0400
Received: from relay01ant.iops.be ([212.53.4.34]:43866 "EHLO
	relay01ant.iops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061Ab2EAHPE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 03:15:04 -0400
X-Greylist: delayed 577 seconds by postgrey-1.27 at vger.kernel.org; Tue, 01 May 2012 03:15:03 EDT
Message-ID: <4F9F8B30.6070603@acm.org>
Date: Tue, 01 May 2012 07:05:20 +0000
From: Bart Van Assche <bvanassche@acm.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120328 Thunderbird/11.0.1
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Greg KH <greg@kroah.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jim Cromie <jim.cromie@gmail.com>,
        Roland Dreier <roland@purestorage.com>
Subject: Re: linux-next: build failure after merge of the driver-core tree
References: <20120501145922.14f2235dff099d20acf3b54a@canb.auug.org.au>
In-Reply-To: <20120501145922.14f2235dff099d20acf3b54a@canb.auug.org.au>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/01/12 04:59, Stephen Rothwell wrote:

> After merging the driver-core tree, today's linux-next build
> (powerpc ppc64_defconfig) failed like this:
> 
> In file included from include/linux/kernel.h:23:0, from
> include/linux/cache.h:4, from include/linux/time.h:7, from
> include/linux/stat.h:60, from include/linux/module.h:10, from
> drivers/infiniband/ulp/srp/ib_srp.c:35: 
> include/linux/dynamic_debug.h: In function
> 'ddebug_dyndbg_module_param_cb': 
> include/linux/dynamic_debug.h:112:3: error: expected ')' before
> 'PFX'
> 
> Caused by commit b48420c1d301 ("dynamic_debug: make dynamic-debug
> work for module initialization") interacting with commit
> e0bda7d8c33e ("IB/srp: Use pr_fmt() and pr_err()/pr_warn()") from
> Linus' tree (added before v3.4-rc1).
> 
> I have used the driver-core tree from next-20120430 for today.


This reveals that the pr_warn() statement in that dynamic_debug patch
uses the pr_fmt() macro of the module from which it has been included
(e.g. ib_srp) instead that of the dynamic debug module itself. That
looks incorrect to me. How about moving the definition of
ddebug_dyndbg_module_param_cb() from include/linux/dynamic_debug.h
into lib/dynamic_debug.c ?

Bart.

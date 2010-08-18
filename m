Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751708Ab0HRH3o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 03:29:44 -0400
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:3041 "EHLO
	mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750828Ab0HRH3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 03:29:39 -0400
X-Greylist: delayed 581 seconds by postgrey-1.27 at vger.kernel.org; Wed, 18 Aug 2010 03:29:38 EDT
X-IronPort-AV: E=Sophos;i="4.56,226,1280700000"; 
   d="scan'208";a="67924312"
Message-ID: <4C6B88A5.4050305@inria.fr>
Date: Wed, 18 Aug 2010 09:15:49 +0200
From: Brice Goglin <Brice.Goglin@inria.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100805 Icedove/3.0.6
MIME-Version: 1.0
To: Amerigo Wang <amwang@redhat.com>
CC: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        David Rientjes <rientjes@google.com>, Michal Marek <mmarek@suse.cz>
Subject: Re: [PATCH 2/2] Makefile: "make kernelrelease" should show the correct
 full kernel version
References: <20100628030507.5187.95903.sendpatchset@localhost.localdomain> <20100628030516.5187.49089.sendpatchset@localhost.localdomain>
In-Reply-To: <20100628030516.5187.49089.sendpatchset@localhost.localdomain>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch (actually 01ab17887 in 2.6.36-rc1) reveals what looks like a
problem to me: make kernelrelease always regenerates
include/config/kernel.release even if it's already more recent than
include/config/auto.conf. Is this the expected behavior? Do we really
need include/config/kernel.release to depend on FORCE?

$ make kernelrelease -d
[...]
Considering target file `kernelrelease'.
 File `kernelrelease' does not exist.
  Considering target file `include/config/kernel.release'.
    Pruning file `include/config/auto.conf'.
    Considering target file `FORCE'.
     File `FORCE' does not exist.
     Finished prerequisites of target file `FORCE'.
    Must remake target `FORCE'.
    Successfully remade target file `FORCE'.
   Finished prerequisites of target file `include/config/kernel.release'.
   Prerequisite `include/config/auto.conf' is older than target `include/config/kernel.release'.
   Prerequisite `FORCE' of target `include/config/kernel.release' does not exist.
  Must remake target `include/config/kernel.release'.


Thanks,
Brice




Le 28/06/2010 05:01, Amerigo Wang a écrit :
> From: Amerigo Wang <amwang@redhat.com>
> Date: Mon, 28 Jun 2010 10:45:21 +0800
>
> After commit 85a256d8e0116c8f5ad276730830f5d4d473344d, 'make kernelrelease' doesn't
> show the correct full kernel version. This patch fixes it, 'make kernelrelease' will
> show the same version name with the one you finally get.
>
> Cc: David Rientjes <rientjes@google.com>
> Cc: Michal Marek <mmarek@suse.cz>
> Signed-off-by: Amerigo Wang <amwang@redhat.com>
> ---
>  Makefile |    5 ++---
>  1 files changed, 2 insertions(+), 3 deletions(-)
>
> diff --git a/Makefile b/Makefile
> index 710f91c..2b517a1 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -414,7 +414,7 @@ endif
>  no-dot-config-targets := clean mrproper distclean \
>  			 cscope TAGS tags help %docs check% \
>  			 include/linux/version.h headers_% \
> -			 kernelrelease kernelversion
> +			 kernelversion
>  
>  config-targets := 0
>  mixed-targets  := 0
> @@ -1468,8 +1468,7 @@ checkstack:
>  	$(PERL) $(src)/scripts/checkstack.pl $(CHECKSTACK_ARCH)
>  
>  kernelrelease:
> -	$(if $(wildcard include/config/kernel.release), $(Q)echo $(KERNELRELEASE), \
> -	$(error kernelrelease not valid - run 'make prepare' to update it))
> +	@echo $(kernelrelease)
>  kernelversion:
>  	@echo $(KERNELVERSION)
>  
>   


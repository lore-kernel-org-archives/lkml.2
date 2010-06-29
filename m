Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751733Ab0F2MNT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 08:13:19 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57057 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750869Ab0F2MNS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 08:13:18 -0400
Date: Tue, 29 Jun 2010 14:13:15 +0200
From: Michal Marek <mmarek@suse.cz>
To: Amerigo Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
       David Rientjes <rientjes@google.com>
Subject: Re: [PATCH 2/2] Makefile: "make kernelrelease" should show the
 correct full kernel version
Message-ID: <20100629121315.GA13335@sepie.suse.cz>
References: <20100628030507.5187.95903.sendpatchset@localhost.localdomain>
 <20100628030516.5187.49089.sendpatchset@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100628030516.5187.49089.sendpatchset@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 27, 2010 at 11:01:06PM -0400, Amerigo Wang wrote:
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

AFAICS it was broken even before 85a256d. Nevertheless, the patch is
correct, but conflicts with 0915512 in the kbuild tree. What about this
one?

>From 01ab17887f4cdcb8bb5a5d1bc3b160d186e6e99b Mon Sep 17 00:00:00 2001
From: Amerigo Wang <amwang@redhat.com>
Date: Mon, 28 Jun 2010 10:45:21 +0800
Subject: [PATCH] Makefile: "make kernelrelease" should show the correct full kernel version

After commit 85a256d8e0116c8f5ad276730830f5d4d473344d, 'make kernelrelease'
doesn't show the correct full kernel version. This patch fixes it,
'make kernelrelease' will show the same version name with the one
you finally get.

Cc: David Rientjes <rientjes@google.com>
Cc: Michal Marek <mmarek@suse.cz>
Signed-off-by: Amerigo Wang <amwang@redhat.com>
[mmarek: merged with 0915512 and added dependency on
include/config/kernel.release]
Signed-off-by: Michal Marek <mmarek@suse.cz>

diff --git a/Makefile b/Makefile
index a86ac8c..dceb4f1 100644
--- a/Makefile
+++ b/Makefile
@@ -414,7 +414,7 @@ endif
 no-dot-config-targets := clean mrproper distclean \
 			 cscope TAGS tags help %docs check% \
 			 include/linux/version.h headers_% \
-			 kernelrelease kernelversion
+			 kernelversion
 
 config-targets := 0
 mixed-targets  := 0
@@ -1395,9 +1395,9 @@ checkstack:
 	$(OBJDUMP) -d vmlinux $$(find . -name '*.ko') | \
 	$(PERL) $(src)/scripts/checkstack.pl $(CHECKSTACK_ARCH)
 
-kernelrelease:
-	$(if $(wildcard include/config/kernel.release), $(Q)echo $(KERNELRELEASE), \
-	$(error kernelrelease not valid - run 'make prepare' to update it))
+kernelrelease: include/config/kernel.release
+	@echo $(KERNELRELEASE)
+
 kernelversion:
 	@echo $(KERNELVERSION)
 

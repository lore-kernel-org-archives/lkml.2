Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932879Ab2DKSEk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 14:04:40 -0400
Received: from merlin.infradead.org ([205.233.59.134]:58430 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932777Ab2DKSEi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 14:04:38 -0400
Date: Wed, 11 Apr 2012 15:04:34 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Borislav Petkov <bp@amd64.org>
Cc: Ingo Molnar <mingo@kernel.org>, Michal Marek <mmarek@suse.cz>,
        Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [PATCH v5 5/5] tools: Connect to the kernel build system
Message-ID: <20120411180434.GH16257@infradead.org>
References: <1334162178-17152-1-git-send-email-bp@amd64.org>
 <1334162178-17152-6-git-send-email-bp@amd64.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334162178-17152-6-git-send-email-bp@amd64.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Apr 11, 2012 at 06:36:18PM +0200, Borislav Petkov escreveu:
> From: Borislav Petkov <borislav.petkov@amd.com>
> 
> Now you can do
> 
> $ make tools/<toolname>
> 
> from the toplevel kernel directory and have the respective tool built.
> 
> If you want to build and install it, do
> 
> $ make tools/<toolname>_install

[acme@sandy linux]$ make -j8 O=/home/git/build/perf tools/perf_install
[acme@sandy linux]$ ls -la tools/perf/*.o | wc -l
22

It should have honoured O=

Can you fix this one please? :)

- Arnaldo
 
> $ make tools/<toolname>_clean
> 
> should clean the respective tool directories.
> 
> If you want to clean all in tools, simply do
> 
> $ make tools/clean
> 
> Also, if you want to get what the possible targets are, simply calling
> 
> $ make tools/
> 
> should give you the short help.
> 
> $ make tools/install
> 
> installs all tools, of course. Doh.
> 
> Cc: Sam Ravnborg <sam@ravnborg.org>
> Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
> ---
>  Makefile       |    7 +++++++
>  tools/Makefile |   10 ++++++++++
>  2 files changed, 17 insertions(+)
> 
> diff --git a/Makefile b/Makefile
> index 0df3d003a079..f7f738117128 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -1468,6 +1468,13 @@ kernelrelease:
>  kernelversion:
>  	@echo $(KERNELVERSION)
>  
> +# Clear a bunch of variables before executing the submake
> +tools/: FORCE
> +	$(Q)$(MAKE) LDFLAGS= MAKEFLAGS= -C $(src)/tools/
> +
> +tools/%: FORCE
> +	$(Q)$(MAKE) LDFLAGS= MAKEFLAGS= -C $(src)/tools/ $*
> +
>  # Single targets
>  # ---------------------------------------------------------------------------
>  # Single targets are compatible with:
> diff --git a/tools/Makefile b/tools/Makefile
> index f87c0ec63e6c..3ae43947a171 100644
> --- a/tools/Makefile
> +++ b/tools/Makefile
> @@ -14,6 +14,16 @@ help:
>  	@echo '  vm         - misc vm tools'
>  	@echo '  x86_energy_perf_policy - Intel energy policy tool'
>  	@echo ''
> +	@echo 'You can do:'
> +	@echo ' $$ make -C tools/<tool>_install'
> +	@echo ''
> +	@echo '  from the kernel command line to build and install one of'
> +	@echo '  the tools above'
> +	@echo ''
> +	@echo '  $$ make tools/install'
> +	@echo ''
> +	@echo '  installs all tools.'
> +	@echo ''
>  	@echo 'Cleaning targets:'
>  	@echo ''
>  	@echo '  all of the above with the "_clean" string appended cleans'
> -- 
> 1.7.9.3.362.g71319

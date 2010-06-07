Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751954Ab0FGRS1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 13:18:27 -0400
Received: from daytona.panasas.com ([67.152.220.89]:51660 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750955Ab0FGRS0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 13:18:26 -0400
Message-ID: <4C0D29DE.6050602@panasas.com>
Date: Mon, 07 Jun 2010 20:18:22 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Frans Pop <elendil@planet.nl>, Dirk Hohndel <hohndel@infradead.org>,
       Len Brown <lenb@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH, v2] kbuild: Improve version string logic - two for the
 price of one - No thanks
References: <alpine.LFD.2.01.0910041727310.3432@localhost.localdomain> <alpine.LFD.2.00.0910052140100.309@localhost.localdomain> <1254797502.14122.146.camel@dhohndel-mobl.amr.corp.intel.com> <alpine.LFD.2.01.0910060705240.3432@localhost.localdomain> <20091006144449.GA23078@elte.hu> <alpine.LFD.2.01.0910060815320.3432@localhost.localdomain> <20091006153632.GA29795@elte.hu> <alpine.LFD.2.01.0910060843560.3432@localhost.localdomain> <alpine.LFD.2.01.0910060925490.3432@localhost.localdomain> <20091006173508.GA4786@elte.hu> <20091012195733.GA7351@elte.hu>
In-Reply-To: <20091012195733.GA7351@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 07 Jun 2010 17:18:24.0872 (UTC) FILETIME=[6FE1BE80:01CB0665]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/12/2009 09:57 PM, Ingo Molnar wrote:
> 
> This is basically your original patch that adds '+' to the short version 
> string of kernels that are 'between' -rc tags. (i dropped the '+' within 
> the long version i did in v1 - there were objections against that)
> 
> Would this be ok?
> 

Rrrr. If I wanted CONFIG_LOCALVERSION_AUTO, I would use that one. At least
it is actually useful and informative.

I already have my:
 VERSION = 2
 PATCHLEVEL = 6
 SUBLEVEL = 35
-EXTRAVERSION = -rc2
+EXTRAVERSION = -rc2-my_tree

Which is managed by a git tree (for everybody based on my tree)

At least give us a way out with:
CONFIG_LOCALVERSION_NO_AUTO_IM_REALLY_STUPID=y way out.

or EXTRAVERSION != $(git version)

But don't leave us cold in the woods like that. (What if I remove the git tree altogether, move to svn)

If I can shoot my self in the foot, it does not mean Government should not issue any more
gun licenses.

I already have my outer Makefile system that makes sure I don't forget to compile, or
"did I install this Kernel or not". Please let us have a way out?

Boaz
> 	Ingo
> 
> -------------->
>>From 597e5b15dd0cbb3158afc438e5edae9986e6b76a Mon Sep 17 00:00:00 2001
> From: Linus Torvalds <torvalds@linux-foundation.org>
> Date: Tue, 6 Oct 2009 09:31:03 -0700
> Subject: [PATCH] kbuild: Improve version string logic
> 
> It changes how CONFIG_LOCALVERSION_AUTO works, in the following trivial
> way:
> 
>  - if it is set, things work the way they always have, and you get a
>    extended kernel release like:
> 
> 	2.6.32-rc3-00052-g0eca52a
> 
>  - but if it is _not_ set, we'll still try to get a version from the
>    underlying SCM (we actually support git, hg and SVN right now, even if
>    some comments may say "git only"), and if the underlying SCM says it
>    has a local version, we append just "+", so you get a version number
>    like:
> 
> 	2.6.32-rc3+
> 
> IOW, you'd never get 2.6.32-rc0, but you'd get either the complex git
> version number (or SVN/hg/whatever), or at least "2.6.31+" with the "+"
> showing that it is more than plain 2.6.31.
> 
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> Cc: Frans Pop <elendil@planet.nl>
> Cc: Dirk Hohndel <hohndel@infradead.org>
> Cc: Len Brown <lenb@kernel.org>
> LKML-Reference: <20091006173508.GA4786@elte.hu>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  Makefile |    9 +++++++--
>  1 files changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/Makefile b/Makefile
> index 927d7a3..5dab509 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -963,8 +963,6 @@ localver = $(subst $(space),, $(string) \
>  # .scmversion is used when generating rpm packages so we do not loose
>  # the version information from the SCM when we do the build of the kernel
>  # from the copied source
> -ifdef CONFIG_LOCALVERSION_AUTO
> -
>  ifeq ($(wildcard .scmversion),)
>          _localver-auto = $(shell $(CONFIG_SHELL) \
>                           $(srctree)/scripts/setlocalversion $(srctree))
> @@ -972,7 +970,14 @@ else
>          _localver-auto = $(shell cat .scmversion 2> /dev/null)
>  endif
>  
> +ifdef CONFIG_LOCALVERSION_AUTO
>  	localver-auto  = $(LOCALVERSION)$(_localver-auto)
> +else
> +	ifeq ($_localver-auto,)
> +		localver-auto = $(LOCALVERSION)
> +	else
> +		localver-auto = $(LOCALVERSION)+
> +	endif
>  endif
>  
>  localver-full = $(localver)$(localver-auto)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


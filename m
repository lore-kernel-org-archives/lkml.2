Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754095Ab1JaGna (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 02:43:30 -0400
Received: from ozlabs.org ([203.10.76.45]:56106 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751088Ab1JaGnZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 02:43:25 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Nick Bowler <nbowler@elliptictech.com>, Greg KH <greg@kroah.com>,
        Dave Jones <davej@redhat.com>, Randy Dunlap <rdunlap@xenotime.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Debian kernel maintainers <debian-kernel@lists.debian.org>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [PATCH 2/2] module: Re-enable dynamic debugging for GPL-compatible OOT modules
In-Reply-To: <1319773094.6759.32.camel@deadeye>
References: <1319773094.6759.32.camel@deadeye>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Mon, 31 Oct 2011 12:29:20 +1030
Message-ID: <87obwxq5tz.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Oct 2011 04:38:14 +0100, Ben Hutchings <ben@decadent.org.uk> wrote:
> Dynamic debugging was enabled for GPL-compatible out-of-tree modules
> until my addition of TAINT_OOT_MODULE.  It should continue to be
> enabled now.

Please just remove the test entirely.

AFAICT there's nothing unique to dynamic debug which means it should
avoid taint.  If it oopses, we'll learn all about tainting in the oops
message.

> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> ---
>  kernel/module.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/module.c b/kernel/module.c
> index dab585e..448fd77 100644
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -2881,7 +2881,7 @@ static struct module *load_module(void __user *umod,
>  	}
>  
>  	/* This has to be done once we're sure module name is unique. */
> -	if (!mod->taints || mod->taints == (1U<<TAINT_CRAP))
> +	if (!(mod->taints & ~(1U << TAINT_CRAP | 1U << TAINT_OOT_MODULE)))
>  		dynamic_debug_setup(info.debug, info.num_debug);
>  
>  	/* Find duplicate symbols */
> @@ -2918,7 +2918,7 @@ static struct module *load_module(void __user *umod,
>  	module_bug_cleanup(mod);
>  
>   ddebug:
> -	if (!mod->taints || mod->taints == (1U<<TAINT_CRAP))
> +	if (!(mod->taints & ~(1U << TAINT_CRAP | 1U << TAINT_OOT_MODULE)))
>  		dynamic_debug_remove(info.debug);
>   unlock:
>  	mutex_unlock(&module_mutex);
> -- 
> 1.7.7
> 
> 

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964952Ab2JCPz7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 11:55:59 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:58141 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932516Ab2JCPz5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 11:55:57 -0400
Date: Wed, 3 Oct 2012 06:25:38 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] make CONFIG_EXPERIMENTAL invisible and default
Message-ID: <20121003132538.GE13192@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20121002195042.GA16087@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121002195042.GA16087@www.outflux.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12100315-5112-0000-0000-00000D0A31E3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 02, 2012 at 12:50:42PM -0700, Kees Cook wrote:
> This config item has not carried much meaning for a while now and is
> almost always enabled by default. As agreed during the Linux kernel
> summit, it should be removed. As a first step, remove it from being
> listed, and default it to on. Once it has been removed from all
> subsystem Kconfigs, it will be dropped entirely.
> 
> CC: Greg KH <gregkh@linuxfoundation.org>
> CC: "Eric W. Biederman" <ebiederm@xmission.com>
> CC: Serge Hallyn <serge.hallyn@canonical.com>
> CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> CC: Andrew Morton <akpm@linux-foundation.org>
> CC: Frederic Weisbecker <fweisbec@gmail.com>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
> 
> This is the first of a series of 202 patches removing EXPERIMENTAL from
> all the Kconfigs in the tree. Should I send them all to lkml (with all
> the associated CCs), or do people want to cherry-pick changes from my
> tree? I don't want to needlessly flood the list.
> 
> http://git.kernel.org/?p=linux/kernel/git/kees/linux.git;a=shortlog;h=refs/heads/experimental
> 
> I figure this patch can stand alone to at least make EXPERIMENTAL go
> away from the menus, and give us a taste of what the removal would do
> to builds.

OK, I will bite...  How should I flag an option that is initially only
intended for those willing to take some level of risk?

							Thanx, Paul

> Thanks,
> 
> -Kees
> 
> ---
>  init/Kconfig |   31 ++-----------------------------
>  1 file changed, 2 insertions(+), 29 deletions(-)
> 
> diff --git a/init/Kconfig b/init/Kconfig
> index cb003a3..f6f8146 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -33,35 +33,8 @@ config BUILDTIME_EXTABLE_SORT
>  menu "General setup"
> 
>  config EXPERIMENTAL
> -	bool "Prompt for development and/or incomplete code/drivers"
> -	---help---
> -	  Some of the various things that Linux supports (such as network
> -	  drivers, file systems, network protocols, etc.) can be in a state
> -	  of development where the functionality, stability, or the level of
> -	  testing is not yet high enough for general use. This is usually
> -	  known as the "alpha-test" phase among developers. If a feature is
> -	  currently in alpha-test, then the developers usually discourage
> -	  uninformed widespread use of this feature by the general public to
> -	  avoid "Why doesn't this work?" type mail messages. However, active
> -	  testing and use of these systems is welcomed. Just be aware that it
> -	  may not meet the normal level of reliability or it may fail to work
> -	  in some special cases. Detailed bug reports from people familiar
> -	  with the kernel internals are usually welcomed by the developers
> -	  (before submitting bug reports, please read the documents
> -	  <file:README>, <file:MAINTAINERS>, <file:REPORTING-BUGS>,
> -	  <file:Documentation/BUG-HUNTING>, and
> -	  <file:Documentation/oops-tracing.txt> in the kernel source).
> -
> -	  This option will also make obsoleted drivers available. These are
> -	  drivers that have been replaced by something else, and/or are
> -	  scheduled to be removed in a future kernel release.
> -
> -	  Unless you intend to help test and develop a feature or driver that
> -	  falls into this category, or you have a situation that requires
> -	  using these features, you should probably say N here, which will
> -	  cause the configurator to present you with fewer choices. If
> -	  you say Y here, you will be offered the choice of using features or
> -	  drivers that are currently considered to be in the alpha-test phase.
> +	bool
> +	default y
> 
>  config BROKEN
>  	bool
> -- 
> 1.7.9.5
> 
> 
> -- 
> Kees Cook
> Chrome OS Security
> 


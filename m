Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933919Ab2JWUnG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 16:43:06 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:42015 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933423Ab2JWUnC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:43:02 -0400
Date: Tue, 23 Oct 2012 13:41:51 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Greg KH <gregkh@linuxfoundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 001/193] make CONFIG_EXPERIMENTAL invisible and default
Message-ID: <20121023204151.GK2585@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1351022666-6960-1-git-send-email-keescook@chromium.org>
 <1351022666-6960-2-git-send-email-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351022666-6960-2-git-send-email-keescook@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12102320-5406-0000-0000-0000015D93DC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2012 at 01:01:14PM -0700, Kees Cook wrote:
> This config item has not carried much meaning for a while now and is
> almost always enabled by default (especially in distro builds). As agreed
> during the Linux kernel summit, it should be removed. As a first step,
> remove it from being listed, and default it to on. Once it has been
> removed from all subsystem Kconfigs, it will be dropped entirely.
> 
> For items that really are experimental, maintainers should use "default
> n", optionally include "(EXPERIMENTAL)" in the title, and add language to
> the help text indicating why the item should be considered experimental.
> 
> For items that are dangerously experimental, the maintainer is encouraged
> to follow the above title recommendation, add stronger language to the
> help text, and optionally use (depending on the extent of the danger,
> from least to most dangerous): printk(), add_taint(TAINT_WARN),
> add_taint(TAINT_CRAP), WARN_ON(1), and CONFIG_BROKEN.
> 
> CC: Greg KH <gregkh@linuxfoundation.org>
> CC: "Eric W. Biederman" <ebiederm@xmission.com>
> CC: Serge Hallyn <serge.hallyn@canonical.com>
> CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> CC: Andrew Morton <akpm@linux-foundation.org>
> CC: Frederic Weisbecker <fweisbec@gmail.com>
> Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
> Signed-off-by: Kees Cook <keescook@chromium.org>

Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> ---
>  init/Kconfig |   31 ++-----------------------------
>  1 file changed, 2 insertions(+), 29 deletions(-)
> 
> diff --git a/init/Kconfig b/init/Kconfig
> index 6fdd6e3..2bf7b83 100644
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


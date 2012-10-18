Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752560Ab2JRXJ6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 19:09:58 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:49359 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751039Ab2JRXJ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 19:09:57 -0400
X-Originating-IP: 217.70.178.152
X-Originating-IP: 173.246.103.110
Date: Thu, 18 Oct 2012 16:09:49 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Ed Cashin <ecashin@coraid.com>
Cc: akpm@linux-foundation.org, rob@landley.net, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sparse@vger.kernel.org,
        sam@ravnborg.org, sparse@chrisli.org, ak@linux.intel.com
Subject: Re: [PATCH] Documentation/sparse.txt: document context annotations
 for lock checking
Message-ID: <20121018230948.GC10627@jtriplet-mobl1>
References: <1350570446.22036@cat.he.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350570446.22036@cat.he.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18, 2012 at 07:27:26AM -0700, Ed Cashin wrote:
> The context feature of sparse is used with the Linux kernel
> sources to check for imbalanced uses of locks.  Document the
> annotations defined in include/linux/compiler.h that tell sparse
> what to expect when a lock is held on function entry, exit, or
> both.
> 
> Signed-off-by: Ed Cashin <ecashin@coraid.com>

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

>  Documentation/sparse.txt |   18 ++++++++++++++++++
>  1 files changed, 18 insertions(+), 0 deletions(-)
> 
> diff --git a/Documentation/sparse.txt b/Documentation/sparse.txt
> index 4909d41..eceab13 100644
> --- a/Documentation/sparse.txt
> +++ b/Documentation/sparse.txt
> @@ -49,6 +49,24 @@ be generated without __CHECK_ENDIAN__.
>  __bitwise - noisy stuff; in particular, __le*/__be* are that.  We really
>  don't want to drown in noise unless we'd explicitly asked for it.
>  
> +Using sparse for lock checking
> +~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> +
> +The following macros are undefined for gcc and defined during a sparse
> +run to use the "context" tracking feature of sparse, applied to
> +locking.  These annotations tell sparse when a lock is held, with
> +regard to the annotated function's entry and exit.
> +
> +__must_hold - The specified lock is held on function entry and exit.
> +
> +__acquires - The specified lock is held on function exit, but not entry.
> +
> +__releases - The specified lock is held on function entry, but not exit.
> +
> +If the function enters and exits without the lock held, acquiring and
> +releasing the lock inside the function in a balanced way, no
> +annotation is needed.  The tree annotations above are for cases where
> +sparse would otherwise report a context imbalance.
>  
>  Getting sparse
>  ~~~~~~~~~~~~~~
> -- 
> 1.7.1
> 

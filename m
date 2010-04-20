Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754673Ab0DTNWY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 09:22:24 -0400
Received: from kroah.org ([198.145.64.141]:34844 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754494Ab0DTNWX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 09:22:23 -0400
Date: Tue, 20 Apr 2010 06:22:11 -0700
From: Greg KH <greg@kroah.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Herbert Xu <herbert@gondor.hengli.com.au>, linux-kernel@vger.kernel.org,
       Brandon Philips <brandon@ifup.org>, stable@kernel.org
Subject: Re: [stable] [PATCH] module: drop the lock while waiting for
 module to complete initialization.
Message-ID: <20100420132211.GA27374@kroah.com>
References: <201004201849.04960.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201004201849.04960.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 20, 2010 at 06:49:04PM +0930, Rusty Russell wrote:
> This fixes "gave up waiting for init of module libcrc32c." which
> happened at boot time due to multiple parallel module loads.
> 
> The problem was a deadlock: we wait for a module to finish
> initializing, but we keep the module_lock mutex so it can't complete.
> In particular, this could reasonably happen if a module does a
> request_module() in its initialization routine.
> 
> So we change use_module() to return an errno rather than a bool, and if
> it's -EBUSY we drop the lock and wait in the caller, then reaquire the
> lock.
> 
> Reported-by: Brandon Philips <brandon@ifup.org>
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> Tested-by: Brandon Philips <brandon@ifup.org>
> ---

If you wish to have patches included "automatically" in the stable
kernel releases, just add:
	Cc: stable <stable@kernel.org>
to the signed-off-by area of your patch.  Then, when the patch goes into
Linus's tree, I get notified of it and can trivially add it to the
proper kernel trees.

Otherwise I need to go dig through git and watch to see if/when the
patch shows up there or not, which takes a lot of time when having to do
it for a lot of patches.

thanks,

greg k-h

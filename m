Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932298Ab2J0REv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2012 13:04:51 -0400
Received: from mga14.intel.com ([143.182.124.37]:42691 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751765Ab2J0REt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2012 13:04:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,662,1344236400"; 
   d="scan'208";a="210140938"
Date: Sun, 28 Oct 2012 01:04:45 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, alan@lxorguk.ukuu.org.uk,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [ 16/85] use clamp_t in UNAME26 fix
Message-ID: <20121027170445.GA31432@localhost>
References: <20121026000031.107227138@linuxfoundation.org>
 <20121026000032.757987970@linuxfoundation.org>
 <1351354318.4834.7.camel@deadeye.wl.decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351354318.4834.7.camel@deadeye.wl.decadent.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 27, 2012 at 05:11:58PM +0100, Ben Hutchings wrote:
> On Thu, 2012-10-25 at 17:05 -0700, Greg Kroah-Hartman wrote:
> > 3.6-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Kees Cook <keescook@chromium.org>
> > 
> > commit 31fd84b95eb211d5db460a1dda85e004800a7b52 upstream.
> > 
> > The min/max call needed to have explicit types on some architectures
> > (e.g. mn10300). Use clamp_t instead to avoid the warning:
> > 
> >   kernel/sys.c: In function 'override_release':
> >   kernel/sys.c:1287:10: warning: comparison of distinct pointer types lacks a cast [enabled by default]
> 
> While this change makes the code more readable, I think the bug is
> really in the type definitions for those architectures:
> 
> [...]
> > -		copy = min(sizeof(buf), max_t(size_t, 1, len));
> > +		copy = clamp_t(size_t, len, 1, sizeof(buf));
> [...]
> 
> 1. sizeof(buf) yields a value of type size_t, by definition.
> 2. max_t(size_t, 1, len) yields a value of type size_t.
> 3. Therefore min(sizeof(buf), max_t(size_t, 1, len)) is valid.
> 
> The only way I see to get this warning is to define size_t wrongly, so
> that (1) is not true.

Agreed. mn10300 and cris seem to have problems with size_t.
Here is a related issue: 

Re: [next:akpm 155/157] drivers/char/random.c:827:3: warning: format '%zd' expects argument of type 'signed size_t', but argument 7 has type 'size_t'
https://lkml.org/lkml/2012/10/23/792

Thanks,
Fengguang

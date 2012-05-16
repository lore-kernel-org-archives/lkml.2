Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752174Ab2EPOL6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 10:11:58 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44897 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045Ab2EPOL4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 10:11:56 -0400
Date: Wed, 16 May 2012 07:11:51 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: Kees Cook <keescook@chromium.org>, Colin Cross <ccross@android.com>,
        devel@driverdev.osuosl.org, linaro-kernel@lists.linaro.org,
        Arnd Bergmann <arnd@arndb.de>, patches@linaro.org,
        Marco Stornelli <marco.stornelli@gmail.com>,
        Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        arve@android.com, Jesper Juhl <jj@chaosbits.net>,
        John Stultz <john.stultz@linaro.org>, Shuah Khan <shuahkhan@gmail.com>,
        Rebecca Schultz Zavin <rebecca@android.com>,
        WANG Cong <xiyou.wangcong@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, kernel-team@android.com,
        Thomas Meyer <thomas@m3y3r.de>
Subject: Re: [PATCH 2/6] ramoops: Move to fs/pstore/ram.c
Message-ID: <20120516141151.GA939@kroah.com>
References: <20120516124109.GA14658@lizard>
 <20120516124308.GB18345@lizard>
 <20120516131751.GA23849@kroah.com>
 <20120516135749.GA26387@lizard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120516135749.GA26387@lizard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 16, 2012 at 06:57:49AM -0700, Anton Vorontsov wrote:
> On Wed, May 16, 2012 at 06:17:51AM -0700, Greg Kroah-Hartman wrote:
> [...]
> > > --- a/drivers/char/Kconfig
> > > +++ b/drivers/char/Kconfig
> > > @@ -585,15 +585,6 @@ config DEVPORT
> > >  
> > >  source "drivers/s390/char/Kconfig"
> > >  
> > > -config RAMOOPS
> > > -	tristate "Log panic/oops to a RAM buffer"
> > > -	depends on HAS_IOMEM
> > > -	depends on PSTORE
> > 
> > This "depends on PSTORE" line is not in my staging-next tree, where did
> > it come from?
> 
> The thing is that ramoops switched to pstore just recently, and the
> patch is in -mm tree.
> 
> (Just for the record, I use linux-next-20120504, HEAD at commit
> 44449d2b34aca3b1)
> 
> > I'm guessing that because of this, is why the other conflict happens,
> > right?
> 
> Yep.
> 
> > Any ideas on what I can do to resolve it?  As you are moving a file, I
> > want to make sure I move the correct version of it :)
> 
> There's a cross-tree dependency with -mm tree, as it appears.
> 
> So, I'm not sure which is better:
> 
> 1. Push the whole pile of patches via -mm; or
> 
> 2. You apply the two patches from -mm tree before my series:
>    	"ramoops: use pstore interface"
>    	linux-next commit 60aad9fc1f04ca19e800c5984ad84f405d133a11
>    and
>    	"ramoops: fix printk format warnings"
>    	linux-next commit f2a28afdb529c43a7eb21fd0c991cab5676ef011
> 
>    http://userweb.kernel.org/~akpm/mmotm/ seem to not respond at the
>    moment, so I guess the easiest way to grab the patches would
>    be to cherry-pick the two commits above from the linux-next
>    repository. That way Andrew would automatically drop them
>    from his tree.

Ok, I'll pick from linux-next, that seems to be the easiest way.  I'll
do that later this morning and let you know how it goes...

greg k-h

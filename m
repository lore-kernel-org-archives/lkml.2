Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753453Ab2JZC1Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 22:27:25 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55284 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752446Ab2JZC1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 22:27:23 -0400
Date: Thu, 25 Oct 2012 19:28:03 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jonathan Nieder <jrnieder@gmail.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        alan@lxorguk.ukuu.org.uk, Fengguang Wu <fengguang.wu@intel.com>,
        Kees Cook <keescook@chromium.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [ 08/31] use clamp_t in UNAME26 fix
Message-ID: <20121026022803.GA2938@kroah.com>
References: <20121026000214.941721299@linuxfoundation.org>
 <20121026000215.817875317@linuxfoundation.org>
 <20121026001119.GA3028@elie.Belkin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121026001119.GA3028@elie.Belkin>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 25, 2012 at 05:11:19PM -0700, Jonathan Nieder wrote:
> Hi,
> 
> Greg Kroah-Hartman wrote:
> 
> > commit 31fd84b95eb211d5db460a1dda85e004800a7b52 upstream.
> >
> > The min/max call needed to have explicit types on some architectures
> > (e.g. mn10300). Use clamp_t instead to avoid the warning:
> >
> >   kernel/sys.c: In function 'override_release':
> >   kernel/sys.c:1287:10: warning: comparison of distinct pointer types lacks a cast [enabled by default]
> >
> > Reported-by: Fengguang Wu <fengguang.wu@intel.com>
> > Signed-off-by: Kees Cook <keescook@chromium.org>
> > Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> [...]
> > --- a/kernel/sys.c
> > +++ b/kernel/sys.c
> > @@ -1152,7 +1152,7 @@ static int override_release(char __user
> >  			rest++;
> >  		}
> >  		v = ((LINUX_VERSION_CODE >> 8) & 0xff) + 40;
> > -		copy = min(sizeof(buf), max_t(size_t, 1, len));
> > +		copy = clamp_t(size_t, len, 1, sizeof(buf));
> >  		copy = scnprintf(buf, copy, "2.6.%u%s", v, rest);
> 
> Does this have any effect at runtime?  If not, why is it needed for
> stable kernels?

It's a bugfix for the previous patch in this area, fixing the build
warning.  I don't like adding stable patches that add new warnings :)

thanks,

greg k-h

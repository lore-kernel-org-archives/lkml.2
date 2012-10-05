Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756093Ab2JEO0o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 10:26:44 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64216 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754709Ab2JEO0n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 10:26:43 -0400
Date: Fri, 5 Oct 2012 07:26:39 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Borislav Petkov <bp@amd64.org>, Jiri Slaby <jslaby@suse.cz>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        LKML <linux-kernel@vger.kernel.org>, Joe Perches <joe@perches.com>
Subject: Re: [PATCH] Fix bogus "callbacks suppressed" messages
Message-ID: <20121005142639.GA20065@kroah.com>
References: <20121004092055.GA21028@aftab.osrc.amd.com>
 <20121004112347.GA245@x4>
 <20121004115157.GA245@x4>
 <20121004124025.GC21028@aftab.osrc.amd.com>
 <20121004131101.GA245@x4>
 <506EC1AE.6000201@suse.cz>
 <20121005122741.GB8019@aftab.osrc.amd.com>
 <20121005125717.GB245@x4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121005125717.GB245@x4>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 05, 2012 at 02:57:17PM +0200, Markus Trippelsdorf wrote:
> On the current git tree one sees messages such as:
>  tty_init_dev: 24 callbacks suppressed
>  tty_init_dev: 3 callbacks suppressed
> 
> To fix this we need to look at condition before calling __ratelimit in
> the WARN_RATELIMIT macro. While at it remove the superfluous
> __WARN_RATELIMIT macros.
> 
> Original patch is from Joe Perches and Jiri Slaby.
> 
> Signed-off-by: Markus Trippelsdorf <markus@trippelsdorf.de>
> Acked-and-tested-by: Borislav Petkov <borislav.petkov@amd.com>
> ---
>  include/linux/ratelimit.h | 27 +++++++++------------------
>  1 file changed, 9 insertions(+), 18 deletions(-)

I don't have a problem with this patch, but I don't understand why it's
now showing up.  There haven't been any changes in the ratelimit.h area
recently that I can see, so why is this change needed now?  What is in
the tty layer that is causing this, just the fact that it's actually
being used now?

thanks,

greg k-h

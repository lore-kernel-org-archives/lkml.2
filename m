Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752549Ab0G2BGN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 21:06:13 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:56780 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751163Ab0G2BGJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 21:06:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=n6YsuKEIIDdXSXAGh32zQzA07QURqoFH7crJsLkj81oQq6u3z7/Hq84NL3531ykQR+
         FEIw7apMUNUwUzoQJYGtY1UFUm3KOASo1Smh8pdXTdDHfBcVsK5R/woPRzdT5AXrRhvr
         wwd0Iadr7OzLj06Y7MF7nFpSxeKvF2sPDsxkQ=
Date: Thu, 29 Jul 2010 03:06:08 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net
Subject: Re: [GIT PULL] kgdb regression fixes for 2.6.35-rc5
Message-ID: <20100729010607.GB13088@nowhere>
References: <1280349590-27754-1-git-send-email-jason.wessel@windriver.com> <20100728211725.GF5394@nowhere> <AANLkTikXGm0WK+N=YMWJc+hBgVAyLc0adu4K1iX5UMW=@mail.gmail.com> <4C50C7F2.8020305@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C50C7F2.8020305@windriver.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 28, 2010 at 07:14:42PM -0500, Jason Wessel wrote:
> On 07/28/2010 04:26 PM, Linus Torvalds wrote:
> > On Wed, Jul 28, 2010 at 2:17 PM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> >> I'm sorry I spot it a bit late.
> >> There is a little issue in this patch, irqs won't
> >> be restored:
> >>
> >> @@ -588,9 +588,10 @@ int kgdb_ll_trap(int cmd, const char *str,
> >>        if (!kgdb_io_module_registered)
> >>                return NOTIFY_DONE;
> >>
> >> +       local_irq_save(flags);
> >>        return __kgdb_notify(&args, cmd);
> >> +       local_irq_restore(flags);
> >>  }
> > 
> > Yeah, that's obviously crap. I also wonder why __kgdb_notify messes up
> > the flags to begin with.
> > 
> 
> This should not be needed as the irqs should already be off while in the overflow handler.



Interrupts are not disabled in the debug exception handler.

I'm not sure what would be the state of dr6 if a nested debug exception
would happen while do_debug() is interrupted.

Perhaps the previous dr6 value is dropped. Intel manuals don't seem to say anything
about that.

Anyway that's a separate issue. The current patch fixes a regression and
it looks good.

Thanks.


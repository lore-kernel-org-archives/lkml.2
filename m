Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753561Ab1JYUzh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 16:55:37 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:32843 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752585Ab1JYUze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 16:55:34 -0400
X-Sasl-enc: wDJdWcdWT0FT8hnw8KWHSvKueZ3Pxed77WMkAfHVbMYz 1319576133
Date: Tue, 25 Oct 2011 22:54:10 +0200
From: Greg KH <greg@kroah.com>
To: Dave Jones <davej@redhat.com>, Nick Bowler <nbowler@elliptictech.com>,
        Ben Hutchings <ben@decadent.org.uk>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Randy Dunlap <rdunlap@xenotime.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Debian kernel maintainers <debian-kernel@lists.debian.org>
Subject: Re: [PATCH] module,bug: Add TAINT_OOT_MODULE flag for modules not
 built in-tree
Message-ID: <20111025205410.GA7479@kroah.com>
References: <1319461948.31243.31.camel@deadeye>
 <4EA57CBF.2050901@xenotime.net>
 <87k47tpvvm.fsf@rustcorp.com.au>
 <20111025153855.GA24779@elliptictech.com>
 <1319558749.11727.6.camel@deadeye>
 <20111025165142.GA25354@elliptictech.com>
 <20111025200455.GA6376@kroah.com>
 <20111025201723.GA25063@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111025201723.GA25063@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 25, 2011 at 04:17:24PM -0400, Dave Jones wrote:
> On Tue, Oct 25, 2011 at 10:04:55PM +0200, Greg Kroah-Hartman wrote:
>  > On Tue, Oct 25, 2011 at 12:51:42PM -0400, Nick Bowler wrote:
>  > > On 2011-10-25 18:05 +0200, Ben Hutchings wrote:
>  > > > On Tue, 2011-10-25 at 11:38 -0400, Nick Bowler wrote:
>  > > > > This patch prevents the use of lockdep for debugging out of tree
>  > > > > modules, which is rather mean.
>  > > > 
>  > > > It was already disabled for staging modules, which seems equally
>  > > > unhelpful.
>  > > 
>  > > This is not the case: lockdep works fine with staging modules.
>  > 
>  > Yes, that was fixed a few kernel versions ago.
>  > 
>  > Now you might want to update that fix for the TAINT_OOT_MODULE flag as
>  > well, if you feel it is needed.
> 
> I'm assuming you mean this patch ?
> 
> commit 7816c45bf13255157c00fb8aca86cb64d825e878
> Author: Roland Vossen <rvossen@broadcom.com>
> Date:   Thu Apr 7 11:20:58 2011 +0200
> 
>     modules: Enabled dynamic debugging for staging modules

Hm, this is the patch I was thinking about yes.  But as you point out:

> If we want to support out of tree modules with this, should we just nuke the
> whole check, or do we still want to prevent certain types of tainted kernels
> from using this stuff ?

I don't know, there was some reason we didn't want to run dynamic_debug
for "normal" tainted kernel modules, but I can't recall it at the
moment, sorry.

> 
> (sidenote: it's not immediately obvious to me that this is the right patch,
> as dynamic debug & lockdep are separate things, though this was the only
> thing in kernel/module.c's history this year that sounds similar)

Perhaps the lockdep thing is totally different.  I don't know about that
check.

thanks,

greg k-h

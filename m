Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756625Ab1KNXVO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 18:21:14 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:24344 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752638Ab1KNXVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 18:21:12 -0500
Date: Tue, 15 Nov 2011 00:27:00 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Andrei Warkentin <awarkentin@vmware.com>
cc: linux-kernel@vger.kernel.org, Andrei Warkentin <andreiw@vmware.com>
Subject: Re: [PATCH] include/log2.h: Fix rounddown_pow_of_two(1)
In-Reply-To: <210327451.46002.1321305431817.JavaMail.root@zimbra-prod-mbox-2.vmware.com>
Message-ID: <alpine.LNX.2.00.1111150024190.9919@swampdragon.chaosbits.net>
References: <210327451.46002.1321305431817.JavaMail.root@zimbra-prod-mbox-2.vmware.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Nov 2011, Andrei Warkentin wrote:

> ----- Original Message -----
> > From: "Jesper Juhl" <jj@chaosbits.net>
> > To: "Andrei Warkentin" <andreiw@vmware.com>
> > Cc: linux-kernel@vger.kernel.org
> > Sent: Tuesday, November 8, 2011 2:57:27 PM
> > Subject: Re: [PATCH] include/log2.h: Fix rounddown_pow_of_two(1)
> > 
> > On Tue, 8 Nov 2011, Andrei Warkentin wrote:
> > 
> > > 1 is a power of two, therefore rounddown_pow_of_two(1) should
> > > return 1. It does
> > > in case the argument is a variable but in case it's a constant it
> > > behaves
> > > wrong and returns 0. Probably nobody ever did it so this was never
> > > noticed,
> > > however net/drivers/vmxnet3 with latest GCC does and breaks on
> > > unicpu systems.
> > > 
> > > Signed-off-by: Andrei Warkentin <andreiw@vmware.com>
> > > ---
> > >  include/linux/log2.h |    2 +-
> > >  1 files changed, 1 insertions(+), 1 deletions(-)
> > > 
> > > diff --git a/include/linux/log2.h b/include/linux/log2.h
> > > index 25b8086..ccda848 100644
> > > --- a/include/linux/log2.h
> > > +++ b/include/linux/log2.h
> > > @@ -185,7 +185,7 @@ unsigned long __rounddown_pow_of_two(unsigned
> > > long n)
> > >  #define rounddown_pow_of_two(n)			\
> > >  (						\
> > >  	__builtin_constant_p(n) ? (		\
> > > -		(n == 1) ? 0 :			\
> > > +		(n == 1) ? 1 :			\
> > >  		(1UL << ilog2(n))) :		\
> > >  	__rounddown_pow_of_two(n)		\
> > >   )
> > > 
> > 
> > For what it's worth; looks good to me.
> 
> Is that an Acked-by or a Reviewed-by?
> 
I don't really know (to be honest). I guess it is whichever is weakest, 
since I did review the patch and convinced myself that the change was 
sane, but didn't spent a whole lot of time checking that *all* users were 
OK with it...


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.


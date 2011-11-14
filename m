Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756502Ab1KNVRO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 16:17:14 -0500
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:30285 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754868Ab1KNVRN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 16:17:13 -0500
Date: Mon, 14 Nov 2011 13:17:11 -0800 (PST)
From: Andrei Warkentin <awarkentin@vmware.com>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-kernel@vger.kernel.org, Andrei Warkentin <andreiw@vmware.com>
Message-ID: <210327451.46002.1321305431817.JavaMail.root@zimbra-prod-mbox-2.vmware.com>
In-Reply-To: <alpine.LNX.2.00.1111082056510.5763@swampdragon.chaosbits.net>
Subject: Re: [PATCH] include/log2.h: Fix rounddown_pow_of_two(1)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.113.60.13]
X-Mailer: Zimbra 7.1.3_GA_3374 (ZimbraWebClient - FF3.0 (Linux)/7.1.3_GA_3346)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----
> From: "Jesper Juhl" <jj@chaosbits.net>
> To: "Andrei Warkentin" <andreiw@vmware.com>
> Cc: linux-kernel@vger.kernel.org
> Sent: Tuesday, November 8, 2011 2:57:27 PM
> Subject: Re: [PATCH] include/log2.h: Fix rounddown_pow_of_two(1)
> 
> On Tue, 8 Nov 2011, Andrei Warkentin wrote:
> 
> > 1 is a power of two, therefore rounddown_pow_of_two(1) should
> > return 1. It does
> > in case the argument is a variable but in case it's a constant it
> > behaves
> > wrong and returns 0. Probably nobody ever did it so this was never
> > noticed,
> > however net/drivers/vmxnet3 with latest GCC does and breaks on
> > unicpu systems.
> > 
> > Signed-off-by: Andrei Warkentin <andreiw@vmware.com>
> > ---
> >  include/linux/log2.h |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/include/linux/log2.h b/include/linux/log2.h
> > index 25b8086..ccda848 100644
> > --- a/include/linux/log2.h
> > +++ b/include/linux/log2.h
> > @@ -185,7 +185,7 @@ unsigned long __rounddown_pow_of_two(unsigned
> > long n)
> >  #define rounddown_pow_of_two(n)			\
> >  (						\
> >  	__builtin_constant_p(n) ? (		\
> > -		(n == 1) ? 0 :			\
> > +		(n == 1) ? 1 :			\
> >  		(1UL << ilog2(n))) :		\
> >  	__rounddown_pow_of_two(n)		\
> >   )
> > 
> 
> For what it's worth; looks good to me.

Is that an Acked-by or a Reviewed-by?

Thanks,
A

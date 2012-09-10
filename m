Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756801Ab2IJKaX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 06:30:23 -0400
Received: from caiajhbdccah.dreamhost.com ([208.97.132.207]:58337 "EHLO
	homiemail-a3.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756196Ab2IJKaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 06:30:08 -0400
X-Greylist: delayed 69961 seconds by postgrey-1.27 at vger.kernel.org; Mon, 10 Sep 2012 06:30:08 EDT
Message-ID: <1347273004.2561.8.camel@offbook>
Subject: Re: [PATCH] lib: gcd: prevent possible div by 0
From: Davidlohr Bueso <dave@gnu.org>
Reply-To: dave@gnu.org
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, stable@vger.kernel.org
Date: Mon, 10 Sep 2012 12:30:04 +0200
In-Reply-To: <1347268343.1234.1307.camel@edumazet-glaptop>
References: <1347203038.3288.1.camel@offbook>
	 <1347268343.1234.1307.camel@edumazet-glaptop>
Organization: GNU
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-09-10 at 11:12 +0200, Eric Dumazet wrote:
> On Sun, 2012-09-09 at 17:03 +0200, Davidlohr Bueso wrote:
> > Account for properties when a and/or b are 0:
> > gcd(0, 0) = 0
> > gcd(a, 0) = a
> > gcd(0, b) = b
> > 
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Davidlohr Bueso <dave@gnu.org>
> > ---
> >  lib/gcd.c |    3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > diff --git a/lib/gcd.c b/lib/gcd.c
> > index cce4f3c..7e163c6 100644
> > --- a/lib/gcd.c
> > +++ b/lib/gcd.c
> > @@ -7,6 +7,9 @@ unsigned long gcd(unsigned long a, unsigned long b)
> >  {
> >  	unsigned long r;
> >  
> > +	if (!a || !b)
> > +		return a | b;
> 
> This seems overkill

It might, but it reads better, IMHO.

> 
> > +
> >  	if (a < b)
> >  		swap(a, b);
> 
> better here to :
> 	if (!b)
> 		return a;
> 

Sure, I don't mind either way. I'll send a v2 shortly.

Thanks for reviewing.
Davidlohr



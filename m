Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751782Ab2ILTUf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 15:20:35 -0400
Received: from caiajhbdcbbj.dreamhost.com ([208.97.132.119]:49673 "EHLO
	homiemail-a7.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751160Ab2ILTUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 15:20:33 -0400
Message-ID: <1347477630.3384.1.camel@offbook>
Subject: Re: [PATCH v2] lib: gcd: prevent possible div by 0
From: Davidlohr Bueso <dave@gnu.org>
Reply-To: dave@gnu.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, lkml <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org
Date: Wed, 12 Sep 2012 21:20:30 +0200
In-Reply-To: <20120912121055.bd417043.akpm@linux-foundation.org>
References: <1347287719.2561.14.camel@offbook>
	 <20120912121055.bd417043.akpm@linux-foundation.org>
Organization: GNU
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-09-12 at 12:10 -0700, Andrew Morton wrote:
> On Mon, 10 Sep 2012 16:35:19 +0200
> Davidlohr Bueso <dave@gnu.org> wrote:
> 
> > Account for all properties when a and/or b are 0:
> > gcd(0, 0) = 0
> > gcd(a, 0) = a
> > gcd(0, b) = b
> > 
> > Cc: stable@vger.kernel.org
> 
> Why cc:stable?  If this patch fixes some known problem in the current
> kernel then that really really should have been described in the
> changelog.  Always.  Please.

Ok, I will keep it in mind next time. No known problem (at least that I
know of), but due to the nature of the potential bug, I thought that it
was worth adding it to stable.

Thanks.

> 
> > ...
> > --- a/lib/gcd.c
> > +++ b/lib/gcd.c
> > @@ -9,6 +9,9 @@ unsigned long gcd(unsigned long a, unsigned long b)
> >  
> >  	if (a < b)
> >  		swap(a, b);
> > +
> > +	if (!b)
> > +		return a;
> >  	while ((r = a % b) != 0) {
> >  		a = b;
> >  		b = r;
> > -- 
> > 1.7.9.5
> > 
> > 
> 



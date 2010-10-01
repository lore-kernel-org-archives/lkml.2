Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932626Ab0JAO2d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 10:28:33 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:40892 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932180Ab0JAO2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 10:28:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:in-reply-to:references
         :x-mailer:mime-version:content-type:content-transfer-encoding;
        b=FQou9Gca0rsaGVli1AWUIT3NEBcgeoarFWoNGarWZLD9XvB6X5ZVkFFGgs2r1eQZIG
         K4LiJ3gqcdpF7DhRtC9YRkuJBv4FWZcnt5d+9QEe0eFV7Ij7OFb5F4k03QOQBFju3F+D
         oD3Ztc3mRxicU5bt++emcjAJYF85xpA/9CZGI=
Date: Fri, 1 Oct 2010 17:28:23 +0300
From: Pekka Paalanen <pq@iki.fi>
To: Pekka Enberg <penberg@kernel.org>
Cc: dave@gnu.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        LKML <linux-kernel@vger.kernel.org>, x86@kernel.org
Subject: Re: [RESEND PATCH] x86: return proper error code
Message-ID: <20101001172823.42424961@daedalus.pq.iki.fi>
In-Reply-To: <AANLkTinQ05Hrn8oLtMBLKrs5NOXqzg1CfK+aESTUnJTx@mail.gmail.com>
References: <1285875794.2180.0.camel@cowboy>
	<AANLkTinQ05Hrn8oLtMBLKrs5NOXqzg1CfK+aESTUnJTx@mail.gmail.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Sep 2010 22:49:36 +0300
Pekka Enberg <penberg@kernel.org> wrote:

> On Thu, Sep 30, 2010 at 10:43 PM, Davidlohr Bueso <dave@gnu.org>
> wrote:
> > x86: return -ENOMEM instead of -1 when returning on memory
> > allocation errors in add_kmmio_fault_page()
> >
> > Signed-off-by: Davidlohr Bueso <dave@gnu.org>
> > ---
> >  arch/x86/mm/kmmio.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> >
> > diff --git a/arch/x86/mm/kmmio.c b/arch/x86/mm/kmmio.c
> > index e5d5e2c..36a4347 100644
> > --- a/arch/x86/mm/kmmio.c
> > +++ b/arch/x86/mm/kmmio.c
> > @@ -370,7 +370,7 @@ static int add_kmmio_fault_page(unsigned
> > long page)
> >
> >        f = kzalloc(sizeof(*f), GFP_ATOMIC);
> >        if (!f)
> > -               return -1;
> > +               return -ENOMEM;
> >
> >        f->count = 1;
> >        f->page = page;
> 
> This doesn't matter much as register_kmmio_probe() doesn't do
> anything sane with the error code and ioremap_trace_core()
> ignores what register_mmio_probe() does completely. I'd either
> keep the code as-is or try to fix up the fishy error handling
> properly.

Yes, I agree completely with Pekka.

-- 
Pekka Paalanen
http://www.iki.fi/pq/

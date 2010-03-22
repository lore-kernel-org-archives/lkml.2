Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754837Ab0CVNst (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 09:48:49 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:46875 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754742Ab0CVNsq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 09:48:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=NCu0GsLdPOU0k4emUQuF6SJV+j1mSVo+ECkCOawSGiO1p5WEzWMvHH0VbiV4sRB1+D
         rWUhvgr1By3p5g7VcucaocDwKYXYKJFWVDnH19fOc+GcbOjxUtHPw5pn0t1U4Ec7yw10
         qJJgKCLh1qXmRDd4SEYsFvme7/wG++JrWQ/wQ=
Date: Mon, 22 Mar 2010 16:48:36 +0300
From: Dan Carpenter <error27@gmail.com>
To: Steffen Klassert <steffen.klassert@secunet.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
       "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] pcrypt: handle crypto_get_attr_type() errors
Message-ID: <20100322134836.GP21571@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
References: <20100321092847.GJ5331@bicker> <20100322132342.GJ20508@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100322132342.GJ20508@secunet.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 22, 2010 at 02:23:42PM +0100, Steffen Klassert wrote:
> On Sun, Mar 21, 2010 at 12:28:47PM +0300, Dan Carpenter wrote:
> > crypto_get_attr_type() can returns ERR_PTRs if there is a problem. 
> > 
> > Signed-off-by: Dan Carpenter <error27@gmail.com>
> > 
> > diff --git a/crypto/pcrypt.c b/crypto/pcrypt.c
> > index 8020124..41bd80f 100644
> > --- a/crypto/pcrypt.c
> > +++ b/crypto/pcrypt.c
> > @@ -322,6 +322,8 @@ static struct crypto_instance *pcrypt_alloc_aead(struct rtattr **tb)
> >  	struct crypto_attr_type *algt;
> >  
> >  	algt = crypto_get_attr_type(tb);
> > +	if (IS_ERR(algt))
> > +		return ERR_CAST(algt);
> >  
> >  	alg = crypto_get_attr_alg(tb, algt->type,
> >  				  (algt->mask & CRYPTO_ALG_TYPE_MASK));
> 
> I've just noticed that we are calling crypto_get_attr_type already in
> pcrypt_alloc, so perhaps we could just pass the type and mask to
> pcrypt_alloc_aead. Then we can remove this second call to
> crypto_get_attr_type completely.
> 

Yup.  That works too.  I will send an updated patch.

regards,
dan carpenter

> Steffen

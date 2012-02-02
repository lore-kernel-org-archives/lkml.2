Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932115Ab2BBOmY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 09:42:24 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:26525 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756338Ab2BBOmW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 09:42:22 -0500
Date: Thu, 2 Feb 2012 15:42:43 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Steffen Klassert <steffen.klassert@secunet.com>
cc: "devendra.aaru" <devendra.aaru@gmail.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH] In crypto_add_alg(), 'exact' wants to be initialized to
 0
In-Reply-To: <20120202075122.GA23142@secunet.com>
Message-ID: <alpine.LNX.2.00.1202021541440.12088@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1201292337390.27749@swampdragon.chaosbits.net> <CAHdPZaP4aArSh7G15KhP2ombW8Zs2L4osQ0xi0W829oBZSuTtg@mail.gmail.com> <alpine.LNX.2.00.1202012050390.8577@swampdragon.chaosbits.net> <20120202075122.GA23142@secunet.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-296885160-1328193764=:12088"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-296885160-1328193764=:12088
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT

On Thu, 2 Feb 2012, Steffen Klassert wrote:

> On Wed, Feb 01, 2012 at 09:21:39PM +0100, Jesper Juhl wrote:
> > On Wed, 1 Feb 2012, devendra.aaru wrote:
> > 
> > > On Sun, Jan 29, 2012 at 5:39 PM, Jesper Juhl <jj@chaosbits.net> wrote:
> > > > We declare 'exact' without initializing it and then do:
> > > >
> > > > [...]
> > > >        if (strlen(p->cru_driver_name))
> > > >                exact = 1;
> > > >
> > > >        if (priority && !exact)
> > > >                return -EINVAL;
> > > >
> > > > [...]
> > > >
> > > > If the first 'if' is not true, then the second will test an
> > > > uninitialized 'exact'.
> > > 
> > > not needed . as the cru_driver_name will always be present :).
> > 
> > If that is indeed the case, and we are guaranteed that, then it would seem 
> > that a patch like the following would be what we want instead??
> > 
> > Please note that this patch is intended just for discussion, nothing else 
> > (which is why I left out a Signed-off-by on purpose), since I've not 
> > tested it beyond checking that it compiles, nor have I verified your claim 
> > that cru_driver_name will always be present.
> > 
> 
> We get cru_driver_name from a netlink message that a user sends us.
> So it depends pretty much on the user whether cru_driver_name is
> set or not. Usually it is set when a user wants to instantiate
> a certain algorithm driver, like "cbc(aes-asm)". If the user just
> wants to instantiate the system default of an algorithm, he can
> set cru_name (e.g. to "cbc(aes)") instead of cru_driver_name.
> 
> Your first patch is correct.
> 
Thank you for the explanation.

Can I take that to mean that I can add your Acked-by: if/when I resend the 
patch?

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

--8323328-296885160-1328193764=:12088--

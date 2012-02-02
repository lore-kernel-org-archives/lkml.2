Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754098Ab2BBHv1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 02:51:27 -0500
Received: from a.mx.secunet.com ([195.81.216.161]:46369 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753733Ab2BBHvZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 02:51:25 -0500
Date: Thu, 2 Feb 2012 08:51:22 +0100
From: Steffen Klassert <steffen.klassert@secunet.com>
To: Jesper Juhl <jj@chaosbits.net>
Cc: "devendra.aaru" <devendra.aaru@gmail.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH] In crypto_add_alg(), 'exact' wants to be initialized
 to 0
Message-ID: <20120202075122.GA23142@secunet.com>
References: <alpine.LNX.2.00.1201292337390.27749@swampdragon.chaosbits.net>
 <CAHdPZaP4aArSh7G15KhP2ombW8Zs2L4osQ0xi0W829oBZSuTtg@mail.gmail.com>
 <alpine.LNX.2.00.1202012050390.8577@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LNX.2.00.1202012050390.8577@swampdragon.chaosbits.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 02 Feb 2012 07:51:22.0510 (UTC) FILETIME=[74E40AE0:01CCE17F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 01, 2012 at 09:21:39PM +0100, Jesper Juhl wrote:
> On Wed, 1 Feb 2012, devendra.aaru wrote:
> 
> > On Sun, Jan 29, 2012 at 5:39 PM, Jesper Juhl <jj@chaosbits.net> wrote:
> > > We declare 'exact' without initializing it and then do:
> > >
> > > [...]
> > >        if (strlen(p->cru_driver_name))
> > >                exact = 1;
> > >
> > >        if (priority && !exact)
> > >                return -EINVAL;
> > >
> > > [...]
> > >
> > > If the first 'if' is not true, then the second will test an
> > > uninitialized 'exact'.
> > 
> > not needed . as the cru_driver_name will always be present :).
> 
> If that is indeed the case, and we are guaranteed that, then it would seem 
> that a patch like the following would be what we want instead??
> 
> Please note that this patch is intended just for discussion, nothing else 
> (which is why I left out a Signed-off-by on purpose), since I've not 
> tested it beyond checking that it compiles, nor have I verified your claim 
> that cru_driver_name will always be present.
> 

We get cru_driver_name from a netlink message that a user sends us.
So it depends pretty much on the user whether cru_driver_name is
set or not. Usually it is set when a user wants to instantiate
a certain algorithm driver, like "cbc(aes-asm)". If the user just
wants to instantiate the system default of an algorithm, he can
set cru_name (e.g. to "cbc(aes)") instead of cru_driver_name.

Your first patch is correct.

Thanks,

Steffen


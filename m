Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753629Ab1AJTMT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 14:12:19 -0500
Received: from mail.hosted.servetheworld.net ([83.143.81.74]:49261 "EHLO
	mail.hosted.servetheworld.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753465Ab1AJTMQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 14:12:16 -0500
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Mon, 10 Jan 2011 14:12:15 EST
X-Originating-IP: 89.226.207.247
From: Dag Arne Osvik <da@osvik.no>
Reply-To: Dag Arne Osvik <da@osvik.no>
To: Neil Horman <nhorman@tuxdriver.com>,
        Nikos Mavrogiannopoulos <nmav@gnutls.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: Crypto Update for 2.6.38
X-Mailer: Modest 3.2
References: <20100804140448.GA4042@gondor.apana.org.au>
	 <20101024061625.GA23715@gondor.apana.org.au>
	 <20110106000157.GA16089@gondor.apana.org.au>
	 <AANLkTikzg3Hndp8WRi59bvJdBLxi=p-1gt7aZDLYbSW8@mail.gmail.com>
	 <20110106211645.GA26184@gondor.apana.org.au>
	 <AANLkTimwaJCUxvMLoeS5Cpmu7FX3y=coeSdkPrrL4zcr@mail.gmail.com>
	 <20110106213932.GA26538@gondor.apana.org.au>
	 <AANLkTi=fggNhMm1LpOzzZ0_ofaU6w=ahX8SMGgFkHCui@mail.gmail.com>
	 <20110107120451.GA22347@hmsreliant.think-freely.org>
	 <AANLkTi=wLQNF2p3v_-2F9hLobVVqQTOQB8F76a=fSoLW@mail.gmail.com>
	  <20110110120302.GA5869@hmsreliant.think-freely.org>
In-Reply-To: <20110110120302.GA5869@hmsreliant.think-freely.org>
Content-Type: text/plain; charset=utf-8
Content-ID: <1294686329.16075.1.camel@Nokia-N900-51-1>
Date: Mon, 10 Jan 2011 20:05:30 +0100
Message-Id: <1294686330.16075.2.camel@Nokia-N900-51-1>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Sat, Jan 08, 2011 at 03:23:04PM +0200, Nikos Mavrogiannopoulos wrote:
> > On Fri, Jan 7, 2011 at 2:04 PM, Neil Horman <nhorman@tuxdriver.com>
> > wrote:
> > 
> > > > Btw, it doesn't have to be about performance per se. Does this
> > > > allow people to use keys without actually _seeing_ those keys?
> > > > Your example implies that that is not the case, but that's
> > > > actually one of the few reasons to actually support a kernel
> > > > crypto interface - the ability to have private personal keys
> > > > around, but not having to actually let possibly untrusted programs
> > > > see them.
> > > This actually is an indirect feature of this interface.  Using it,
> > > you can open a algorithm socket, select a specific alg, assign a
> > > key, and then pass that socket descriptor over a unix socket to an
> > > another process using an SCM_RIGHTS ancilliary message.  The
> > > receiving process can then use children acceppted from that passed
> > > socket to preform the configured crypto operation without any
> > > knoweldge of the keys used in it.  I can write a demo app if you
> > > like.
> > 
> > Several things have to be considered when extending an interface like
> > that. For example, do the algorithm implementations protect against
> > timing attacks, or keys can be recovered, using them? What is the
> No, the kernel does not implement any protection against timing attacks
> in the algorithms per-se, but preforming a timing attack against a
> kernel crypto operation is going to be near impossible anyway, as
> precise timing measurements are going to get obscured by interupts,
> scheduling jitter, lock contention, and various other factors that will
> make measuring syscall time fairly useless.

Let me just point out that this is not near impossible at all; instead it has already been done more than 6 years ago. And it's not only syscall time that leaks information. One practical example is recovery of a full AES key in a couple of seconds, using cache attacks against an encrypted file system. AES-NI is immune to this kind of attack, but other algorithms typically implemented using lookup tables are at risk.

Dag Arne


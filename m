Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752517Ab1AHNXH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jan 2011 08:23:07 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:51870 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751779Ab1AHNXF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jan 2011 08:23:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=vIf9aOsSKlWjiUTMNnUjkkwEzcB9QM0NGLjDPpjKZ8EGgjyus2ERPVJPXMg5WyP9uC
         0qvqaOnHrr8/jhEN+KMTx0QC7SC72B4Xt1JpAUNbe4SDo/v7aqOT8bupyMK+3cCyqqfc
         gKx2HZvHByTVEjy8h2yqB9zG/fICLvwu0zgvg=
MIME-Version: 1.0
In-Reply-To: <20110107120451.GA22347@hmsreliant.think-freely.org>
References: <20100519020603.GA19654@gondor.apana.org.au>
	<20100521104404.GA29530@gondor.apana.org.au>
	<20100804140448.GA4042@gondor.apana.org.au>
	<20101024061625.GA23715@gondor.apana.org.au>
	<20110106000157.GA16089@gondor.apana.org.au>
	<AANLkTikzg3Hndp8WRi59bvJdBLxi=p-1gt7aZDLYbSW8@mail.gmail.com>
	<20110106211645.GA26184@gondor.apana.org.au>
	<AANLkTimwaJCUxvMLoeS5Cpmu7FX3y=coeSdkPrrL4zcr@mail.gmail.com>
	<20110106213932.GA26538@gondor.apana.org.au>
	<AANLkTi=fggNhMm1LpOzzZ0_ofaU6w=ahX8SMGgFkHCui@mail.gmail.com>
	<20110107120451.GA22347@hmsreliant.think-freely.org>
Date: Sat, 8 Jan 2011 15:23:04 +0200
X-Google-Sender-Auth: YVmAW-Trm7LTnF-gDyvASXvRKDU
Message-ID: <AANLkTi=wLQNF2p3v_-2F9hLobVVqQTOQB8F76a=fSoLW@mail.gmail.com>
Subject: Re: Crypto Update for 2.6.38
From: Nikos Mavrogiannopoulos <nmav@gnutls.org>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 7, 2011 at 2:04 PM, Neil Horman <nhorman@tuxdriver.com> wrote:

>> Btw, it doesn't have to be about performance per se. Does this allow
>> people to use keys without actually _seeing_ those keys? Your example
>> implies that that is not the case, but that's actually one of the few
>> reasons to actually support a kernel crypto interface - the ability to
>> have private personal keys around, but not having to actually let
>> possibly untrusted programs see them.
> This actually is an indirect feature of this interface.  Using it, you can open
> a algorithm socket, select a specific alg, assign a key, and then pass that
> socket descriptor over a unix socket to an another process using an
> SCM_RIGHTS ancilliary message.  The receiving process can then use children
> acceppted from that passed socket to preform the configured crypto operation
> without any knoweldge of the keys used in it.  I can write a demo app if you
> like.

Several things have to be considered when extending an interface like
that. For example, do the algorithm implementations protect against
timing attacks, or keys can be recovered, using them? What is the
purpose of cryptographic key separation? If long term keys are to be
protected, then it makes sense to support RSA, DSA keys in addition to
symmetric keys (e.g. microsoft only supports assymetric keys for
separation, since symmetric ones are rarely used as long term keys -
[in TLS-PSK]).

Some of these issues are discussed in my report on a user-space crypto
interface that specifically targeted separation and speed at [0].

regards,
Nikos

[0]. https://www.cosic.esat.kuleuven.be/publications/article-1490.pdf

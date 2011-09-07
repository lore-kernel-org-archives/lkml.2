Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757225Ab1IGVf7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 17:35:59 -0400
Received: from mail.atsec.com ([195.30.99.214]:39131 "EHLO mail.atsec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757178Ab1IGVf5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 17:35:57 -0400
X-Greylist: delayed 516 seconds by postgrey-1.27 at vger.kernel.org; Wed, 07 Sep 2011 17:35:57 EDT
Message-ID: <4E67E1B0.2040309@atsec.com>
Date: Wed, 07 Sep 2011 23:27:12 +0200
From: Stephan Mueller <stephan.mueller@atsec.com>
Organization: atsec information security GmbH
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110906 Thunderbird/7.0
MIME-Version: 1.0
To: "Ted Ts'o" <tytso@mit.edu>, Steve Grubb <sgrubb@redhat.com>,
        Jarod Wilson <jarod@redhat.com>, Sasha Levin <levinsasha928@gmail.com>,
        linux-crypto@vger.kernel.org, Matt Mackall <mpm@selenic.com>,
        Neil Horman <nhorman@redhat.com>, Herbert Xu <herbert.xu@redhat.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] random: add blocking facility to urandom
References: <1314974248-1511-1-git-send-email-jarod@redhat.com> <4E67B75B.8010500@redhat.com> <20110907192737.GD20571@thunk.org> <201109071602.24519.sgrubb@redhat.com> <20110907211858.GE20571@thunk.org>
In-Reply-To: <20110907211858.GE20571@thunk.org>
X-Enigmail-Version: 1.4a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07.09.2011 23:18:58, +0200, Ted Ts'o <tytso@mit.edu> wrote:

Hi Ted,

> On Wed, Sep 07, 2011 at 04:02:24PM -0400, Steve Grubb wrote:
>>
>> When a system is underattack, do you really want to be using a PRNG
>> for anything like seeding openssl?  Because a PRNG is what urandom
>> degrades into when its attacked.
> 
> This is not technically true.  urandom degrades into a CRNG
> (cryptographic random number generator).  In fact what most security
> experts recommend is to take a small amount of security, and then use
> that to seed a CRNG.

Correct.

However, a CRNG shall be reseeded once in a while - see standard crypto
libraries and their CRNGs (OpenSSL being a notable exception here). And
that is what this entire discussion is all about: to ensure that the
CRNG is reseeded with entropy, eventually.

> 
>> If enough bytes are read that an
>> attacker can guess the internal state of the RNG, do you really want
>> it seeding a openssh session?
> 
> In a cryptographic random number generator, there is a either a
> cryptographic hash or a encryption algorithm at the core.  So you
> would need a huge amounts of bytes, and then you would have to carry
> out an attack on the cryptographic core.

Correct.

And exactly that is the concern from organizations like BSI. Their
cryptographer's concern is that due to the volume of data that you can
extract from /dev/urandom, you may find cycles or patterns that increase
the probability to guess the next random value compared to brute force
attack. Note, it is all about probabilities.
> 
> If this is the basis for the patch, then we should definitely NACK it.
> It sounds like snake oil fear mongering.
> 
> 					- Ted
> 
> 
> 


-- 
Ciao
Stephan

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932678Ab1JaQnV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 12:43:21 -0400
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:57322 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932144Ab1JaQnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 12:43:20 -0400
Message-ID: <4EAED00C.3010908@xenotime.net>
Date: Mon, 31 Oct 2011 09:42:52 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Herbert Xu <herbert@gondor.hengli.com.au>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: Crypto Update for 3.2
References: <20091204135530.GA29371@gondor.apana.org.au> <20100226004914.GA20812@gondor.apana.org.au> <20100519020603.GA19654@gondor.apana.org.au> <20100521104404.GA29530@gondor.apana.org.au> <20100804140448.GA4042@gondor.apana.org.au> <20101024061625.GA23715@gondor.apana.org.au> <20110106000157.GA16089@gondor.apana.org.au> <20110315145940.GA15373@gondor.apana.org.au> <20110520235409.GA1722@gondor.apana.org.au> <20110724011752.GA14373@gondor.apana.org.au> <20111031040952.GA19659@gondor.apana.org.au>
In-Reply-To: <20111031040952.GA19659@gondor.apana.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/30/2011 09:09 PM, Herbert Xu wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> Hi Linus:
> 
> Here is the crypto update for 3.2:
> 
> * User-space interface for algorithm selection/configuration
> * SSSE3 implementation of SHA1.
> * X86-64 assembly implementation of blowfish.
> * X86-64 assembly implementation of twofish.
> * Misc fixes.
> 
> 
> Please pull from
> 
> git://github.com/herbertx/crypto.git
> 
> 
> The top commit object is
> 
> 	commit ea8bdfcff17599e5d80f93e2ae194fbbab7f8d5e
> 	Author: Herbert Xu <herbert@gondor.apana.org.au>
> 	Date:   Wed Oct 26 17:15:10 2011 +0200
> 
> 	    crypto: user - Add dependency on NET


> Herbert Xu (4):
>       crypto: sha - Fix build error due to crypto_sha1_update
>       crypto: cryptd - Use subsys_initcall to prevent races with aesni
>       crypto: user - Initialise match in crypto_alg_match
>       crypto: user - Add dependency on NET

Actually adds "select NET", a reverse dependency.  :(

Linus was quite vocal about not allowing MD to select BLOCK.
See https://lkml.org/lkml/2011/8/10/527
and https://lkml.org/lkml/2011/8/10/533

To me this is very similar.

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***

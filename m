Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757546Ab1IANjz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 09:39:55 -0400
Received: from orbit.nwl.cc ([91.121.141.167]:54585 "EHLO orbit.nwl.cc"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757466Ab1IANjx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 09:39:53 -0400
Date: Thu, 1 Sep 2011 15:39:52 +0200
From: Phil Sutter <phil@nwl.cc>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: Nikos Mavrogiannopoulos <nmav@gnutls.org>, cryptodev-linux-devel@gna.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: comparison of the AF_ALG interface with the /dev/crypto
Message-ID: <20110901133952.GB14522@orbit.nwl.cc>
Mail-Followup-To: Herbert Xu <herbert@gondor.apana.org.au>,
	Nikos Mavrogiannopoulos <nmav@gnutls.org>,
	cryptodev-linux-devel@gna.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <4E5A3FCC.2030504@gnutls.org>
 <20110901021534.GA26330@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110901021534.GA26330@gondor.apana.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Herbert,

On Thu, Sep 01, 2011 at 12:15:34PM +1000, Herbert Xu wrote:
> Nikos Mavrogiannopoulos <nmav@gnutls.org> wrote:
> >
> > Given my benchmarks have no issues, it is not apparent to me why one
> > should use AF_ALG instead of cryptodev. I do not know though why AF_ALG
> > performs so poor. I'd speculate by blaming it on the usage of the socket
> > API and the number of system calls required.
> 
> The target usage of AF_ALG is hardware offload devices that cannot
> be directly used in user-space, not software crypto on implementations
> such as AESNI/Padlock.
> 
> Going through the kernel to use something like AESNI/Padlock or
> software crypto is insane.
> 
> Given the intended target case, your numbers are pretty much
> meaningless as cryptodev's performance can be easily beaten
> by a pure user-space implementation.

I ran the benchmarks on my OpenRD Ultimate, an embedded device equipped
with the Marvell Kirkwood SoC, which also contains the CESA crypto
engine. Hopefully a less "insane" use-case, also from your point of
view. Here are the results of the "fulltest", i.e. init, AES128 and deinit
measured as a whole:

chunksize       af_alg          cryptodev       (100 * cryptodev / af_alg)
--------------------------------------------------------------------------
512              4.169 MB/s      7.113 MB/s     171 %
1024             7.904 MB/s     12.957 MB/s     164 %
2048            13.163 MB/s     19.683 MB/s     150 %
4096            20.218 MB/s     26.960 MB/s     133 %
8192            27.539 MB/s     34.373 MB/s     125 %
16384           33.730 MB/s     39.997 MB/s     119 %
32768           37.399 MB/s     42.727 MB/s     114 %
65536           40.004 MB/s     44.660 MB/s     112 %

although I'm quite sure there's a reason why these values are
meaningless as well, I would like to point out that cryptodev-linux has
outperformed AF_ALG in every situation they have been compared so far.

Greetings, Phil

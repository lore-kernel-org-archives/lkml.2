Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932404Ab1IAPJb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 11:09:31 -0400
Received: from orbit.nwl.cc ([91.121.141.167]:40181 "EHLO orbit.nwl.cc"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932185Ab1IAPJa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 11:09:30 -0400
Date: Thu, 1 Sep 2011 17:09:28 +0200
From: Phil Sutter <phil@nwl.cc>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: nmav@gnutls.org, cryptodev-linux-devel@gna.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: comparison of the AF_ALG interface with the /dev/crypto
Message-ID: <20110901150928.GC14522@orbit.nwl.cc>
Mail-Followup-To: Herbert Xu <herbert@gondor.apana.org.au>, nmav@gnutls.org,
	cryptodev-linux-devel@gna.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <20110901133952.GB14522@orbit.nwl.cc>
 <20110901141445.GA31447@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110901141445.GA31447@gondor.apana.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Herbert,

On Thu, Sep 01, 2011 at 10:14:45PM +0800, Herbert Xu wrote:
> Phil Sutter <phil@nwl.cc> wrote:
> > 
> > chunksize       af_alg          cryptodev       (100 * cryptodev / af_alg)
> > --------------------------------------------------------------------------
> > 512              4.169 MB/s      7.113 MB/s     171 %
> > 1024             7.904 MB/s     12.957 MB/s     164 %
> > 2048            13.163 MB/s     19.683 MB/s     150 %
> > 4096            20.218 MB/s     26.960 MB/s     133 %
> > 8192            27.539 MB/s     34.373 MB/s     125 %
> > 16384           33.730 MB/s     39.997 MB/s     119 %
> > 32768           37.399 MB/s     42.727 MB/s     114 %
> > 65536           40.004 MB/s     44.660 MB/s     112 %
> 
> Are you maxing out your submission CPU? If not then you're testing
> the latency of the interface, as opposed to the throughput.

Good point. So in order to also test the throughput, I've put my OpenRD
under load:

| stress -c 2 -i 2 -m 2 --vm-bytes 64MB

and ran the tests again:

chunksize       af_alg          cryptodev       (100 * cryptodev / af_alg)
--------------------------------------------------------------------------
512              0.618 MB/s      1.14 MB/s      184 %
1024             1.258 MB/s      2.28 MB/s      181 %
2048             2.453 MB/s      4.39 MB/s      179 %
4096             4.540 MB/s      7.76 MB/s      171 %
8192             7.981 MB/s     11.67 MB/s      146 %
16384           12.543 MB/s     14.08 MB/s      112 %
32768           13.139 MB/s     14.46 MB/s      110 %
65536           14.254 MB/s     15.55 MB/s      109 %

So that means cryptodev-linux is superior in throughput as well as
latency, right? Or is it the lower latency of the interface causing the
higher throughput?

Greetings, Phil

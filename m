Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753784Ab0EaWHK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 18:07:10 -0400
Received: from ringil.hengli.com.au ([216.59.3.182]:35182 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752638Ab0EaWHI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 18:07:08 -0400
Date: Tue, 1 Jun 2010 08:07:00 +1000
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Andi Kleen <andi@firstfloor.org>
Cc: Milan Broz <mbroz@redhat.com>,
       device-mapper development <dm-devel@redhat.com>,
       linux-kernel@vger.kernel.org, agk@redhat.com, ak@linux.intel.com
Subject: Re: [dm-devel] [PATCH] DM-CRYPT: Scale to multiple CPUs
Message-ID: <20100531220700.GA23076@gondor.apana.org.au>
References: <20100531160425.GA20344@basil.fritz.box> <4C03F04D.4040200@redhat.com> <20100531174225.GE10766@basil.fritz.box> <4C03FB8E.1060109@redhat.com> <20100531182724.GG10766@basil.fritz.box> <4C040636.8060702@redhat.com> <20100531190400.GH10766@basil.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100531190400.GH10766@basil.fritz.box>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 31, 2010 at 09:04:00PM +0200, Andi Kleen wrote:
> > I mean how it is implemented now in crypto API, and I was almost
> > sure that aes-ni acceleration code uses cryptd (iow real asynchronous processing)
> > and also that not all CPU cores can run these instruction in parallel.
> 
> I think you can configure it to use cryptd (or pcrypt), but it's not default
> and usually higher overhead.

Right.  The only reason aes-ni uses the async interface is to
work around the fact that you have to save FPU state when using
it.  For dm-crypt you can consider it to be synchronous.

Note that cryptd is nothing like pcrypt.  cryptd always keeps
the work on the local CPU, even if goes into another thread.

OTOH pcrypt was designed to parallelise the work across CPUs.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

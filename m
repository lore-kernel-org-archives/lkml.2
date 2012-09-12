Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753301Ab2ILUaj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 16:30:39 -0400
Received: from caiajhbdcbhh.dreamhost.com ([208.97.132.177]:55239 "EHLO
	homiemail-a61.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752467Ab2ILUah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 16:30:37 -0400
Message-ID: <1347481832.3384.12.camel@offbook>
Subject: Re: [PATCH v2] lib: gcd: prevent possible div by 0
From: Davidlohr Bueso <dave@gnu.org>
Reply-To: dave@gnu.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, lkml <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org
Date: Wed, 12 Sep 2012 22:30:32 +0200
In-Reply-To: <20120912123625.fd09bd60.akpm@linux-foundation.org>
References: <1347287719.2561.14.camel@offbook>
	 <20120912121055.bd417043.akpm@linux-foundation.org>
	 <1347477630.3384.1.camel@offbook>
	 <20120912123625.fd09bd60.akpm@linux-foundation.org>
Organization: GNU
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-09-12 at 12:36 -0700, Andrew Morton wrote:
> On Wed, 12 Sep 2012 21:20:30 +0200
> Davidlohr Bueso <dave@gnu.org> wrote:
> 
> > On Wed, 2012-09-12 at 12:10 -0700, Andrew Morton wrote:
> > > On Mon, 10 Sep 2012 16:35:19 +0200
> > > Davidlohr Bueso <dave@gnu.org> wrote:
> > > 
> > > > Account for all properties when a and/or b are 0:
> > > > gcd(0, 0) = 0
> > > > gcd(a, 0) = a
> > > > gcd(0, b) = b
> > > > 
> > > > Cc: stable@vger.kernel.org
> > > 
> > > Why cc:stable?  If this patch fixes some known problem in the current
> > > kernel then that really really should have been described in the
> > > changelog.  Always.  Please.
> > 
> > Ok, I will keep it in mind next time. No known problem (at least that I
> > know of), but due to the nature of the potential bug, I thought that it
> > was worth adding it to stable.
> 
> OK.
> 
> I'm not personally averse to fixing such problems in -stable,
> particualrly in lib/ code.  After all, people who take -stable kernels
> will then change them and add drivers and backport changes from later
> kernels, etc.  They might be bitten by such a bug.

Yes, my thoughts exactly.
> 
> 
> I'm scratching my head a bit at the patch though.  What does gcd(0, 13)
> mean?  That 0 can be divided by 13 zero times, which is an integer
> result?  I wonder why any non-buggy code would do that....
> 

While I've been away from this kind of math for a while, based on the
Euclid's algorithm, if r = a mod b, then gcd(a, b) = gcd(b, r), so:

gcd(0, 13) = gcd(13, 0 mod 13) = gcd(13, 0)

Since the GCD  of a and b is "the largest integer that divides both a
and b with no remainder", when r = 0, the algorithm will stop and
therefore gcd(13, 0) = 13.

http://mitpress.mit.edu/sicp/full-text/sicp/book/node19.html


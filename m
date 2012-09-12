Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754981Ab2ILVi2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 17:38:28 -0400
Received: from mx.scalarmail.ca ([98.158.95.75]:48148 "EHLO
	ironport-01.sms.scalar.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754833Ab2ILViZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 17:38:25 -0400
Date: Wed, 12 Sep 2012 17:38:21 -0400
From: Nick Bowler <nbowler@elliptictech.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dave@gnu.org, Eric Dumazet <eric.dumazet@gmail.com>,
        lkml <linux-kernel@vger.kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH v2] lib: gcd: prevent possible div by 0
Message-ID: <20120912213821.GA30480@elliptictech.com>
References: <1347287719.2561.14.camel@offbook>
 <20120912121055.bd417043.akpm@linux-foundation.org>
 <1347477630.3384.1.camel@offbook>
 <20120912123625.fd09bd60.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120912123625.fd09bd60.akpm@linux-foundation.org>
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-09-12 12:36 -0700, Andrew Morton wrote:
> On Wed, 12 Sep 2012 21:20:30 +0200
> Davidlohr Bueso <dave@gnu.org> wrote:
> > On Wed, 2012-09-12 at 12:10 -0700, Andrew Morton wrote:
> > > On Mon, 10 Sep 2012 16:35:19 +0200
> > > Davidlohr Bueso <dave@gnu.org> wrote:
> > > 
> > > > Account for all properties when a and/or b are 0:
> > > > gcd(0, 0) = 0
> > > > gcd(a, 0) = a
> > > > gcd(0, b) = b
[...]
> I'm scratching my head a bit at the patch though.  What does gcd(0, 13)
> mean?  That 0 can be divided by 13 zero times, which is an integer
> result?  I wonder why any non-buggy code would do that....

The number-theoretical definition of gcd(a, b) on the integers, leaving
aside the case where a and b are both 0, are defined as the greatest
integer which divides both a and b.

An integer x divides y if there exists an integer M such that x*M
equals y.

Observe that all integers divide zero (since we can set M to 0, and
x*0 = 0 for any x).  So it's easy to see that the result of gcd(x, 0)
and gcd(0, x) must be |x|.

The case of gcd(0, 0) is tricky.  Clearly, as all integers divide zero,
none of these can be the greatest one.  So this is normally treated as a
special case, defined to be 0 by convention, as this makes the use of
gcd "nicer" in other areas of mathematics.

Cheers,
-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)


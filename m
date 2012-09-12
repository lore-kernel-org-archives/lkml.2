Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751200Ab2ILTg2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 15:36:28 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39233 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074Ab2ILTg1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 15:36:27 -0400
Date: Wed, 12 Sep 2012 12:36:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: dave@gnu.org
Cc: Eric Dumazet <eric.dumazet@gmail.com>, lkml <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] lib: gcd: prevent possible div by 0
Message-Id: <20120912123625.fd09bd60.akpm@linux-foundation.org>
In-Reply-To: <1347477630.3384.1.camel@offbook>
References: <1347287719.2561.14.camel@offbook>
	<20120912121055.bd417043.akpm@linux-foundation.org>
	<1347477630.3384.1.camel@offbook>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Sep 2012 21:20:30 +0200
Davidlohr Bueso <dave@gnu.org> wrote:

> On Wed, 2012-09-12 at 12:10 -0700, Andrew Morton wrote:
> > On Mon, 10 Sep 2012 16:35:19 +0200
> > Davidlohr Bueso <dave@gnu.org> wrote:
> > 
> > > Account for all properties when a and/or b are 0:
> > > gcd(0, 0) = 0
> > > gcd(a, 0) = a
> > > gcd(0, b) = b
> > > 
> > > Cc: stable@vger.kernel.org
> > 
> > Why cc:stable?  If this patch fixes some known problem in the current
> > kernel then that really really should have been described in the
> > changelog.  Always.  Please.
> 
> Ok, I will keep it in mind next time. No known problem (at least that I
> know of), but due to the nature of the potential bug, I thought that it
> was worth adding it to stable.

OK.

I'm not personally averse to fixing such problems in -stable,
particualrly in lib/ code.  After all, people who take -stable kernels
will then change them and add drivers and backport changes from later
kernels, etc.  They might be bitten by such a bug.


I'm scratching my head a bit at the patch though.  What does gcd(0, 13)
mean?  That 0 can be divided by 13 zero times, which is an integer
result?  I wonder why any non-buggy code would do that....

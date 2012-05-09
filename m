Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759980Ab2EIU65 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 16:58:57 -0400
Received: from merlin.infradead.org ([205.233.59.134]:53632 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932395Ab2EIU6x convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 16:58:53 -0400
Message-ID: <1336597121.2527.74.camel@twins>
Subject: Re: [RFC][PATCH] printk: Add %pb to print bitmaps
From: Peter Zijlstra <peterz@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Igor Mammedov <imammedo@redhat.com>, Jiang Liu <liuj97@gmail.com>,
        linux-kernel@vger.kernel.org, mingo@kernel.org, pjt@google.com,
        tglx@linutronix.de, seto.hidetoshi@jp.fujitsu.com,
        Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 09 May 2012 22:58:41 +0200
In-Reply-To: <20120509120745.042e86c6.akpm@linux-foundation.org>
References: <1336559908-32533-1-git-send-email-imammedo@redhat.com>
	 <4FAA452A.1070909@gmail.com> <4FAA588B.5010404@redhat.com>
	 <1336564330.2527.23.camel@twins> <4FAA5BFB.40309@redhat.com>
	 <1336566096.2527.30.camel@twins> <1336566644.2527.33.camel@twins>
	 <1336570043.2527.38.camel@twins>
	 <20120509120745.042e86c6.akpm@linux-foundation.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-09 at 12:07 -0700, Andrew Morton wrote:
> On Wed, 09 May 2012 15:27:23 +0200
> Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > + * - 'b' For a bitmap, consumes 2 args, second is int
> 
> There's a pretty widespread convention that %b is used to print in
> binary: printf("%b", 10) -> 1010.  Regrettably it isn't part of
> standard C, but it's often supported anyway.  Perl's printf does this
> as well.  Perl uses %B also.
> 
> If we later want to add binary printing to kernel print(), we'd presumably
> use %pb, to match this precedent.

I'd expect something like %ub, %p would take a pointer to a value.

Too bad both %b and %B generate a warning, it would be rather trivial to
add base 2 number stuff.

> So perhaps it would be better to avoid consuming `b' for bitmaps?

With %.*pb not actually working I could use %pC to mean a cpumask and
skip the generic bitmap stuff.

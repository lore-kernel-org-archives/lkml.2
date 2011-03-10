Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752584Ab1CJGqk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 01:46:40 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:39025 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751894Ab1CJGqi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 01:46:38 -0500
Date: Thu, 10 Mar 2011 07:46:14 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Yinghai Lu <yinghai@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Russell King <linux@arm.linux.org.uk>,
        David Miller <davem@davemloft.net>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH/v2] mm/memblock: Properly handle overlaps and fix error
 path
Message-ID: <20110310064614.GE9289@elte.hu>
References: <1299466980.8833.973.camel@pasglop>
 <4D77E5E0.6010706@kernel.org>
 <1299705610.22236.390.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299705610.22236.390.camel@pasglop>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:

> On Wed, 2011-03-09 at 12:41 -0800, Yinghai Lu wrote:
> > > Hopefully not damaged with a spurious bit of email header this
> > > time around... sorry about that.
> > 
> > works on my setups...
> > 
> > [    0.000000] Subtract (26 early reservations)
> > [    0.000000]   [000009a000-000009efff]
> > [    0.000000]   [000009f400-00000fffff]
> > [    0.000000]   [0001000000-0003495048]
> > ...
> > before:
> > [    0.000000] Subtract (27 early reservations)
> > [    0.000000]   [000009a000-000009efff]
> > [    0.000000]   [000009f400-00000fffff]
> > [    0.000000]   [00000f85b0-00000f86b3]
> > [    0.000000]   [0001000000-0003495048] 
> 
> Ah interesting, so you did have a case of overlap that wasn't properly
> handled as well.
> 
> If there is no objection, I'll queue that up in powerpc-next for the
> upcoming merge window (soon now).

I think it would be better to do it via -mm, as x86 and other architectures are now 
affected by memblock changes as well.

Thanks,

	Ingo

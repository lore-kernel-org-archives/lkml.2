Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755681Ab2EIRbU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 13:31:20 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:56240 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176Ab2EIRbS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 13:31:18 -0400
Date: Wed, 9 May 2012 19:31:13 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Igor Mammedov <imammedo@redhat.com>, Jiang Liu <liuj97@gmail.com>,
        linux-kernel@vger.kernel.org, pjt@google.com, tglx@linutronix.de,
        seto.hidetoshi@jp.fujitsu.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Joe Perches <joe@perches.com>
Subject: Re: [RFC][PATCH] printk: Add %pb to print bitmaps
Message-ID: <20120509173113.GD8135@gmail.com>
References: <1336570043.2527.38.camel@twins>
 <20120509133607.GA26124@gmail.com>
 <1336571049.2527.43.camel@twins>
 <1336571947.2527.47.camel@twins>
 <20120509141528.GA3623@gmail.com>
 <1336577562.2527.58.camel@twins>
 <20120509154116.GC2653@gmail.com>
 <1336579592.2527.60.camel@twins>
 <20120509172403.GB8135@gmail.com>
 <1336584331.2527.63.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1336584331.2527.63.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Wed, 2012-05-09 at 19:24 +0200, Ingo Molnar wrote:
>
> > I don't think that's a significant limitation, because it's 
> > fixed width anyway. So if this works then this would be a 
> > pretty good and simple to use solution.
> 
> Not quite following, there's nothing fixed width about 
> bitmap_scnlistprintf() output.

There's a maximum field length possible, and we should/could use 
that as padding.

Say for 8 bits, the worst-case is something like:

  1-2,4-5,7-8

right? The max is roughly len*3/2.

I see a problem there: for something larger like 256 it would 
lead to quite some padding ...

Well, we could just skip doing width for now - the ability to 
easily print bitmaps is very valuable in itself.

Thanks,

	Ingo

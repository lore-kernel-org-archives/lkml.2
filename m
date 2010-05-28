Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753719Ab0E1SWi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 14:22:38 -0400
Received: from casper.infradead.org ([85.118.1.10]:59598 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753492Ab0E1SWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 14:22:37 -0400
Subject: Re: [PATCH] sched_clock: Provide local_clock() and improve 
 documentation
From: Peter Zijlstra <peterz@infradead.org>
To: Chad Talbott <ctalbott@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>, Divyesh Shah <dpshah@google.com>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <AANLkTimbh3CsxAh9egF0etp0-uMDGb5Z9qkoltPZ6Nay@mail.gmail.com>
References: <4BF9EC69.5030709@example.com> <1274777422.5882.591.camel@twins>
	 <20100526160252.325f8357.akpm@linux-foundation.org>
	 <1274942798.27810.3584.camel@twins>
	 <20100526235107.77e66ce0.akpm@linux-foundation.org>
	 <1274945751.27810.3765.camel@twins>
	 <20100527113340.d4afb8fc.akpm@linux-foundation.org>
	 <1275052414.1645.52.camel@laptop>
	 <AANLkTimbh3CsxAh9egF0etp0-uMDGb5Z9qkoltPZ6Nay@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 28 May 2010 20:22:33 +0200
Message-ID: <1275070953.1645.391.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-05-28 at 11:11 -0700, Chad Talbott wrote:
> On Fri, May 28, 2010 at 6:13 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> > + * local_clock()      -- is cpu_clock() on the current cpu.
> 
> Pretty sure this should read, "is cpu_clock() on *some* cpu," since
> there is no guarantee in a preemptible kernel that local_clock()
> returns on the same CPU that it was called from. The caller has to do
> the preempt protection itself.

Current cpu simply has no meaning if preemption isn't disabled. If it
is, it has and the result is useful.

Some of the local_clock() users are strictly per-cpu (and clearly have
preemption disabled), for some there simply is no better clock and
simply cope with the small incoherency in time.




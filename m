Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756072Ab0FSOYL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jun 2010 10:24:11 -0400
Received: from one.firstfloor.org ([213.235.205.2]:42338 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755978Ab0FSOYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jun 2010 10:24:10 -0400
Date: Sat, 19 Jun 2010 16:24:07 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>, Peter Zijlstra <peterz@infradead.org>,
       huang ying <huang.ying.caritas@gmail.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Huang Ying <ying.huang@intel.com>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Don Zickus <dzickus@redhat.com>, "H.PeterA" <"nvin hpa"@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC 1/3] Unified NMI delayed call mechanism
Message-ID: <20100619142406.GO18946@basil.fritz.box>
References: <4C15A5D1.1040104@jp.fujitsu.com>
 <20100618094838.GD23977@elte.hu>
 <AANLkTimqRwAjrQ_b8BZ28lEn_Gaz5-SpLULWASHD1fVn@mail.gmail.com>
 <20100618124551.GC7612@elte.hu>
 <AANLkTinaPhAcGra6JdmHCVcj9HrNyG2TP91-A8AnQMZE@mail.gmail.com>
 <20100618143532.GA10886@elte.hu>
 <AANLkTimI7efmGNeUkCVT2mUYD8LkYsLAS9chkPhZVA1E@mail.gmail.com>
 <1276875067.1875.133.camel@laptop>
 <20100619080210.GC18946@basil.fritz.box>
 <20100619105352.GA10186@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100619105352.GA10186@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 19, 2010 at 12:53:52PM +0200, Ingo Molnar wrote:
> 
> ( Ugh: what's this new fad of you not quoting the name of the person who 
>   wrote a mail? It makes multi-level quotes utterly unreadable as it's not
>   clear who wrote what. You should also respect others by quoting their names. )

To give you an excuse to flame of course. I know that's 
your favourite pastime and I'm always happy to make you happy.

> 
> Abusing the timer irq for that is an exceedingly ugly and unacceptable design, 
> as machine check events have nothing to do with timers. (That approach is also 
The rationale is that this nearly never happens in practice anyways
(the operations that trigger it do near always only happen with APICs)
AFAIK that's true for all the proposed users. 

For very rare and obscure cases like this in my experience
the simplest possible code is the best,
that makes it most likely it actually works when it's needed.
I do not know of any simpler way to implement this.

Of course if there's evidence it's actually common that would
need to be revisited.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.

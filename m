Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754965Ab0HPQ1O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 12:27:14 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:53516 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754872Ab0HPQ1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 12:27:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=eNDTHQtAEQ5sSRZOVr9AShSniA95WYROEwx5NNG4YcqHmP0T0K7MJNc3HLMwdIMmJ3
         XWx9c881CErUy666JVxMCv0WKH4KwQUEYLTMVaVwFMScGoVbpVMcUBJGgQDoG8wsUecQ
         K0nz1HJV9iHZZ9ut/Hwkk066alV3RnECwXSGw=
Date: Mon, 16 Aug 2010 20:27:06 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Robert Richter <robert.richter@amd.com>, Don Zickus <dzickus@redhat.com>,
        Lin Ming <ming.m.lin@intel.com>, Ingo Molnar <mingo@elte.hu>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>, Yinghai Lu <yinghai@kernel.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH -v2] perf, x86: try to handle unknown nmis with running
	perfctrs
Message-ID: <20100816162706.GH5805@lenovo>
References: <20100804161046.GC5130@lenovo> <20100804162026.GU3353@redhat.com> <20100804163930.GE5130@lenovo> <20100804184806.GL26154@erda.amd.com> <20100804192634.GG5130@lenovo> <20100806065203.GR26154@erda.amd.com> <20100806142131.GA1874@redhat.com> <20100809194829.GB26154@erda.amd.com> <20100811220058.GT26154@erda.amd.com> <1281970116.1926.1495.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1281970116.1926.1495.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 16, 2010 at 04:48:36PM +0200, Peter Zijlstra wrote:
...
> > There is another case if there are two subsequent back-to-back nmis
> > [3]. In this case we measure the time between the first and the
> > 2nd. The 2nd is detected as back-to-back because the first handled
> > more than one counter. The time between the 1st and the 2nd is used to
> > calculate a range for which we assume a back-to-back nmi. Now, the 3rd
> > nmi triggers, we measure again the time delta and compare it with the
> > first delta from which we know it was a back-to-back nmi. If the 3rd
> > nmi is within the range, it is also a back-to-back nmi and we drop it. 
> 
> I liked the one without funny timestamps in better, the whole timestamps
> thing just feels too fragile.
> 

Me too, the former Roberts patch (if I'm not missing something) looks good
to me.

>
> Relying on handled > 1 to arm the back-to-back filter seems doable.
> 

It's doable _but_ I think there is nothing we can do, there is no
way (at least I known of) to check if there is latched nmi from
perf counters. We only can assume that if there multiple counters
overflowed most probably the next unknown nmi has the same nature,
ie it came from perf. Yes, we can loose real unknown nmi in this
case but I think this is justified trade off. If an user need
a precise counting of unknown nmis he should not arm perf events
at all, if there an user with nmi button (guys where did you get this
magic buttuns? i need one ;) he better to not arm perf events too
otherwise he might have to click twice

(and of course we should keep in mind Andi's proposal but it
 is a next step I think).

> (Also, you didn't deal with the TSC going backwards..)
> 
	-- Cyrill

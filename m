Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757562Ab0LIXkg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 18:40:36 -0500
Received: from smtp109.prem.mail.ac4.yahoo.com ([76.13.13.92]:33698 "HELO
	smtp109.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757246Ab0LIXkc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 18:40:32 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: 5j5TBUkVM1nxnjrNPzh7YEbE8nGz3BiIZRR6DccakvFN5sE
 CL9WyPFgX0.T6pH2unHjxfZLUvEHOlkZP1R6TFfKDvrMqOBtWPBR6f9rsHye
 5x_nibqmlJ5k3Q0B1HLAkBZB5qGp5kQMFoHMk6I60xuZOQH8LP0iu6KLtSc2
 hvhoKp.iCT7W2bBiSc8m5mxtUzJ44LOJ4k4o5b7lONJ8qQkq_xCwS8Arv3Ov
 F2DTnqAQsfSLi4MZ2m8bAwOHl.75YsvlBdQ1cH_TQHQKfKuKsG9TOn7MXyqC
 LWU5df5JHH8RAp.qkvGmaN4nhSkLJhcPm9K2C1ljMlMPTGqE-
X-Yahoo-Newman-Property: ymail-3
Date: Thu, 9 Dec 2010 17:40:27 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Tejun Heo <tj@kernel.org>, akpm@linux-foundation.org,
        Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Arjan van de Ven <arjan@infradead.org>
Subject: Re: [cpuops cmpxchg V1 2/4] x86: this_cpu_cmpxchg and this_cpu_xchg
 operations
In-Reply-To: <4D0076B3.9090106@zytor.com>
Message-ID: <alpine.DEB.2.00.1012091739480.29367@router.home>
References: <20101208175520.456864019@linux.com> <20101208175543.000201149@linux.com> <alpine.DEB.2.00.1012081207250.26943@router.home> <20101208181736.GC30693@Krystal> <4D0076B3.9090106@zytor.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Dec 2010, H. Peter Anvin wrote:

> On 12/08/2010 10:17 AM, Mathieu Desnoyers wrote:
> >
> > Hi Christoph,
> >
> > Can you show if this provides savings in terms of:
> >
> > - instruction cache footprint
> > - cycles required to run
> > - large-scale impact on the branch prediction buffers
> >
> > Given that this targets per-cpu data only, the additional impact on cache-line
> > exchange traffic of using cmpxchg over xchg (cache-line not grabbed as exclusive
> > by the initial read) should not really matter.
> >
> > I'm CCing Arjan and HPA, because they might have some interesting insight into
> > the performance impact of lock-prefixed xchg vs using local cmpxchg in a loop.
> >
>
> XCHG is always locked; it doesn't need the prefix.  Unfortunately,
> unlike on the 8086 on modern processors locks have a real cost.

So should we use xchg or a loop using prefixless cmpxchg instead when
referring to per cpu data and requiring only per cpu atomicness?


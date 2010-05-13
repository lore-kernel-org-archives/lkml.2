Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758616Ab0EMKnz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 06:43:55 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:35646 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758300Ab0EMKnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 06:43:53 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Jiri Slaby <jslaby@suse.cz>
Subject: Re: [RFC] mm: generic adaptive large memory allocation APIs
Cc: kosaki.motohiro@jp.fujitsu.com, Changli Gao <xiaosuo@gmail.com>,
       akpm@linux-foundation.org, Eric Dumazet <eric.dumazet@gmail.com>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Alexey Dobriyan <adobriyan@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Avi Kivity <avi@redhat.com>,
       Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
In-Reply-To: <4BEBD180.3040404@suse.cz>
References: <20100513182403.217C.A69D9226@jp.fujitsu.com> <4BEBD180.3040404@suse.cz>
Message-Id: <20100513191838.217F.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 13 May 2010 19:43:49 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On 05/13/2010 11:40 AM, KOSAKI Motohiro wrote:
> >>>> Anyway as this is a replacement for explicit tests, it shouldn't change
> >>>> the behaviour in any way. Obviously when a user doesn't need virtually
> >>>> contiguous space, he shouldn't use this interface at all.
> >>>
> >>> Why can't we make fdtable virtually contiguous free?
> >>
> >> This is possible, but the question is why to make the code more complex?
> > 
> > because  it's broken.
> 
> Well, could you explain what exactly is broken about
> x = kmalloc(size, GFP_KERNEL);
> if (!x)
>   x = vmalloc(size);
> ? Is is that kmalloc doesn't return until is has the memory to return
> when asking for order(size) <= COSTLY_ORDER? I think this is expected.

Well, but fdtable doesn't really need contenious memory. no?
To make API mean we recommend to use it. but I don't hope to spread this 
wrong habit.  Instead, to kill it seems better.




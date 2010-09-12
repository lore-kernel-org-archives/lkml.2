Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752387Ab0ILJO4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Sep 2010 05:14:56 -0400
Received: from casper.infradead.org ([85.118.1.10]:58213 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751783Ab0ILJOz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Sep 2010 05:14:55 -0400
Subject: Re: [RFC patch 1/2] sched: dynamically adapt granularity with
 nr_running
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Lindgren <tony@atomide.com>,
        Mike Galbraith <efault@gmx.de>
In-Reply-To: <1284282392.2251.81.camel@laptop>
References: <20100911173732.551632040@efficios.com>
	 <20100911174003.051303123@efficios.com> <1284231470.2251.52.camel@laptop>
	 <AANLkTin0LOuTOcJPiZcZGeZMdqsy2dohyrREw2GGhddJ@mail.gmail.com>
	 <1284237380.2251.56.camel@laptop>
	 <AANLkTi=a91QX-FLURFWNsjbCS1bDLr6GqSpC4_uzm3ta@mail.gmail.com>
	 <1284282392.2251.81.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sun, 12 Sep 2010 11:14:27 +0200
Message-ID: <1284282867.2251.84.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-09-12 at 11:06 +0200, Peter Zijlstra wrote:
>  * is slice length, + is period length
> 
> Patch (sched_latency = 10, sched_min_gran = 10/3)
> 
> 
> 30 |                             +
>    |
>    |
>    |                          +
>    |
>    |
>    |
>    |
>    |
>    |
> 20 |
>    |
>    |
>    |
>    |
>    |
>    |
>    |
>    |
>    |
> 10 |  *  +  +  +  +  +  +  +
>    |
>    |
>    |
>    |
>    |     *
>    |
>    |        *  *              *  *  *  *  *  *
>    |              *  *
>    |                    *  *
> 0  +---------------------------------------------------------
>    0  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 


Vertical is time , horz is nr_running.


Note how things fall of a cliff when nr_running goes from 8 to 9. Andrew
usually kicks people in the teeth for phase change behaviour.

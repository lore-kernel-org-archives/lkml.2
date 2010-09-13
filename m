Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754544Ab0IMNwv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 09:52:51 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:63216 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751708Ab0IMNwu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 09:52:50 -0400
X-Authority-Analysis: v=1.1 cv=0gh5jMB3jHrmQHbUKMg9KP0ZqNkm6dXs7xuA8CfKDuU= c=1 sm=0 a=mn088iM2194A:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=f3ZB-OGGoe1fgaZgd2IA:9 a=I0JWH3MYXVhGQgsPwShTcTiFjrMA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [RFC patch 1/2] sched: dynamically adapt granularity with
 nr_running
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Galbraith <efault@gmx.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Lindgren <tony@atomide.com>
In-Reply-To: <1284367295.2275.31.camel@laptop>
References: <20100911173732.551632040@efficios.com>
	 <20100911174003.051303123@efficios.com> <1284231470.2251.52.camel@laptop>
	 <AANLkTin0LOuTOcJPiZcZGeZMdqsy2dohyrREw2GGhddJ@mail.gmail.com>
	 <1284237380.2251.56.camel@laptop>
	 <AANLkTi=a91QX-FLURFWNsjbCS1bDLr6GqSpC4_uzm3ta@mail.gmail.com>
	 <1284282392.2251.81.camel@laptop>
	 <1284352547.7321.51.camel@marge.simson.net>
	 <1284367295.2275.31.camel@laptop>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 13 Sep 2010 09:52:47 -0400
Message-ID: <1284385967.17152.13.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-09-13 at 10:41 +0200, Peter Zijlstra wrote:

> Yeah, without it you can starve the already running task on massive
> forks.
> 
> Still, I'm not quite sure why people really care about fork() on time
> sensitive paths, its a very expensive thing to do, pre-fork() and wake
> when you need it, is what I would say.

Fork is used all over the place in Linux. Every shell script uses it to
execute commands. Bad fork behavior shows up in just doing a build of
the kernel.

-- Steve




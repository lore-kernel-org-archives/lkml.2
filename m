Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752105Ab1GBQL0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jul 2011 12:11:26 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:60848 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751504Ab1GBQLZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jul 2011 12:11:25 -0400
X-Authority-Analysis: v=1.1 cv=IOX921YOuPvYFce5aSLzPVIStpiCPR9M8R83dyHW74w= c=1 sm=0 a=PKUarE_T-c8A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=CHiZ6g6q5NVKZL7A0iQA:9 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [patch 03/11] blackfin/irqs: Do not trace arch_local_{*,irq_*}
 functions
From: Steven Rostedt <rostedt@goodmis.org>
To: Mike Frysinger <vapier@gentoo.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <CAMjpGUfHw-CO=ydCew5FqG0RLQOMk8+NpVjvBdV4Nv-tiDavqg@mail.gmail.com>
References: <20110702030435.308336775@goodmis.org>
	 <20110702033853.220897627@goodmis.org>
	 <CAMjpGUfHw-CO=ydCew5FqG0RLQOMk8+NpVjvBdV4Nv-tiDavqg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Sat, 02 Jul 2011 12:11:22 -0400
Message-ID: <1309623082.26417.163.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-07-02 at 02:50 -0400, Mike Frysinger wrote:
> On Fri, Jul 1, 2011 at 23:04, Steven Rostedt wrote:
> > Do not trace arch_local_save_flags(), arch_local_irq_*() and friends.
> > Although they are marked inline, gcc may still make a function out of
> > them and add it to the pool of functions that are traced by the function
> > tracer. This can cause undesirable results (kernel panic, triple faults,
> > etc).
> >
> > Add the notrace notation to prevent them from ever being traced.
> 
> what about putting the markings in include/asm-generic/irqflags.h ?
> then you wouldnt have to update every arch (or at least, not as much).

One of my patches do that, but it only helps superH, as that's the only
arch that uses that header and implements function tracing.

-- Steve



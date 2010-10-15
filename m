Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756599Ab0JORUT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 13:20:19 -0400
Received: from casper.infradead.org ([85.118.1.10]:60869 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756371Ab0JORUS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 13:20:18 -0400
Subject: Re: Proper kernel irq time accounting -v4
From: Peter Zijlstra <peterz@infradead.org>
To: Venkatesh Pallipadi <venki@google.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-kernel@vger.kernel.org, Paul Turner <pjt@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
In-Reply-To: <AANLkTinL=FEo9wAaUQ8p6ton+eQxLk1m2BEj-3sof3H+@mail.gmail.com>
References: <1286237003-12406-1-git-send-email-venki@google.com>
	 <1287155513.29097.1526.camel@twins> <1287156451.29097.1531.camel@twins>
	 <AANLkTinL=FEo9wAaUQ8p6ton+eQxLk1m2BEj-3sof3H+@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 15 Oct 2010 19:20:05 +0200
Message-ID: <1287163205.1998.103.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-10-15 at 10:13 -0700, Venkatesh Pallipadi wrote:
> On Fri, Oct 15, 2010 at 8:27 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Fri, 2010-10-15 at 17:11 +0200, Peter Zijlstra wrote:
> >> OK, I'll take this, but will frob 4 to simply add PF_KSOFTIRQD.
> >>
> >> We can do all additional changes, possibly including what Eric
> >> suggested, at a later stage as increments.
> >>
> >> Thanks!
> >
> > *kablam!*
> >
> > booting with noirqtime doesn't work either, same explosion.
> 
> This crash seems to be from patch 8/8 that changed irq_enter. Please
> drop it for now and I will rework that.
> I will also send the cleanup changes including one that Eric suggested
> as incremental patches.

There's also still the PF_flags rework patch from me:
  http://lkml.org/lkml/2010/9/20/170

Which I still need to rework based on comments from Linus/Andrew.

The idea is to take out all PF_flags of the "I'm a $FOO" thread into
their own field.



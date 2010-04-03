Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755753Ab0DCCk3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 22:40:29 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:56484 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755453Ab0DCCk0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 22:40:26 -0400
To: oleg@redhat.com, akpm@linux-foundation.org, alan@linux.intel.com,
       greg@kroah.com, torvalds@linux-foundation.org
Cc: catalin.marinas@arm.com, linux-kernel@vger.kernel.org, serue@us.ibm.com,
       ebiederm@xmission.com, sukadev@us.ibm.com, stable@kernel.org
Subject: Re: [PATCH 0/1] tty: release_one_tty() forgets to put pids
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <201003272121.ADE39095.JLFHOOMtSVOFQF@I-love.SAKURA.ne.jp>
	<tnxbpe5ygfy.fsf@e102109-lin.cambridge.arm.com>
	<20100331151719.8a92b302.akpm@linux-foundation.org>
	<20100402160447.GA19920@redhat.com>
In-Reply-To: <20100402160447.GA19920@redhat.com>
Message-Id: <201004031140.BBH39566.OFFJFVHMOtQOSL@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Sat, 3 Apr 2010 11:40:19 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov wrote:
> Add cc's.
> 
> On 03/31, Andrew Morton wrote:
> >
> > On Tue, 30 Mar 2010 16:31:13 +0100
> > Catalin Marinas <catalin.marinas@arm.com> wrote:
> >
> > > Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp> wrote:
> > > > I got below report with 2.6.33.1 .
> > > >
> > > > unreferenced object 0xde144600 (size 64):
> > > >   comm "init", pid 1, jiffies 4294678101 (age 291.508s)
> > >
> > > [... snip ...]
> > >
> > > I reported similar leaks last year -
> > > http://lkml.org/lkml/2009/7/8/422. There is some analysis in the thread
> > > above of the reference counting but I couldn't figure out where it goes
> > > wrong. It looks to me like there isn't any reference to a struct pid
> > > block but its reference count is 2.
> > >
> > > There is a bugzilla entry as well -
> > > https://bugzilla.kernel.org/show_bug.cgi?id=13868
> 
> OK. I do not undertand ttys, absolutely. This means the patch
> should not be applied without acks. And in fact I feel the patch
> probably fixes the symptom, not the problem. But the logic in
> disassociate_ctty() is beyond my understanding.
> 
> However, I think it is easy to explain the leak.
> 
> Catalin, Tetsuo, could you try this patch?
> 
I confirmed using 2.6.34-rc3 that this patch solved the leak.

Thank you.

> Oleg.

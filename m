Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933327Ab1ERPVL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 11:21:11 -0400
Received: from casper.infradead.org ([85.118.1.10]:44072 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933164Ab1ERPVK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 11:21:10 -0400
Subject: Re: [PATCH] sched: correct how RT task is picked
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Hillf Danton <dhillf@gmail.com>, Yong Zhang <yong.zhang0@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>
In-Reply-To: <1305731754.11267.3.camel@gandalf.stny.rr.com>
References: <BANLkTikkeR_yf1HGhgq7WEO-kEvDGkV_tw@mail.gmail.com>
	 <BANLkTim4n-WA_6nJpg4Nd99yuc3f+VWkcw@mail.gmail.com>
	 <BANLkTikOecxhb8pZfAd19FLrPAPY4zacDQ@mail.gmail.com>
	 <20110512120606.GA3639@zhy> <20110518013842.GD23940@home.goodmis.org>
	 <BANLkTikOW9t6F8jvTJ0uPvyYDy+mpXh-DA@mail.gmail.com>
	 <BANLkTikMdAG4HFmhiB9c3x97FH0N3PnpHA@mail.gmail.com>
	 <1305725044.26849.11.camel@gandalf.stny.rr.com>
	 <BANLkTinzsjTy6yA7N-ssy5beyJn5NQZX3w@mail.gmail.com>
	 <1305731754.11267.3.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 18 May 2011 17:20:47 +0200
Message-ID: <1305732047.2466.7176.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-05-18 at 11:15 -0400, Steven Rostedt wrote:
> On Wed, 2011-05-18 at 22:46 +0800, Hillf Danton wrote:
> 
> > For migration, it is the case that cpu != rq->cpu, and
> > if cpu is allowed by task's affinity, it is bug that task
> > could not goto cpu because of nr_cpus_allowed since
> > the nr_cpus_allowed is computed based on the cpus_allowed mask.
> 
> Right, that nr_cpus_allowed was to be a short cut, so we did not have to
> look at the cpu mask. But as that check came after, it was pointless.
> Perhaps that too was a relic with the cpu < 0 case.
> 
> Acked-by: Steven Rostedt <rostedt@goodmis.org>

Hillf could you send a final patch with a proper changelog and Steven's
ack? From what I can see the latest patch is burried somewhere in this
discussion thread and is without changelog.

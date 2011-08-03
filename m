Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754743Ab1HCOuE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 10:50:04 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:47345 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754579Ab1HCOt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 10:49:59 -0400
X-Authority-Analysis: v=1.1 cv=s3eDhkhcaTLnj7IEXy8aaXUiY7FbET0mf+/2Xe0elbc= c=1 sm=0 a=WrFlywIw7b8A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=meVymXHHAAAA:8 a=20KFwNOVAAAA:8 a=VnNF1IyMAAAA:8 a=pGLkceISAAAA:8 a=tj66yTKnx48MZCkJAVUA:9 a=XD4GoFI4B1dNwmhD_GEA:7 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=0kPLrQdw3YYA:10 a=jEp0ucaQiEUA:10 a=MSl-tDqOz04A:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH][GIT PULL] sched/cpupri: Remove the vec->lock
From: Steven Rostedt <rostedt@goodmis.org>
To: Hillf Danton <dhillf@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <mgalbraith@suse.de>,
        "Luis Claudio R." <lgoncalv@redhat.com>
In-Reply-To: <CAJd=RBDiU02XVwDeDwLZ-MNDq_Vn5ONYOFoQz1Fe4EAV9W=1fw@mail.gmail.com>
References: <1312317372.18583.101.camel@gandalf.stny.rr.com>
	 <CAJd=RBDiU02XVwDeDwLZ-MNDq_Vn5ONYOFoQz1Fe4EAV9W=1fw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 03 Aug 2011 10:49:56 -0400
Message-ID: <1312382996.18583.115.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-08-03 at 22:18 +0800, Hillf Danton wrote:
> On Wed, Aug 3, 2011 at 4:36 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> >    The migrate code does stress the RT tasks a bit. This shows that
> >    the loop did increase a little after the patch, but not by much.
> >    The vec code dropped dramatically. From 4.3us down to .42us.
> >    That's a 10x improvement!
> >
> >    Tested-by: Mike Galbraith <mgalbraith@suse.de>
> >    Tested-by: Luis Claudio R. Gonçalves <lgoncalv@redhat.com>
> >    Tested-by: Matthew Hank Sabins<msabins@linux.vnet.ibm.com>
> >    Reviewed-by: Gregory Haskins <gregory.haskins@gmail.com>
> >    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> >
> Acked-by: Hillf Danton <dhillf@gmail.com>

Hi Hillf,

Thanks for the ack. But I want to point out this change as something I
want you to see. Remember when I replied to you with your patches asking
about benchmarks and timings and other tests? This patch is a good
example of what I meant.

I made a change that looked obvious. But obvious is not good enough when
you are dealing with the Linux scheduler. Before posting it, I created a
timing patch to record the timings of the affected area for any work
load. I then passed this patch with the timing changes to various people
that reported issues with this part of the code. I also ran on my own
boxes.

The result was outstanding. That is, everyone that reported back to me
found improvements and no regressions. The improvements were not just in
the timing measurements that I included, but also with their own tests.

Now I'm comfortable with this change.

You sent several patches to me that modified the scheduler in non
trivial ways, with no benchmarks or tests attached. Before making any
changes to the scheduler, you need to have something that shows that
those changes improve things and do not cause regressions.

I sent these patches out over a month ago to get these results. I'm
putting this change in for v3.2, that way it can get even more testing
in linux-next to make sure we didn't miss anything.

This is what I want you to understand. That the scheduler is a core
aspect of Linux, and if we mess it up, it will affect everyone. We can't
take that lightly.

Thanks!

-- Steve




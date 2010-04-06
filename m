Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756188Ab0DFPaA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 11:30:00 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:50238 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755041Ab0DFP3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 11:29:54 -0400
Date: Tue, 6 Apr 2010 08:29:36 -0700
From: Matt Helsley <matthltc@us.ibm.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Matt Helsley <matthltc@us.ibm.com>, Roland McGrath <roland@redhat.com>,
       Oleg Nesterov <oleg@redhat.com>, Grzegorz Nosek <root@localdomain.pl>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: Testing lxc 0.6.5 in Fedora 13
Message-ID: <20100406152936.GD3345@count0.beaverton.ibm.com>
References: <20100321195044.GA23757@megiteam.pl>
 <20100323212834.GH20796@count0.beaverton.ibm.com>
 <20100325213356.GB20541@megiteam.pl>
 <20100326111131.GA8604@redhat.com>
 <20100326115357.GA3345@count0.beaverton.ibm.com>
 <20100326124522.GD17113@megiteam.pl>
 <20100326134709.GB15790@redhat.com>
 <20100406034443.8B40ED477@magilla.sf.frob.com>
 <20100406135345.GC3345@count0.beaverton.ibm.com>
 <m1vdc48vhy.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1vdc48vhy.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 06, 2010 at 08:13:13AM -0700, Eric W. Biederman wrote:
> Matt Helsley <matthltc@us.ibm.com> writes:
> 
> > On Mon, Apr 05, 2010 at 08:44:43PM -0700, Roland McGrath wrote:

<snip>

> >> None of this has much of anything to do with strace, of course.  As I've
> >> said, I don't see anything other than the PTRACE_GETEVENTMSG value for
> >> PTRACE_EVENT_{CLONE,FORK,VFORK} reports that is wrong in the kernel.  As
> >> Oleg said, strace doesn't use that at all.  (This is not the place to
> >> discuss the details of strace further.)
> >
> > Also, looking at proposed changes (utrace and Eric Biederman's setns())
> > storing a pid nr rather than a reference to a task struct or struct pid
> > probably won't be correct.
> 
> My setns work has demonstrated that even for entering a namespace we
> never ever need to change the struct pid of a task.  setns has no other
> bearing on this problem then to say there is no foreseeable reason to
> change the rules.
> 
> > In the case of Eric Biederman's setns(), if capable of changing pid namespace,
> > we could have:
> >
> > 	Traced				Tracer
> > 	fork()
> > 					... (an arbitrary amount of time passes)
> > 					setns()
> > 					ptrace(GETEVENTMSG)
> 
> Forget that.  The pid namespace was architected so that we can ptrace a process
> in another pid namespace.
> 
> > At which point returning a static pid number held in the message field
> > produces the wrong pid.
> 
> No.  A processes always sees pids from the context of it's original pid
> namespace.  All setns does is affect which pid namespace children will
> be native in.

OK, good. So we can resolve the tasks/struct pids within the tracehook
and be done with it. Thanks Eric!

Cheers,
	-Matt Helsley

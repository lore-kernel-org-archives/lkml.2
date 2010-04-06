Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754649Ab0DFOi7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 10:38:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39910 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752951Ab0DFOix (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 10:38:53 -0400
Date: Tue, 6 Apr 2010 16:36:35 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Matt Helsley <matthltc@us.ibm.com>
Cc: Roland McGrath <roland@redhat.com>, Grzegorz Nosek <root@localdomain.pl>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Biederman Eric Biederman <ebiederm@xmission.com>
Subject: Re: Testing lxc 0.6.5 in Fedora 13
Message-ID: <20100406143635.GA12315@redhat.com>
References: <20100321195044.GA23757@megiteam.pl> <20100323212834.GH20796@count0.beaverton.ibm.com> <20100325213356.GB20541@megiteam.pl> <20100326111131.GA8604@redhat.com> <20100326115357.GA3345@count0.beaverton.ibm.com> <20100326124522.GD17113@megiteam.pl> <20100326134709.GB15790@redhat.com> <20100406034443.8B40ED477@magilla.sf.frob.com> <20100406135345.GC3345@count0.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100406135345.GC3345@count0.beaverton.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/06, Matt Helsley wrote:
>
> On Mon, Apr 05, 2010 at 08:44:43PM -0700, Roland McGrath wrote:
>
> > tracehook_report_clone_complete() call is made when that task_struct is no
> > longer guaranteed to be valid.

Hmm. I missed this.

> Also, if utrace allows multiple tracers and they each
> exist in a different namespace then storing a pid nr isn't going to work.

Yes, but utrace is simple. ptrace_report_clone() does

	ctx->eventmsg = child->pid;

we should fix this line and that is all, afaics. Every tracer has a
separate "struct ptrace_context *ctx".

> So my hunch is, in the long run, we'll need to hold a reference there and
> drop it when the last tracer detaches

Without utrace only one tracer is possible.

So, I think we should either change do_fork() to get the right tracee_pid_nr,
or add get/put into do_fork() and change tracehooks as Roland suggested.

Oleg.


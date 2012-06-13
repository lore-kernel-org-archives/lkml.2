Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754364Ab2FMPoK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 11:44:10 -0400
Received: from fifo99.com ([67.223.236.141]:45004 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751899Ab2FMPoJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 11:44:09 -0400
Date: Wed, 13 Jun 2012 08:43:55 -0700
From: Daniel Walker <dwalker@fifo99.com>
To: Muthu Kumar <muthu.lkml@gmail.com>
Cc: Mandeep Baines <msb@google.com>, fweisbec@gmail.com, sshaiju@mvista.com,
        mingo@elte.hu, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: hung_task checking and sys_sync
Message-ID: <20120613154355.GA25882@fifo99.com>
References: <20120612220924.GA13376@fifo99.com> <20120612222912.GB16381@google.com> <20120612223422.GB13492@fifo99.com> <CACBanvo7DxYPWEtSAWV25Xq94vqJBugMAwbrEHz9DfSFTpSL_w@mail.gmail.com> <20120612225719.GA13605@fifo99.com> <CAFR8ueewu_bh52wYJgWG0BdY3c=5zDXmRZ=1a-T117qQg3ux0A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFR8ueewu_bh52wYJgWG0BdY3c=5zDXmRZ=1a-T117qQg3ux0A@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 12, 2012 at 06:03:20PM -0700, Muthu Kumar wrote:
> On Tue, Jun 12, 2012 at 3:57 PM, Daniel Walker <dwalker@fifo99.com> wrote:
> > On Tue, Jun 12, 2012 at 03:45:20PM -0700, Mandeep Baines wrote:
> >> On Tue, Jun 12, 2012 at 3:34 PM, Daniel Walker <dwalker@fifo99.com> wrote:
> >> > On Tue, Jun 12, 2012 at 03:29:12PM -0700, Mandeep Singh Baines wrote:
> >> >>
> >> >> But the time is not unbounded. You could mask the hung_task_detector for
> >> >> this case but then you lose the ability to catch bugs in this code path.
> >> >>
> >> >> The timeout is configurable via /proc/sys/kernel/hung_task_timeout_secs.
> >> >> Can you bump up the value at boot via sysctl.conf?
> >> >
> >> > Maybe, but I'm wondering if these types should just be stopped because Andrew
> >> > had complained about them already.
> >> >
> >>
> >> Fair enough. Actually, internally I had a patch where we'd use a task
> >> flag to disable and enable the hang check but the approach in the
> >> patch you pointed me to seems better.
> >
> > I'm not really in love with it actually.. It's not ifdef'd for one, but
> > it's also changing potentially good kernel behavior to avoid warnings.
> >
> I totally agree with you (but, not the ifdef part :). The mentioned
> change actually was masking a potential problem - see
> https://lkml.org/lkml/2012/6/6/483. If not for that change, we would
> have got hung task message for the case where blk_execute_req() would
> have stuck forever without the completion being called.


Not sure how the link you gave relates here.

The hang checker isn't always part of the kernel i.e. it's configurable.
So this fix doesn't always need to exist, which is what I mean by
ifdef'd ..

Daniel

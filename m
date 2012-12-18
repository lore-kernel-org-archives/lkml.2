Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755406Ab2LRVxz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 16:53:55 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:56216 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754569Ab2LRVxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 16:53:52 -0500
Date: Tue, 18 Dec 2012 16:53:16 -0500
From: Neil Horman <nhorman@tuxdriver.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Pavel Emelyanov <xemul@parallels.com>,
        Daniel Berrange <berrange@redhat.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: +
 core_pattern-set-core-helpers-root-and-namespace-to-crashing-process .patch
 added to -mm tree
Message-ID: <20121218215316.GA4329@neilslaptop.think-freely.org>
References: <20121217123428.GA1957@redhat.com>
 <20121217150559.GD25322@hmsreliant.think-freely.org>
 <20121217160408.GA20166@redhat.com>
 <20121217183925.GE25322@hmsreliant.think-freely.org>
 <20121218200604.GA28834@redhat.com>
 <20121218201900.GA10059@hmsreliant.think-freely.org>
 <874njj3x9d.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <874njj3x9d.fsf@xmission.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Score: -2.9 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 18, 2012 at 12:45:18PM -0800, Eric W. Biederman wrote:
> Neil Horman <nhorman@tuxdriver.com> writes:
> 
> > On Tue, Dec 18, 2012 at 09:06:04PM +0100, Oleg Nesterov wrote:
> >> On 12/17, Neil Horman wrote:
> >> >
> >> > On Mon, Dec 17, 2012 at 05:04:08PM +0100, Oleg Nesterov wrote:
> >> > >
> >> > > > Is there a way to switch all namespaces, except for the pid
> >> > > > namespace?
> >> > >
> >> > > Which exactly namespaces you want to change?
> >> > >
> >> > Ideally, I want the pipe reader process to execute in the same namespaces that
> >> > the crashing process executed in (i.e. the pipe reader should execute as though
> >> > the crashing process forked it).
> >> 
> >> Yes, and we probably want to change pid_ns as well. But afaics currently
> >> this is not possible, even setns can't do this.
> 
> The code for setns to change the pid namespace just merged.
> 
Can you post a link to the merge commit for reference so I can take a look at
it?

> Oleg I copied you on that code when I put it up for review.  Did I use
> the wrong email address?
> 
> >> BTW. Of course this is subjective, but personally I think that "||"
> >> looks strange. Perhaps it would be better to add something like
> >> --croot argument?
> >> 
> > The || is ambiguous with its simmilarity to a shell 'or' command, but I don't
> > think the --croot argument is much better on that front, as that then becomes
> > ambiguous with arguments supplied to the pipe reader directly.  The token should
> > be leading the pipe_reader string in core_pattern to indicate a change in
> > environment independent of the executable path.  Perhaps |^ or something
> > simmilar?
> 
> I failed to send my earlier reply but there is another problem with the
> approach of only having one global core dump pattern.  You can't set it
> per container.  Which means a special character to switch namespeces
> while a reasonable solution (and arguably unnecessary solution) is not a
> complete solution.
> 
> > Either way, Andrew, could you please drop this patch?  Olegs comments I think
> > make it pretty clear I've got some more work to do on this.
> 
> If we just want one pattern we should be able to to robustly implement
> this in userspace with the existing functionality.  With the caveat that
> we need to get some pid namespace and user namespace bugs in the core
> pattern generation fixed.  But we need to fix those bugs anyway.
> 
Then perhaps the right thing to do here is in fact just make core_pattern a
per-namespace sysctl.  I only took a brief look, but I was unable to find an
example of such a per-namespace systctl.  Do we already have the infrastructure
to do such a thing?  I didn't think we did.

Thanks!
Neil

> Eric
> 

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752527Ab1ASSU5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 13:20:57 -0500
Received: from mail.openrapids.net ([64.15.138.104]:40194 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751904Ab1ASSUz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 13:20:55 -0500
Date: Wed, 19 Jan 2011 13:20:53 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: David Miller <davem@davemloft.net>, richm@oldelvet.org.uk,
        609371@bugs.debian.org, ben@decadent.org.uk,
        sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, mingo@redhat.com
Subject: Re: Bug#609371: linux-image-2.6.37-trunk-sparc64: module scsi_mod:
	Unknown relocation: 36
Message-ID: <20110119182052.GB18970@Krystal>
References: <1295382144.12215.123.camel@gandalf.stny.rr.com> <20110119050844.GA8776@Krystal> <20110118.223247.241909079.davem@davemloft.net> <20110118.232045.58440904.davem@davemloft.net> <1295451961.12215.1291.camel@gandalf.stny.rr.com> <20110119161534.GB15031@Krystal> <1295460822.12215.1389.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1295460822.12215.1389.camel@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 13:15:54 up 56 days, 23:18,  4 users,  load average: 0.02, 0.02,
	0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> On Wed, 2011-01-19 at 11:15 -0500, Mathieu Desnoyers wrote:
> > * Steven Rostedt (rostedt@goodmis.org) wrote:
> > > After applying David's "remove align" patch, I got it to boot on x86_64
> > > with the following two patches. I thought just adding the "align" to the
> > > structure declaration would work, but it still failed on the syscall for
> > > init_module. By removing the double "declaration" of event_exit_##sname,
> > > removed this problem.
> > > 
> > > I'll test this on x86 32bit and PPC 64. If it works there, I'll push all
> > > of them out for 38. Should these go to 37 stable too?
> > 
> > Please hold before adding these patches into git. They don't seem to address the
> > underlying problem correctly. See the latest exchanges between David Miller and
> > myself for more info.
> > 
> > We need to come up with something better than "it boots" as an explanation for
> > the fix.
> 
> Yes, I agree that we should solve this issue correctly. But if there is
> a work around to the problem, we could implement that if the real
> solution is not in our grasp yet.

A known working workaround (used in tracepoints for a few years) is to align the
type declaration on 32 bytes. It wastes space, but works. With this solution,
you should remove all the per-variable alignment attributes.

Now what I'm discussing with David Miller is if creating a

  __long_packed_aligned

and using it for *both* type and variable alignment would be more palatable (it
also works, and is more compact).

David proposed a solution with an array of pointers (extra indirection) which I
don't really like for 3 reasons I exposed in my reply to him.

So it's not that the solution is not in our grasp yet, it's more that we have to
choose the right one.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com

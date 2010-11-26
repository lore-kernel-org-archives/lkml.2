Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752886Ab0KZC4P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 21:56:15 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:56131 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751401Ab0KZC4O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 21:56:14 -0500
Date: Fri, 26 Nov 2010 08:26:05 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Peter Zijlstra <peterz@infradead.org>, eranian@google.com,
        linux-kernel@vger.kernel.org, mingo@elte.hu, paulus@samba.org,
        davem@davemloft.net, fweisbec@gmail.com, perfmon2-devel@lists.sf.net,
        eranian@gmail.com, robert.richter@amd.com, acme@redhat.com,
        Paul Menage <menage@google.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH 1/2] perf_events: add support for per-cpu per-cgroup
 monitoring (v5)
Message-ID: <20101126025605.GF3298@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <4ce510d4.0fedd80a.742c.10b9@mx.google.com>
 <1290684523.2145.31.camel@laptop>
 <4CEF1260.4000009@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <4CEF1260.4000009@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* lizf@cn.fujitsu.com <lizf@cn.fujitsu.com> [2010-11-26 09:50:24]:

> 19:28, Peter Zijlstra wrote:
> > On Thu, 2010-11-18 at 12:40 +0200, Stephane Eranian wrote:
> >> This kernel patch adds the ability to filter monitoring based on
> >> container groups (cgroups). This is for use in per-cpu mode only.
> >>     
> >> The cgroup to monitor is passed as a file descriptor in the pid
> >> argument to the syscall. The file descriptor must be opened to 
> >> the cgroup name in the cgroup filesystem. For instance, if the
> >> cgroup name is foo and cgroupfs is mounted in /cgroup, then the
> >> file descriptor is opened to /cgroup/foo. Cgroup mode is
> >> activated by passing PERF_FLAG_PID_CGROUP in the flags argument
> >> to the syscall.
> >>
> >> For instance to measure in cgroup foo on CPU1 assuming
> >> cgroupfs is mounted under /cgroup:
> >>
> >> struct perf_event_attr attr;
> >> int cgroup_fd, fd;
> >>
> >> cgroup_fd = open("/cgroup/foo", O_RDONLY);
> >> fd = perf_event_open(&attr, cgroup_fd, 1, -1, PERF_FLAG_PID_CGROUP);
> >> close(cgroup_fd);
> >>
> >> Signed-off-by: Stephane Eranian <eranian@google.com> 
> > 
> > Could you please split this patch:
> >   - pure code movement
> >   - time accounting changes
> >   - event_filter_match() stuff
> >   - cgroup thing
> > 
> > From a quick reading it doesn't look bad, but I want an ACK from the
> > cgroup people -- specifically if they're OK with the filedesc juggling
> > thing, because I know the sysfs people objected to such tricks.
> > 
> 
> Long long ago, a feature that used this trick was accepted, and that's
> cgroup taskstat.
> 
> You get an fd of a cgroup directory and send it to the kernel via netlink,
> and then you'll receive some statistics, such as how many tasks are
> running/interrupted in that cgroup.
>

That is right, since cgroups don't have id's there is no easy way to
identify them, looking them up by name and passing strings seemed an
overkill. 

-- 
	Three Cheers,
	Balbir

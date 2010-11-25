Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752610Ab0KYL2w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 06:28:52 -0500
Received: from casper.infradead.org ([85.118.1.10]:47424 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752427Ab0KYL2v convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 06:28:51 -0500
Subject: Re: [PATCH 1/2] perf_events: add support for per-cpu per-cgroup
 monitoring (v5)
From: Peter Zijlstra <peterz@infradead.org>
To: eranian@google.com
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, paulus@samba.org,
        davem@davemloft.net, fweisbec@gmail.com, perfmon2-devel@lists.sf.net,
        eranian@gmail.com, robert.richter@amd.com, acme@redhat.com,
        lizf@cn.fujitsu.com, Paul Menage <menage@google.com>,
        Balbir Singh <balbir@in.ibm.com>, Greg Kroah-Hartman <gregkh@suse.de>
In-Reply-To: <4ce510d4.0fedd80a.742c.10b9@mx.google.com>
References: <4ce510d4.0fedd80a.742c.10b9@mx.google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 25 Nov 2010 12:28:43 +0100
Message-ID: <1290684523.2145.31.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-11-18 at 12:40 +0200, Stephane Eranian wrote:
> This kernel patch adds the ability to filter monitoring based on
> container groups (cgroups). This is for use in per-cpu mode only.
>     
> The cgroup to monitor is passed as a file descriptor in the pid
> argument to the syscall. The file descriptor must be opened to 
> the cgroup name in the cgroup filesystem. For instance, if the
> cgroup name is foo and cgroupfs is mounted in /cgroup, then the
> file descriptor is opened to /cgroup/foo. Cgroup mode is
> activated by passing PERF_FLAG_PID_CGROUP in the flags argument
> to the syscall.
> 
> For instance to measure in cgroup foo on CPU1 assuming
> cgroupfs is mounted under /cgroup:
> 
> struct perf_event_attr attr;
> int cgroup_fd, fd;
> 
> cgroup_fd = open("/cgroup/foo", O_RDONLY);
> fd = perf_event_open(&attr, cgroup_fd, 1, -1, PERF_FLAG_PID_CGROUP);
> close(cgroup_fd);
> 
> Signed-off-by: Stephane Eranian <eranian@google.com> 

Could you please split this patch:
  - pure code movement
  - time accounting changes
  - event_filter_match() stuff
  - cgroup thing

>From a quick reading it doesn't look bad, but I want an ACK from the
cgroup people -- specifically if they're OK with the filedesc juggling
thing, because I know the sysfs people objected to such tricks.

Also, it might make sense to add a CONFIG_PERF_CGROUP, even if you want
it automagically set if CONFIG_PERF && CONFIG_CGROUP, its easier to find
all related code if its under a single CONFIG_var.



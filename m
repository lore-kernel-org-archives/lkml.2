Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755457Ab1GFAnR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 20:43:17 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:59370 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752516Ab1GFAnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 20:43:15 -0400
Date: Wed, 6 Jul 2011 02:43:12 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Aditya Kali <adityakali@google.com>
Cc: linux-kernel@vger.kernel.org, Paul Menage <menage@google.com>,
        Li Zefan <lizf@cn.fujitsu.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC PATCH 4/4] cgroups: Add an rlimit subsystem
Message-ID: <20110706004309.GB10010@somewhere.redhat.com>
References: <1308527474-20704-1-git-send-email-fweisbec@gmail.com>
 <1308527474-20704-5-git-send-email-fweisbec@gmail.com>
 <loom.20110628T194004-818@post.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <loom.20110628T194004-818@post.gmane.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(restore cc list, and for real this time)

On Tue, Jun 28, 2011 at 06:08:42PM +0000, Aditya Kali wrote:
> Frederic Weisbecker <fweisbec <at> gmail.com
 
> writes:
> > +struct rlim {
> > +   struct res_counter              proc_counter;
> > +   struct cgroup_subsys_state      css;
> > +};
> This can be used to enforce limits on FDs (RLIMIT_NOFILE), TCP/UDP ports,
> locked memory, queued data on sockets, etc. How making proc_counter an
> array (currently of size 1) ? Though with this patch there is just one, but it
> will great to have ready support for easily adding more.

Yeah but Paul suggested that we don't have an all-in-one limit subsystem
but rather we group things under the same topic. If we group proc counter
and file counter under the same subsystem, we won't be able to build two
distinct hierarchies: one to deal with nr_proc and one for nr_file, and
group tasks differently inside each.

We need a higher granularity than that. And having a single nr_task susbsytem
seem to make sense as nothing else appear to be suitable to be in the same
subsystem.


>
> > +static struct cftype cft_max_proc = {
> > +   .name           = "max_proc",
> > +   .read_u64       = max_proc_read_u64,
> > +   .write_u64      = max_proc_write_u64,
> > +};
> How about exporting USAGE, MAX_USAGE and FAILCNT too? These are useful
> for resource estimation.

Usage makes sense. But do we really need the rest? May be should we wait for people
to request these?

Thanks.

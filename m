Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934163Ab3AIUmg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 15:42:36 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:34986 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933894Ab3AIUmV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 15:42:21 -0500
Date: Wed, 9 Jan 2013 12:42:20 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Glauber Costa <glommer@parallels.com>
Cc: <cgroups@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Turner <pjt@google.com>
Subject: Re: [PATCH v5 11/11] sched: introduce cgroup file stat_percpu
Message-Id: <20130109124220.ad9f1a54.akpm@linux-foundation.org>
In-Reply-To: <1357731938-8417-12-git-send-email-glommer@parallels.com>
References: <1357731938-8417-1-git-send-email-glommer@parallels.com>
	<1357731938-8417-12-git-send-email-glommer@parallels.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  9 Jan 2013 15:45:38 +0400
Glauber Costa <glommer@parallels.com> wrote:

> The file cpu.stat_percpu will show various scheduler related
> information, that are usually available to the top level through other
> files.
> 
> For instance, most of the meaningful data in /proc/stat is presented
> here. Given this file, a container can easily construct a local copy of
> /proc/stat for internal consumption.
> 
> The data we export is comprised of:
> * all the tick information, previously available only through cpuacct,
>   like user time, system time, etc.
> 
> * wait time, which can be used to construct analogous information to
>   steal time in hypervisors,
> 
> * nr_switches and nr_running, which are cgroup-local versions of
>   their global counterparts.
> 
> The file includes a header, so fields can come and go if needed.

Please update this changelog to fully describe the proposed userspace
interfaces.  That means full pathnames and example output. 
Understanding these interfaces is the most important part of reviewing
this patchset, so this info should be prominent.

Also, this patchset appears to alter (or remove?) existing userspace
interfaces?  If so, please clearly describe those alterations and also
share your thinking on the back-compatibility issues.

Also, I'm not seeing any changes to Docmentation/ in this patchset. 
How do we explain the interface to our users?


>From a quick read, it appears that the output will be something along
the lines of:

user nice system irq softirq guest guest_nice wait nr_switches nr_running
cpu0 nn nn nn nn nn ...
cpu1 nn nn nn nn nn ...

which looks pretty terrible.  Apart from being very hard to read, it
means that we can never remove fields.  A nicer and more extensible
interface would be

cpu:0 nice:nn system:nn irq:nn ...




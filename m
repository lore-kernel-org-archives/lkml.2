Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933129Ab2GYN5y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 09:57:54 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:51601 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933048Ab2GYN5w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 09:57:52 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19S6ylFoCxSOxnQdYNVH9tlkiksAEYz5J/Ewzoefi
	QRIZr4TRD7E/zt
Message-ID: <1343224667.5745.67.camel@marge.simpson.net>
Subject: Re: Attaching a process to cgroups
From: Mike Galbraith <efault@gmx.de>
To: Alexey Vlasov <renton@renton.name>
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com
Date: Wed, 25 Jul 2012 15:57:47 +0200
In-Reply-To: <20120725133637.GA9169@beaver>
References: <20120619185856.GC31797@beaver>
	 <1340195298.15707.3.camel@marge.simpson.net> <20120725133637.GA9169@beaver>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-07-25 at 17:36 +0400, Alexey Vlasov wrote: 
> Hi.
> 
> Now I've got almost 5k used groups and it got even worse. Now I've got
> almost 5k used groups and it got even worse.
> 
> If only write was working slower, now everything connected with cgroups
> is hardly working.
> 
> Could it be connected with synchronize_rcu()?

I'd profile it with perf, and expect to find a large pile of cycles.

> Hanging on read():
> 
> # strace -ttT cat /proc/cgroups 
> 
> 17:30:43.825005 fstat(1, {st_mode=S_IFCHR|0620, st_rdev=makedev(136, 13), ...}) = 0 <0.000005>
> 17:30:43.825048 open("/proc/cgroups", O_RDONLY) = 3 <0.000014>
> 17:30:43.825085 fstat(3, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0 <0.000004>
> 17:30:43.825125 fadvise64(3, 0, 0, POSIX_FADV_SEQUENTIAL) = 0 <0.000005>
> 17:30:43.825161 read(3, "#subsys_name\thierarchy\tnum_cgrou"..., 32768) = 112 <7.447084>

Ew.. zillion cgroups is definitely a bad idea.

-Mike


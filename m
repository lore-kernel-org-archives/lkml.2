Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758910Ab2HHQvk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 12:51:40 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:60365 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751996Ab2HHQvi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 12:51:38 -0400
Date: Wed, 8 Aug 2012 09:51:29 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Alexey Vlasov <renton@renton.name>
Cc: Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org
Subject: Re: Attaching a process to cgroups
Message-ID: <20120808165129.GG2403@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120619185856.GC31797@beaver>
 <1340195298.15707.3.camel@marge.simpson.net>
 <20120725133637.GA9169@beaver>
 <1343224667.5745.67.camel@marge.simpson.net>
 <20120808164033.GB13735@beaver>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120808164033.GB13735@beaver>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12080816-9360-0000-0000-00000939A4C3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 08, 2012 at 08:40:33PM +0400, Alexey Vlasov wrote:
> On Wed, Jul 25, 2012 at 03:57:47PM +0200, Mike Galbraith wrote:
> > > Hanging on read():
> > > 
> > > # strace -ttT cat /proc/cgroups 
> > > 
> > > 17:30:43.825005 fstat(1, {st_mode=S_IFCHR|0620, st_rdev=makedev(136, 13), ...}) = 0 <0.000005>
> > > 17:30:43.825048 open("/proc/cgroups", O_RDONLY) = 3 <0.000014>
> > > 17:30:43.825085 fstat(3, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0 <0.000004>
> > > 17:30:43.825125 fadvise64(3, 0, 0, POSIX_FADV_SEQUENTIAL) = 0 <0.000005>
> > > 17:30:43.825161 read(3, "#subsys_name\thierarchy\tnum_cgrou"..., 32768) = 112 <7.447084>
> 
> In general I've changed it to synchronize_rcu_expedited () and all the
> delays have gone both on writing and reading files from cgroups.

Is the writing and reading from cgroups something that your workload
does all the time, or is it something that happens only on occasional
updates to your cgroup configuration?

							Thanx, Paul


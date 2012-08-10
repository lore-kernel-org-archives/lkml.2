Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759456Ab2HJJ4I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 05:56:08 -0400
Received: from mail.renton.name ([90.155.165.44]:43890 "EHLO
	beaver.old-horrors.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759304Ab2HJJzn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 05:55:43 -0400
Date: Fri, 10 Aug 2012 13:53:51 +0400
From: Alexey Vlasov <renton@renton.name>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org
Subject: Re: Attaching a process to cgroups
Message-ID: <20120810095351.GA16494@beaver>
References: <20120619185856.GC31797@beaver>
 <1340195298.15707.3.camel@marge.simpson.net>
 <20120725133637.GA9169@beaver>
 <1343224667.5745.67.camel@marge.simpson.net>
 <20120808164033.GB13735@beaver>
 <20120808165129.GG2403@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120808165129.GG2403@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 08, 2012 at 09:51:29AM -0700, Paul E. McKenney wrote:
> On Wed, Aug 08, 2012 at 08:40:33PM +0400, Alexey Vlasov wrote:
> > 
> > In general I've changed it to synchronize_rcu_expedited () and all the
> > delays have gone both on writing and reading files from cgroups.
> 
> Is the writing and reading from cgroups something that your workload
> does all the time, or is it something that happens only on occasional
> updates to your cgroup configuration?

There always were some delay on writing. It reproduces easily, you have
to create some 1000 groups (may be it can be enough to create 1 group, I
didn't check it actually) and write pid to a task file of the group. I
described it in my first message.

Delays on reading appeared when there began an active rotation of
proccesses in task files and may be by renewing of counters
(cpuacct.stat, memory.stat) due to the cgroups hierarchy. LA has grown
from 10 to 500 and all the programms that read cgroups files in /proc
(htop for example) practically stopped working.

-- 
BRGDS. Alexey Vlasov.

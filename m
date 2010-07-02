Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758690Ab0GBOMh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 10:12:37 -0400
Received: from leopard.mail.utk.edu ([160.36.0.85]:39000 "EHLO
	leopard.mail.utk.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757230Ab0GBOMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 10:12:35 -0400
X-Greylist: delayed 918 seconds by postgrey-1.27 at vger.kernel.org; Fri, 02 Jul 2010 10:12:35 EDT
Date: Fri, 2 Jul 2010 09:56:22 -0400 (EDT)
From: Vince Weaver <vweaver1@eecs.utk.edu>
To: Peter Zijlstra <peterz@infradead.org>
cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH] perf wrong branches event on AMD
In-Reply-To: <1278070727.1917.253.camel@laptop>
Message-ID: <alpine.DEB.2.00.1007020950420.29784@cl320.eecs.utk.edu>
References: <alpine.DEB.2.00.1007011526010.23160@cl320.eecs.utk.edu> <1278070727.1917.253.camel@laptop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Jul 2010, Peter Zijlstra wrote:

> On Thu, 2010-07-01 at 15:30 -0400, Vince Weaver wrote:
> > This is why event selection needs to be in user-space... it could be fixed 
> > instantly there, but the way things are done now it will take months to 
> > years for this fix to filter down to those trying to use perf counters...
> 
> Last time I checked apt-get upgrade/yum upgrade simply upgraded
> everything, including kernels.. (and upgrades to userspace packages can
> take months too)

The system I have this problem on is a large server used by many people, 
and has some fiddly hardware.  The admins don't take kernel upgrades 
lightly.

User-space libraries can be installed in my home directory, by me, with 
no changes to anyone else using the system.

> If you don't want to reboot, there's the -r option Arnaldo already
> mentioned. There's also the option of writing a kernel module to poke at
> the data table if you really really want to update a running kernel.

You think I have root on this machine?

In any case, yes, there's the "-r" option.  Fun.  I get to modify all my 
scripts to have some complicated case... "if AMD machine and if kernel is 
new enough"... how new?  It gets confusing once things get backported to 
stable.  As far as I know there's no way to get a kernel to spit out what 
raw events it's using for the predefined events.

Plus, the branches:u result is giving a *wrong* event with wrong values, 
not just a 0 count which might be suspicious.

If the solution really is to use raw events in a case like this, I 
question why the predefined events are in the kernel at all.  Pretty much 
anyone using the braches event on an AMD machine is going to be getting 
wrong results for all kernels between 2.6.31 and 2.6.35 and not even know 
it unless they read the kernel list.

> If you think this is a really "important" feature you could even make a
> patch that exposes all these data tables to userspace through sysfs or
> whatever and see if people think its worth the effort.

such a library already exists, called libpfm4.  I use it when I can.

Unfortunately perf is widely used and comes with the kernel.

Vince

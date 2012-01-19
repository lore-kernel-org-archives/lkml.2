Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933068Ab2ASUwW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 15:52:22 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:46285 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933055Ab2ASUwR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 15:52:17 -0500
Date: Thu, 19 Jan 2012 15:52:16 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Ingo Molnar <mingo@elte.hu>
cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Kay Sievers <kay.sievers@vrfy.org>, "Luck, Tony" <tony.luck@intel.com>,
        Greg KH <gregkh@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Sergei Trofimovich <slyich@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        Borislav Petkov <bp@amd64.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "prasad@linux.vnet.ibm.com" <prasad@linux.vnet.ibm.com>,
        Ming Lei <tom.leiming@gmail.com>, Djalal Harouni <tixxdz@opendz.org>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Andi Kleen <ak@linux.intel.com>,
        "gouders@et.bocholt.fh-gelsenkirchen.de" 
	<gouders@et.bocholt.fh-gelsenkirchen.de>,
        Marcos Souza <marcos.mage@gmail.com>,
        "justinmattock@gmail.com" <justinmattock@gmail.com>,
        Jeff Chua <jeff.chua.linux@gmail.com>
Subject: Re: [PATCH] mce: fix warning messages about static struct mce_device
In-Reply-To: <20120119193820.GA28362@elte.hu>
Message-ID: <Pine.LNX.4.44L0.1201191548380.1447-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Jan 2012, Ingo Molnar wrote:

> 
> * Alan Stern <stern@rowland.harvard.edu> wrote:
> 
> > Or to put it another way, even though no code takes references 
> > to these device structures (can you really guarantee that even 
> > now?), [...]
> 
> That's a good question. Do these devices get exposed to 
> user-space access via sysfs somehow, where such an extra 
> reference could materialize?

_Every_ struct device that gets registered is exposed to userspace via
sysfs.  Of course, that doesn't mean the exposure can create extra
references.

> > [...] how do you prevent references being taken in future 
> > versions of the kernel?  Calling memset while there still are 
> > outstanding references very definitely _is_ a bug.
> 
> Unless there's a reference i missed the 'refcounting' here is 
> very simple and does not exist at all.
> 
> IMHO you should not impose complexity and abstraction on code 
> just because. Now i don't care much about the extra pointer, but 
> the [NR_CPUS] array was doubly ugly (and Greg promised to fix 
> that, so no problems from me).
> 
> So the conclusion is that the reasons stated here don't really 
> apply. The one i mentioned *does* apply: the original bug was 
> due to sloppy life time rules of this driver buffer, and that 
> came back to bite us. Making it dynamic solves that kind of 
> problem. In that sense the warning is fine too.

Then it looks like we are in agreement.  :-)

Alan Stern


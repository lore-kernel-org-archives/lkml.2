Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754919Ab1ATP7P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 10:59:15 -0500
Received: from cantor.suse.de ([195.135.220.2]:39771 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753826Ab1ATP7O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 10:59:14 -0500
Date: Thu, 20 Jan 2011 16:59:10 +0100
From: Matthias Hopf <mhopf@suse.de>
To: castet.matthieu@free.fr
Cc: Lin Ming <ming.m.lin@intel.com>, Oliver Neukum <oneukum@suse.de>,
        rjw@sisk.pl, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Denys Vlasenko <vda.linux@googlemail.com>,
        Michal Marek <mmarek@suse.cz>, Yinghai Lu <yinghai@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>, Borislav Petkov <bp@alien8.de>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Siarhei Liakh <sliakh.lkml@gmail.com>,
        Xuxian Jiang <jiang@cs.ncsu.edu>, Dave Airlie <airlied@redhat.com>,
        Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [REGRESSION] S3 resume on SandyBridge doesn't work with NX
 protection (5bd5a45)
Message-ID: <20110120155909.GA21782@suse.de>
Mail-Followup-To: castet.matthieu@free.fr,
	Lin Ming <ming.m.lin@intel.com>, Oliver Neukum <oneukum@suse.de>,
	rjw@sisk.pl, Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
	x86@kernel.org, Steven Rostedt <rostedt@goodmis.org>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	Rusty Russell <rusty@rustcorp.com.au>,
	Andrew Morton <akpm@linux-foundation.org>,
	FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
	Jesse Barnes <jbarnes@virtuousgeek.org>,
	Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
	Denys Vlasenko <vda.linux@googlemail.com>,
	Michal Marek <mmarek@suse.cz>, Yinghai Lu <yinghai@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Pekka Enberg <penberg@cs.helsinki.fi>,
	Borislav Petkov <bp@alien8.de>,
	Suresh Siddha <suresh.b.siddha@intel.com>,
	Siarhei Liakh <sliakh.lkml@gmail.com>,
	Xuxian Jiang <jiang@cs.ncsu.edu>, Dave Airlie <airlied@redhat.com>,
	Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
References: <20110119173710.GA1331@suse.de>
 <20110119230602.6dd34fa3@mat-laptop>
 <20110120134734.GA7230@suse.de>
 <1295535954.4d384f524c8f0@imp.free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1295535954.4d384f524c8f0@imp.free.fr>
Organization: SUSE LINUX Products GmbH, =?iso-8859-1?Q?G?=
	=?iso-8859-1?Q?F=3A_Markus_Rex=2C_HRB_16746_=28AG_N=FCrnberg=29?=
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 20, 11 16:05:54 +0100, castet.matthieu@free.fr wrote:
> > > > Git commit 5bd5a45 in Linus' tree "x86: Add NX protection for kernel
> > > > data" apparently breaks resume on SandyBridge machines. This is
> > > > supposed to be fixed with commit 691513f "x86: Resume trampoline must
> > > > be executable", but even git master (v2.6.38-rc1) shows the same
> > > > symptoms.
> > > Is it a 32bit or 64 bit kernel ?
> >
> > Sorry, forgot that. It's a 32bit kernel.
> Ok that explain why 691513f doesn't work
> >
> Does this sequence make the machine reboot ?
> 
> # echo 0 > /sys/devices/system/cpu/cpu1/online
> # echo 1 > /sys/devices/system/cpu/cpu1/online

Nope, it doesn't.

dmesg output:

[ 8172.670422] Unmapping cpu 1 from all nodes
[ 8172.671802] CPU 1 is now offline
[ 8176.572869] Booting Node 0 Processor 1 APIC 0x1
[ 8176.583474] Initializing CPU#1
[ 8176.583803] Mapping cpu 1 to node 0

Looks good to me.
I also tried disabling all but one CPUs (this is a quad core machine),
works as well.


Matthias

-- 
Matthias Hopf <mhopf@suse.de>      __        __   __
Maxfeldstr. 5 / 90409 Nuernberg   (_   | |  (_   |__          mat@mshopf.de
Phone +49-911-74053-715           __)  |_|  __)  |__  R & D   www.mshopf.de

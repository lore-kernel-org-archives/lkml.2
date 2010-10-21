Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757650Ab0JUTJL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 15:09:11 -0400
Received: from mga02.intel.com ([134.134.136.20]:3273 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757559Ab0JUTJJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 15:09:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.58,218,1286175600"; 
   d="scan'208";a="566224762"
Date: Thu, 21 Oct 2010 12:09:03 -0700 (Pacific Daylight Time)
From: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
To: Nikola Ciprich <extmaillist@linuxbox.cz>
cc: "Tantilov, Emil S" <emil.s.tantilov@intel.com>,
        linux-net maillist <linux-net@vger.kernel.org>,
        e1000-devel list <e1000-devel@lists.sourceforge.net>,
        "nikola.ciprich@linuxbox.cz" <nikola.ciprich@linuxbox.cz>,
        Linux kernel list <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org
Subject: Re: [E1000-devel] 2.6.36-rc7-git2 - panic/GPF: e1000e/vlans?
In-Reply-To: <20101021190208.GA7289@nik-comp.lan>
Message-ID: <alpine.WNT.2.00.1010211207220.5208@jbrandeb-desk1.amr.corp.intel.com>
References: <20101014052242.GA8998@pcnci.linuxbox.cz> <EA929A9653AAE14F841771FB1DE5A1366027CEFF1C@rrsmsx501.amr.corp.intel.com> <20101020144640.GA3009@pcnci.linuxbox.cz> <20101020163659.GB3009@pcnci.linuxbox.cz> <20101021190208.GA7289@nik-comp.lan>
User-Agent: Alpine 2.00 (WNT 1167 2008-08-23)
ReplyTo: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
X-X-Sender: amrjbrandeb@imapmail.glb.intel.com
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Adding netdev... beware the top post ordering in the thread.

On Thu, 21 Oct 2010, Nikola Ciprich wrote:

> Ok, here're the steps to reproduce the problem:
> 
> ip link set up dev eth0
> vconfig add eth0 10
> ip link set up dev eth0.10
> brctl addbr brtest
> # to bylo ok, sundá to až:
> brctl add brtest eth0.10
> 
> last command causes panic in few seconds..
> 
> Interesting thing is that it're reproducible only for eth0, not for
> eth1 (both are onboard 80003ES2LAN)
> 
> here's the lspci for those:
> 06:00.0 Ethernet controller: Intel Corporation 80003ES2LAN Gigabit Ethernet Controller (Copper) (rev 01)
> 	Subsystem: Super Micro Computer Inc Unknown device 0000
> 	Flags: bus master, fast devsel, latency 0, IRQ 65
> 	Memory at d8300000 (32-bit, non-prefetchable) [size=128K]
> 	I/O ports at 3000 [size=32]
> 	Capabilities: [c8] Power Management version 2
> 	Capabilities: [d0] Message Signalled Interrupts: 64bit+ Queue=0/0 Enable+
> 	Capabilities: [e0] Express Endpoint IRQ 0
> 	Capabilities: [100] Advanced Error Reporting
> 	Capabilities: [140] Device Serial Number 5a-19-34-ff-ff-48-30-00
> 
> 06:00.1 Ethernet controller: Intel Corporation 80003ES2LAN Gigabit Ethernet Controller (Copper) (rev 01)
> 	Subsystem: Super Micro Computer Inc Unknown device 0000
> 	Flags: bus master, fast devsel, latency 0, IRQ 66
> 	Memory at d8320000 (32-bit, non-prefetchable) [size=128K]
> 	I/O ports at 3020 [size=32]
> 	Capabilities: [c8] Power Management version 2
> 	Capabilities: [d0] Message Signalled Interrupts: 64bit+ Queue=0/0 Enable+
> 	Capabilities: [e0] Express Endpoint IRQ 0
> 	Capabilities: [100] Advanced Error Reporting
> 	Capabilities: [140] Device Serial Number 5a-19-34-ff-ff-48-30-00
> 
> last but not least, I've done bisect and it leads to:
> commit ae878ae280bea286ff2b1e1cb6e609dd8cb4501d
> Author: Maciej Żenczykowski <maze@google.com>
> Date:   Sun Oct 3 14:49:00 2010 -0700                                                                                                                                                                                                      net: Fix IPv6 PMTU disc. w/ asymmetric routes
> 
> doesn't seem to me to be related at all, but reverting really seems to fix the problem for me..
> I hope it helps..
> with best regards
> nik
> 
> 
> 
> On Wed, Oct 20, 2010 at 06:36:59PM +0200, Nikola Ciprich wrote:
> > so unfortunately I have to take back what I just wrote :(
> > the problem still persists, it just seems to be more random
> > so I'll try to separate the exact command that causes the panic..
> > n.
> > 
> > On Wed, Oct 20, 2010 at 04:46:40PM +0200, Nikola Ciprich wrote:
> > > Hello Emil,
> > > 
> > > I tried it now, I can still 100% reproduce with 2.6.36-rc7-git2, but
> > > with 2.6.36-rc8-git5 it works OK. So it certainly got fixed in the meantime!
> > > I'll therefore close the bug in BZ.
> > > 
> > > have a nice day!
> > > 
> > > best regards
> > > 
> > > nik
> > > 
> > > 
> > > On Fri, Oct 15, 2010 at 10:58:15AM -0600, Tantilov, Emil S wrote:
> > > > >-----Original Message-----
> > > > >From: Nikola Ciprich [mailto:extmaillist@linuxbox.cz]
> > > > >Sent: Wednesday, October 13, 2010 10:23 PM
> > > > >To: Linux kernel list; linux-net maillist; e1000-devel list
> > > > >Cc: nikola.ciprich@linuxbox.cz
> > > > >Subject: [E1000-devel] 2.6.36-rc7-git2 - panic/GPF: e1000e/vlans?
> > > > >
> > > > >Hi,
> > > > >when I try to boot 2.6.36-rc7-git2 on one of my machines, it crashes while
> > > > >setting up the network.
> > > > 
> > > > Thanks for letting us know!
> > > > 
> > > > >The setup is quite complex, with bonding, lots of vlans and 3 intel
> > > > >adapters (system is quad x86_64)
> > > > 
> > > > Could you provide more details about the exact setup and the sequence of 
> > > > commands that lead to the crash? If you can narrow it down to the actual 
> > > > command that caused the crash that would be very helpful.
> > > > 
> > > > Also - are you testing from Linus or net-next tree? If you are not using 
> > > > net-next, could you give it a try and see if you can reproduce it there?
> > > > 
> > > > >
> > > > >snip of lspci:
> > > > >06:00.0 Ethernet controller: Intel Corporation 80003ES2LAN Gigabit Ethernet
> > > > >Controller (Copper) (rev 01)
> > > > >06:00.1 Ethernet controller: Intel Corporation 80003ES2LAN Gigabit Ethernet
> > > > >Controller (Copper) (rev 01)
> > > > >09:00.0 Ethernet controller: Intel Corporation 82574L Gigabit Network
> > > > >Connection
> > > > 
> > > > Could you provide the output of lspci -vvv and a kernel config?

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751979Ab2KIJ31 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 04:29:27 -0500
Received: from mga03.intel.com ([143.182.124.21]:44051 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751834Ab2KIJ3X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 04:29:23 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,744,1344236400"; 
   d="scan'208";a="166306847"
Date: Fri, 9 Nov 2012 17:28:51 +0800
From: Feng Tang <feng.tang@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Greg KH <gregkh@linuxfoundation.org>, Azat Khuzhin <dohardgopro@gmail.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Zheng, Lv" <lv.zheng@intel.com>, Len Brown <lenb@kernel.org>,
        "Moore, Robert" <robert.moore@intel.com>
Subject: Re: ACPI errors with 3.7-rc3
Message-ID: <20121109092851.GA9179@feng-snb>
References: <20121031014527.GA2984@kroah.com>
 <CAAW1UO9BtAU5jpy=MqgFCwwXn3Gb8HA3m7FMktmQkYGqYrS0Rw@mail.gmail.com>
 <20121106124826.GA21806@kroah.com>
 <41011456.LYWJPCi9Xt@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <41011456.LYWJPCi9Xt@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 08, 2012 at 05:49:40AM +0800, Rafael J. Wysocki wrote:
> On Tuesday, November 06, 2012 01:48:26 PM Greg KH wrote:
> > On Tue, Nov 06, 2012 at 04:42:24PM +0400, Azat Khuzhin wrote:
> > > I'v also have such errors on my macbook pro.
> > > 
> > > $ dmesg | tail
> > > [17056.008564] ACPI Error: Method parse/execution failed
> > > [\_SB_.PCI0.LPCB.EC__.SMB0.SBRW] (Node ffff88026547ea10), AE_TIME
> > > (20120711/psparse-536)
> > > [17056.011194] ACPI Error: Method parse/execution failed
> > > [\_SB_.BAT0.UBST] (Node ffff88026547e678), AE_TIME
> > > (20120711/psparse-536)
> > > [17056.013793] ACPI Error: Method parse/execution failed
> > > [\_SB_.BAT0._BST] (Node ffff88026547e740), AE_TIME
> > > (20120711/psparse-536)
> > > [17056.016383] ACPI Exception: AE_TIME, Evaluating _BST (20120711/battery-464)
> > > [17056.511373] ACPI: EC: input buffer is not empty, aborting transaction
> > > [17056.512672] ACPI Exception: AE_TIME, Returned by Handler for
> > > [EmbeddedControl] (20120711/evregion-501)
> > > [17056.515256] ACPI Error: Method parse/execution failed
> > > [\_SB_.PCI0.LPCB.EC__.SMB0.SBRW] (Node ffff88026547ea10), AE_TIME
> > > (20120711/psparse-536)
> > > [17056.517886] ACPI Error: Method parse/execution failed
> > > [\_SB_.BAT0.UBST] (Node ffff88026547e678), AE_TIME
> > > (20120711/psparse-536)
> > > [17056.520479] ACPI Error: Method parse/execution failed
> > > [\_SB_.BAT0._BST] (Node ffff88026547e740), AE_TIME
> > > (20120711/psparse-536)
> > > [17056.523070] ACPI Exception: AE_TIME, Evaluating _BST (20120711/battery-464)
> > 
> > I'm seeing this again right now.  I'm wondering if it's because I'm
> > running on battery power at the moment:
> > 
> > [41694.309264] ACPI Exception: AE_TIME, Returned by Handler for [EmbeddedControl] (20120913/evregion-501)
> > [41694.309282] ACPI Error: Method parse/execution failed [\_SB_.PCI0.LPCB.EC__.SMB0.SBRW] (Node ffff88045cc64618), AE_TIME (20120913/psparse-536)
> > [41694.309300] ACPI Error: Method parse/execution failed [\_SB_.BAT0.UBST] (Node ffff88045cc64988), AE_TIME (20120913/psparse-536)
> > [41694.309310] ACPI Error: Method parse/execution failed [\_SB_.BAT0._BST] (Node ffff88045cc648c0), AE_TIME (20120913/psparse-536)
> > [41694.309324] ACPI Exception: AE_TIME, Evaluating _BST (20120913/battery-464)
> > [41694.809093] ACPI: EC: input buffer is not empty, aborting transaction
> > 
> > ec_storm_threshold is still set to 8 in /sys/module/acpi/parameters/ so that's
> > not the issue here.
> > 
> > > And also loadavg is too high ~ 10
> > > While there is no process that load CPU up to 100% or like that.
> > > I think that this because of processes that is done in kernel space.
> > > (basically that one who write such errors)
> > > 
> > > $ uname -a
> > > Linux macbook-pro-sq 3.6.5macbook-pro-custom-v0.1 #4 SMP Sun Nov 4
> > > 12:39:03 UTC 2012 x86_64 GNU/Linux
> > 
> > Ah, ok, that means it's not something new in 3.7-rc, so maybe it's just never
> > worked properly for this hardware :)
> > 
> > So it's not a regression, just an ACPI issue, any ACPI developer have an idea
> > about this?
> 
> Can you please send the output of acpidump from the affected machine(s)?

I doubt this problem is sometimes inevitable for some machines, because
AFAIK most modern machines have the race problem for EC HW controller, 
as both OS side and the BIOS may access the EC HW at the same time
without any race control.   

For this case, usually the battery and thermal modules (which may be
controlled through EC) are always monitored by BIOS, when OS also
frequently visit them too, the EC's own state machine may be broken
and not responsive due to the race, then cause the timeout error. 
And how severe the problem will be depends on the EC HW, the quality
of BIOS code and OS/driver code. 

Myself have seen the similar "ACPI: EC: input buffer is not empty,
aborting transaction" error message on one laptop when its EC is
busy visited by OS.

btw, in EC driver I see a "ec->global_lock", don't know if it was
designed to control the race between OS and BIOS.

Thanks,
Feng


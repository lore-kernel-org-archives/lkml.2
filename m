Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752571Ab2DBOFO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 10:05:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24739 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751490Ab2DBOFM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 10:05:12 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Sasha Levin <levinsasha928@gmail.com>,
        Nick Bowler <nbowler@elliptictech.com>, linux-kernel@vger.kernel.org,
        Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: the maxcpus= boot parameter broke somewhere along the line
References: <x49vcmhhj2f.fsf@segfault.boston.devel.redhat.com>
	<CA+1xoqe_xS95xKM2=X-Mq-_gc+DqzxF2D8YiuCf=0=7=mVKsyw@mail.gmail.com>
	<20120306164835.GA26094@elliptictech.com>
	<CA+1xoqfzCb5X8wwvR1Bz+D6K20n7v3ChUR0E4Jqw_BWam5C7TQ@mail.gmail.com>
	<x49mx7thabf.fsf@segfault.boston.devel.redhat.com>
	<4F578198.8060708@linux.vnet.ibm.com>
	<x49ipigustu.fsf@segfault.boston.devel.redhat.com>
	<4F59E802.6070301@linux.vnet.ibm.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Mon, 02 Apr 2012 10:05:06 -0400
In-Reply-To: <4F59E802.6070301@linux.vnet.ibm.com> (Srivatsa S. Bhat's message
	of "Fri, 09 Mar 2012 16:52:42 +0530")
Message-ID: <x49wr5ygrfx.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com> writes:

> Looking at the mention of udev above, and considering the commit you bisected
> to, I think it would be good to see whether someone is writing 1 to
> /sys/device/system/cpu/cpu*/online and hence the cpus are getting hot-added
> towards the end of boot. Maybe that sounds stupid, but worth a try :)
>
> So can you try the debug patch below? It applies on latest linux-3.3-rc6+

Sorry it took me so long to get back to you.  You're patch did, in fact,
trigger:

udev: starting version 147
CPU 3 online initated from userspace
SMP alternatives: switching to SMP code
WARNING! power/level is deprecated; use power/control instead
Booting Node 0 Processor 3 APIC 0x3
NMI watchdog: enabled, takes one hw-pmu counter.
CPU 1 online initated from userspace
Booting Node 0 Processor 1 APIC 0x2
NMI watchdog: enabled, takes one hw-pmu counter.
CPU 2 online initated from userspace
Booting Node 0 Processor 2 APIC 0x1
NMI watchdog: enabled, takes one hw-pmu counter.
CPU 1 online initated from userspace
CPU 3 online initated from userspace
CPU 2 online initated from userspace

Checking through udev rules, I found this in
/lib/udev/rules.d/40-redhat.rules (this is a RHEL 6 install, btw):

ACTION=="add", KERNEL=="cpu[0-9]*", RUN+="/bin/bash -c 'echo 1 > /sys/devices/system/cpu/%k/online'"

So, what do you suppose is the right way to fix this?

Cheers,
Jeff

Kay, you can read up on the rest of the thread here:
https://lkml.org/lkml/2012/3/6/242

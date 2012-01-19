Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753255Ab2ASMcv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 07:32:51 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:32913 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751075Ab2ASMcr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 07:32:47 -0500
Date: Thu, 19 Jan 2012 13:32:23 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Alan Stern <stern@rowland.harvard.edu>, "Luck, Tony" <tony.luck@intel.com>,
        Greg KH <gregkh@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
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
Message-ID: <20120119123223.GD3936@elte.hu>
References: <3908561D78D1C84285E8C5FCA982C28F01CF24@ORSMSX104.amr.corp.intel.com>
 <Pine.LNX.4.44L0.1201181257540.1343-100000@iolanthe.rowland.org>
 <CAPXgP10Du4nJ_hdfwqV0Fr6XEVkTMO6jZ_TS_T-J-grDG7nKJw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPXgP10Du4nJ_hdfwqV0Fr6XEVkTMO6jZ_TS_T-J-grDG7nKJw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Kay Sievers <kay.sievers@vrfy.org> wrote:

> > There's nothing special about the driver model code in this 
> > respect. The same restriction applies wherever object 
> > lifetimes are controlled by reference counting.
> 
> Right. But it might not be obvious what 's the background 
> here:
> 
> An allocated device object(memory) usually represents an 
> actual device(hardware). The object can have N users. Every of 
> the users is required to take a reference to the object, which 
> pins the object's memory as long as any of the N users might 
> need to access it.
> 
> In a hotplug world, we deal with device-removal.  On 
> disconnect, we usually just orphan the object, we remove it 
> from visibility, disconnect the device <-> object relation.
> 
> All of the N users with a reference can still access the 
> memory, they just do not talk to a real device anymore. The 
> invalidated/orphaned state is communicated otherwise by locks 
> and flags in the device object. Only after all of the N users 
> left the object alone, the memory of the orphan if free'd.

But this is not what happened here - it's a special piece of 
fundamental hardware that doesnt hot-plug separately from the 
CPU and that has just a single "user".

So i'm curious, why wasn't the memset() enough? It should have 
resolved the bug AFAICS.

Thanks,

	Ingo

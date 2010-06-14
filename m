Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755609Ab0FNUgP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 16:36:15 -0400
Received: from one.firstfloor.org ([213.235.205.2]:39459 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755377Ab0FNUgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 16:36:13 -0400
Date: Mon, 14 Jun 2010 22:36:11 +0200
From: Andi Kleen <andi@firstfloor.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andi Kleen <andi@firstfloor.org>, Nils Carlson <nils.carlson@ludd.ltu.se>,
       Ingo Molnar <mingo@elte.hu>, Borislav Petkov <bp@amd64.org>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       "Luck, Tony" <tony.luck@intel.com>,
       Mauro Carvalho Chehab <mchehab@redhat.com>,
       "Young, Brent" <brent.young@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "bluesmoke-devel@lists.sourceforge.net" 
	<bluesmoke-devel@lists.sourceforge.net>,
       Doug Thompson <dougthompson@xmission.com>,
       Joe Perches <joe@perches.com>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Edac Mailing List <linux-edac@vger.kernel.org>,
       Ingo Molnar <mingo@redhat.com>, Matt Domsch <Matt_Domsch@dell.com>
Subject: Re: Hardware Error Kernel Mini-Summit
Message-ID: <20100614203611.GE369@basil.fritz.box>
References: <987664A83D2D224EAE907B061CE93D53C61D1C57@orsmsx505.amr.corp.intel.com> <20100518191802.GG25224@aftab> <m1k4r0c0y7.fsf@fess.ebiederm.org> <20100518222832.GJ22675@basil.fritz.box> <m1wrv0zo9q.fsf@fess.ebiederm.org> <20100519064619.GA30320@aftab> <20100519070919.GA9618@elte.hu> <50689ECC-A371-4923-BEBE-1A5A7E5B9D3B@ludd.ltu.se> <20100614114906.GG17092@basil.fritz.box> <m14oh59y58.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m14oh59y58.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 14, 2010 at 01:06:59PM -0700, Eric W. Biederman wrote:

Hi Eric,

> - The current EDAC code displays which DIMMS you have plugged
>   in so you can tell if you unplug one, if it was the DIMM
>   you were aiming at.

Binary search for bad DIMMs. The way to handle memory errors in
the 21th century.

Obviously that does not really work, especially not on large
memory systems.

> > On a lot of modern systems I checked DMI
> > seems reasonably accurate in terms of layout, so I suspect they can 
> > be handled with this. For others probably
> > still need some special driver, but one 
> > with a proper interface.
> 
> DMI is great on the days it works, there is a lot of variations
> between BIOS's.  Also if the information is decent it can be
> used to inform the current EDAC code as well as anything else.

No DMI layout is unfortunately difficult to map to EDAC layout.
That's mostly EDAC's fault actually.

A sane EDAC replacement could be fed from DMI.

> You mean an interface that doesn't report the error so people
> won't complain to you about a near useless kernel error
> message.

DMI[1] does not report the errors, the errors are in machine checks
(or possibly other non architectural registers) 
DMI just gives you enumeration. It doesn't give everything,
but it's reasonably complete at least.


[1] except for the event log, but I'm not proposing to use that.
> 
> Setting the scrub rate isn't half so interesting as displaying
> it.

I still would like to understand the idea behind this varying 
at all. If you have any deeper thoughts on this please send them.

> 
> Having basic hardware information displayed in sysfs seems to be the
> design of the rest of linux.  I don't see abandoning that part of the
> EDAC design as wise.
> 
> Displaying the fact that ECC is turned on in the hardware is one
> of the more interesting bits.  That at least allows you to verify
> that things are working.

There are hundreds to thousands of BIOS level hardware knobs for memory
configuration (and if you count all BIOS knobs for everything far more) 

Why do you want to check a single bit only? (which is actually not
a single bit but also a lot of different ways to set this)

I can see there's a need to check that BIOS are doing the right
thing, but you'll never get that from a few sysfs fields.
You need a proper tool that is written for the system in question.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.

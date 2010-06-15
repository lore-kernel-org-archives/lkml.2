Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758242Ab0FOSkR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 14:40:17 -0400
Received: from mother.ludd.ltu.se ([130.240.16.3]:59130 "EHLO
	mother.ludd.ltu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754485Ab0FOSkP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 14:40:15 -0400
Cc: Andi Kleen <andi@firstfloor.org>, Doug Thompson <norsk5@yahoo.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>, Borislav Petkov <bp@amd64.org>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Mauro Carvalho Chehab <mchehab@redhat.com>,
       "Young, Brent" <brent.young@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "bluesmoke-devel@lists.sourceforge.net" 
	<bluesmoke-devel@lists.sourceforge.net>,
       Doug Thompson <dougthompson@xmission.com>,
       Joe Perches <joe@perches.com>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Edac Mailing List <linux-edac@vger.kernel.org>,
       Ingo Molnar <mingo@redhat.com>, Matt Domsch <Matt_Domsch@dell.com>,
       Nils Carlson <nils.carlson@ericsson.com>
Message-Id: <02B220A1-36C9-449C-ABB0-89A3DC7AEDF2@ludd.ltu.se>
From: Nils Carlson <nils.carlson@ludd.ltu.se>
To: "Luck, Tony" <tony.luck@intel.com>
In-Reply-To: <987664A83D2D224EAE907B061CE93D530143FDA773@orsmsx505.amr.corp.intel.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v936)
Subject: Re: Hardware Error Kernel Mini-Summit
Date: Tue, 15 Jun 2010 20:38:58 +0200
References: <AANLkTil_mDFOsDUjvnp_NFZvkj0Ij-qww6BqewJ4lpHP@mail.gmail.com> <35525.41387.qm@web50105.mail.re2.yahoo.com> <20100615065630.GC6727@basil.fritz.box> <Pine.GSO.4.58.1006150951150.17579@dexter.ludd.ltu.se> <20100615114135.GH6727@basil.fritz.box> <Pine.GSO.4.58.1006151411370.17929@dexter.ludd.ltu.se> <987664A83D2D224EAE907B061CE93D530143FDA773@orsmsx505.amr.corp.intel.com>
X-Mailer: Apple Mail (2.936)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 15, 2010, at 8:15 PM, Luck, Tony wrote:

>> Could we come up with some plan that doesn't involve
>> trusting to the goodwill (and competence) of BIOS writes?
>
> That would be nice - but there already exists a platform
> (Xeon-7500 series a.k.a. Nehalem-EX) where the hardware
> chipset registers that you would need to do your own
> memory topology reverse engineering in Linux are only
> accessible to SMM level code.  I've finally come to the
> conclusion that an EDAC style driver just isn't possible
> for this set of systems.
Yes, I'm dreading the day they come to me telling me that
they've got one of those. On the one end you have hardware
people who love to put functionality there, and then you
have applications that have real-time requirements to
whom you have to explain that the latest and greatest
processor is broken for their purposes.

One day I'll use this as an excuse to migrate everyone to
PPC where people know that a bootloader is a bootloader.

But grudges against BIOS's aside, I don't know what to do
about Nehalem-EX systems. I guess at that point we really
are at the mercy of BIOS writers.
>
>> I personally really like the device tree compiler for PowerPC.
>> It allows you to be explicit about what you have. Not for everyone,
>> but maybe there could be some way to apply the same principle? Maybe
>> some way of loading modules with parameters or configuring your setup
>> from sysfs?
>
> Even when the chip set registers are accessible, it can be very
> complex to do this for the general case (think of boards that
> support arbitrary mixing of different size/speed DIMMs - the
> BIOS may have done some interesting somersaults while computing
> which interleaving modes to use).
>
> Even more complex on high end systems when BIOS may handle row
> sparing transparently to the OS. Memory mirroring is also
> becoming fashionable - how can EDAC represent this (when
> the h/w view of the memory doesn't match the OS view)?
>
Difficult questions. But at some point I wonder who will be buying
systems where finding out which DIMM is broken is so complex
that it requires a masters degree.

/Nils

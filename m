Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757534Ab0FOSPe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 14:15:34 -0400
Received: from mga02.intel.com ([134.134.136.20]:5741 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754601Ab0FOSPd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 14:15:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,421,1272870000"; 
   d="scan'208";a="527158081"
From: "Luck, Tony" <tony.luck@intel.com>
To: Nils Carlson <nils.carlson@ludd.ltu.se>, Andi Kleen <andi@firstfloor.org>
CC: Doug Thompson <norsk5@yahoo.com>,
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
Date: Tue, 15 Jun 2010 11:15:31 -0700
Subject: RE: Hardware Error Kernel Mini-Summit
Thread-Topic: Hardware Error Kernel Mini-Summit
Thread-Index: AcsMhW8yPbRtdJcLSLm+dpMAB4cCKwAL5rUw
Message-ID: <987664A83D2D224EAE907B061CE93D530143FDA773@orsmsx505.amr.corp.intel.com>
References: <AANLkTil_mDFOsDUjvnp_NFZvkj0Ij-qww6BqewJ4lpHP@mail.gmail.com>
 <35525.41387.qm@web50105.mail.re2.yahoo.com>
 <20100615065630.GC6727@basil.fritz.box>
 <Pine.GSO.4.58.1006150951150.17579@dexter.ludd.ltu.se>
 <20100615114135.GH6727@basil.fritz.box>
 <Pine.GSO.4.58.1006151411370.17929@dexter.ludd.ltu.se>
In-Reply-To: <Pine.GSO.4.58.1006151411370.17929@dexter.ludd.ltu.se>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Could we come up with some plan that doesn't involve
> trusting to the goodwill (and competence) of BIOS writes?

That would be nice - but there already exists a platform
(Xeon-7500 series a.k.a. Nehalem-EX) where the hardware
chipset registers that you would need to do your own
memory topology reverse engineering in Linux are only
accessible to SMM level code.  I've finally come to the
conclusion that an EDAC style driver just isn't possible
for this set of systems.

>I personally really like the device tree compiler for PowerPC.
>It allows you to be explicit about what you have. Not for everyone,
>but maybe there could be some way to apply the same principle? Maybe
>some way of loading modules with parameters or configuring your setup
>from sysfs?

Even when the chip set registers are accessible, it can be very
complex to do this for the general case (think of boards that
support arbitrary mixing of different size/speed DIMMs - the
BIOS may have done some interesting somersaults while computing
which interleaving modes to use).

Even more complex on high end systems when BIOS may handle row
sparing transparently to the OS. Memory mirroring is also
becoming fashionable - how can EDAC represent this (when
the h/w view of the memory doesn't match the OS view)?

-Tony



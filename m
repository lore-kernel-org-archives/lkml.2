Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932323Ab0FOTf0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 15:35:26 -0400
Received: from one.firstfloor.org ([213.235.205.2]:38084 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754778Ab0FOTfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 15:35:25 -0400
Date: Tue, 15 Jun 2010 21:35:19 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Nils Carlson <nils.carlson@ludd.ltu.se>
Cc: Andi Kleen <andi@firstfloor.org>, Doug Thompson <norsk5@yahoo.com>,
       Tony Luck <tony.luck@intel.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>, Borislav Petkov <bp@amd64.org>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Mauro Carvalho Chehab <mchehab@redhat.com>,
       BrentYoung <brent.young@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "bluesmoke-devel@lists.sourceforge.net" 
	<bluesmoke-devel@lists.sourceforge.net>,
       Doug Thompson <dougthompson@xmission.com>,
       Joe Perches <joe@perches.com>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Edac Mailing List <linux-edac@vger.kernel.org>,
       Ingo Molnar <mingo@redhat.com>, Matt Domsch <Matt_Domsch@dell.com>,
       Nils Carlson <nils.carlson@ericsson.com>
Subject: Re: Hardware Error Kernel Mini-Summit
Message-ID: <20100615193519.GA12845@basil.fritz.box>
References: <AANLkTil_mDFOsDUjvnp_NFZvkj0Ij-qww6BqewJ4lpHP@mail.gmail.com> <35525.41387.qm@web50105.mail.re2.yahoo.com> <20100615065630.GC6727@basil.fritz.box> <Pine.GSO.4.58.1006150951150.17579@dexter.ludd.ltu.se> <20100615114135.GH6727@basil.fritz.box> <Pine.GSO.4.58.1006151411370.17929@dexter.ludd.ltu.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.GSO.4.58.1006151411370.17929@dexter.ludd.ltu.se>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> But there are bugs. And correcting them is so prohibitively
> expensive that I don't even want to think about it. And when

Something is wrong in your setup then.

> the BIOS messes up, it's the device driver writers who have to
> magically workaround the problems.

In this case you would need the equivalent information
of a system specific DMI table in some device driver.

Do you see how this does not fly? How should a device
driver know more about the system than the BIOS?

And if you can load some specific table into the device
driver why can't you simply update the BIOS too?

Well you can supply your own if you're a power user
anyways, but most users are not power users. So it's no 
option as a default.

Or could you imagine a standard server getting installed
and asking with a desktop window "please enter the DIMM mappings
by hand"? That simply doesn't make any sense.


> 
> Could we come up with some plan that doesn't involve
> trusting to the goodwill (and competence) of BIOS writes?

the problem is that the information is nowhere else.
If the BIOS doesn't know it Linux certainly doesn't know it either.

On the other hand if Linux uses this information there is certainly
an angle to get at least server vendors to fix their stuff
(and non servers do not matter for memory errors because they
run in non ECC mode anyways)

It's certainly in the server vendors own interest to supply correct
information here anyways. If they don't it will cost them in
unnecessary memory replacement costs.

BTW on the systems I have access to DMI seems to be largely 
correct these days. I guess your system is a unlucky exception.

Maybe your BIOS people will do something useful next generation.
Make sure to report it to them and if they don't fix it make fun of them.


> but maybe there could be some way to apply the same principle? Maybe
> some way of loading modules with parameters or configuring your setup
> from sysfs?

Having a DMI override is no problem at all. ACPI uses this all the time
for example.

No need at all to speak a foreign language for this, even if it's your
mother tongue.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.

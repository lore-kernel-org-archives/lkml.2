Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756553Ab0HCSfQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 14:35:16 -0400
Received: from xenotime.net ([72.52.115.56]:38421 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756279Ab0HCSfO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 14:35:14 -0400
Date: Tue, 3 Aug 2010 11:35:10 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Donald Parsons <dparsons@brightdsl.net>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
        Harald Hoyer <harald.hoyer@gmail.com>,
        Bjorn Helgaas <bjorn.helgaas@hp.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux 2.6.35
Message-Id: <20100803113510.9d031886.rdunlap@xenotime.net>
In-Reply-To: <1280857545.5209.61.camel@falcon.homelinux.org>
References: <1280716262.5125.42.camel@falcon.homelinux.org>
	<201008012138.39036.bjorn.helgaas@hp.com>
	<1280722876.5125.83.camel@falcon.homelinux.org>
	<AANLkTimK8sv5aWfcv_BAmipgVnukR5NJsZQOXYbb2LAH@mail.gmail.com>
	<1280802701.5836.10.camel@falcon.homelinux.org>
	<20100802214249.b0fee617.rdunlap@xenotime.net>
	<1280852810.5209.40.camel@falcon.homelinux.org>
	<20100803094031.2fb8e538.rdunlap@xenotime.net>
	<1280857545.5209.61.camel@falcon.homelinux.org>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 03 Aug 2010 13:45:45 -0400 Donald Parsons wrote:

> On Tue, 2010-08-03 at 09:40 -0700, Randy Dunlap wrote:
> > On Tue, 03 Aug 2010 12:26:50 -0400 Donald Parsons wrote:
> > 
> > > Resending to all...
> > > On Mon, 2010-08-02 at 21:42 -0700, Randy Dunlap wrote:
> > > > On Mon, 02 Aug 2010 22:31:41 -0400 Donald Parsons wrote:
> > > > 

[snip]

> > > > 
> > > > It would be good to be able to explain what you are seeing & describing,
> > > > so yes, if you can send a .config file that exhibits the problem, I'd
> > > > love to look at it.
> > > > 
> > > > thanks,
> > > > ---
> > > > ~Randy
> > > 
> > > 
> > > Okay, here is the diff between 2.6.34-git4 and 2.6.34-git5
> > > It should be equivalent to make silentoldconfig as I made no
> > > changes, just enter to accept defaults.  The git4 boots and
> > > git5 does not boot.     (Both based off 2.6.34.1.config)
> > 
> > Yes, I had just generated this same diff.
> > The only config change that could remotely make a difference is:
> > > +# CONFIG_SATA_AHCI_PLATFORM is not set
> > 
> > and I don't see how it could matter.
> > 
> > > (and attached config-2.6.34-git4.gz, because .config was too
> > >  big for mail list last time.)
> > 
> > Last time being recently?  lkml accepts email sizes (with attachments)
> > up to 300 KB, IIRC.
> 
> Maybe http://lkml.indiana.edu/hypermail/linux/kernel/1008.0/index.html
> throws out large email but the actual lkml does not?  I did not see

That could be.  I usually use http://marc.info/?l=linux-kernel
or http://lkml.org .

> it show up; here is header of email that had large (56.48K) .config:

I often post configs that are larger than that one.
I also checked my kernel mailbox and see several much larger emails, in
the 200KB/300KB range.

And the vger.kernel.org postmaster wrote on 13-AUG-2007:

"The posting limit is 400K for linux-kernel, netdev, and one
or two of the other lists."

so it could be something other than size that caused it to be dropped,
like html or some taboo word(s).  E.g., see
http://vger.kernel.org/majordomo-info.html#taboo


> >
> From: 	Donald Parsons
> To: 	Randy Dunlap
> Cc: 	linux-kernel <linux-kernel@vger.k.o>, Linus Torvalds
> Subject: Re: Linux 2.6.35
> Date: 	08/01/2010 11:41:31 PM  (this is EDT)
> Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
> 
> 
> > > --- config-2.6.34-git4  2010-08-01 19:52:48.000000000 -0400
> > > +++ config-2.6.34-git5  2010-08-01 18:10:14.000000000 -0400
> > > @@ -1,7 +1,7 @@
> > >  #
> > >  # Automatically generated make config: don't edit
> ...deleted most lines...
> > > -#
> > >  # CONFIG_STAGING is not set
> > >  CONFIG_X86_PLATFORM_DEVICES=y
> > >  # CONFIG_ACER_WMI is not set
> > > 
> > > -------------------------------------------
> > > 
> > > Can possibly duplicate problem if you have a 
> > > sata based PC from last few years.
> > > 
> > > Set  CONFIG_ATA=m
> > 
> > That's already =m in this config file.
> > 
> > > and this becomes CONFIG_SATA_AHCI=m  (cannot select=y)
> > 
> > That's as expected.  CONFIG_ATA value controls CONFIG_SATA_AHCI
> > possible values.
> > 
> > > 
> > > Then 2.6.34.[01] (probably 2 also) will boot.
> > > Make silentoldconfig with this .config and see
> > > that 2.6.35 will not boot.
> > 
> > So with CONFIG_ATA=m and CONFIG_SATA_AHCI=m, does 2.6.34-git4 boot
> > but 2.6.34-git5 fails to boot?
> 
> Yes, that is exactly correct.


OK, I'll test that on a test machine.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***

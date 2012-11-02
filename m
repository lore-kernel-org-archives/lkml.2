Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760427Ab2KBQww (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 12:52:52 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:41319 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755788Ab2KBQwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 12:52:49 -0400
Message-ID: <1351875164.2439.42.camel@dabdike.int.hansenpartnership.com>
Subject: Re: [RFC] Second attempt at kernel secure boot support
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Chris Friesen <chris.friesen@genband.com>,
        Eric Paris <eparis@parisplace.org>, Jiri Kosina <jkosina@suse.cz>,
        Oliver Neukum <oneukum@suse.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Josh Boyer <jwboyer@gmail.com>,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-efi@vger.kernel.org
Date: Fri, 02 Nov 2012 16:52:44 +0000
In-Reply-To: <20121102163302.GA6080@elf.ucw.cz>
References: <50919EED.3020601@genband.com>
	 <36538307.gzWq1oO7Kg@linux-lqwf.site>
	 <1351760905.2391.19.camel@dabdike.int.hansenpartnership.com>
	 <alpine.LNX.2.00.1211011017230.6606@pobox.suse.cz>
	 <1351762703.2391.31.camel@dabdike.int.hansenpartnership.com>
	 <alpine.LNX.2.00.1211011044290.6606@pobox.suse.cz>
	 <1351763954.2391.37.camel@dabdike.int.hansenpartnership.com>
	 <CACLa4puzLR2om6SHw3wVnfZ1nezVsKOp8+705AdHZ4_=JamYfw@mail.gmail.com>
	 <20121101202701.GB20817@xo-6d-61-c0.localdomain>
	 <5092E361.7080901@genband.com> <20121102163302.GA6080@elf.ucw.cz>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-11-02 at 17:33 +0100, Pavel Machek wrote:
> On Thu 2012-11-01 15:02:25, Chris Friesen wrote:
> > On 11/01/2012 02:27 PM, Pavel Machek wrote:
> > 
> > >Could someone write down exact requirements for Linux kernel to be signed by Microsoft?
> > >Because thats apparently what you want, and I don't think crippling kexec/suspend is
> > >enough.
> > 
> > As I understand it, the kernel won't be signed by Microsoft.
> 
> > Rather, the bootloader will be signed by Microsoft and the vendors
> > will be the ones that refuse to sign a kernel unless it is
> > reasonably assured that it won't be used as an attack vector.
> 
> Yes. So can someone write down what "used as an attack vector" means?
> 
> Because, AFAICT, Linux kernel is _designed_ to work as an attact
> vector. We intentionally support wine, and want to keep that support.

I think there's a variety of opinions on this one.

My definition is that you can construct a signed boot system from the
components delivered with a Linux distribution that will fairly
invisibly chain load a hacked version of windows.  Thus allowing the
windows user to think they have a chain of trust to the UEFI firmware
when, in fact, they haven't.

The first question is how many compromises do you need.  Without
co-operation from windows, you don't get to install something in the
boot system, so if you're looking for a single compromise vector, the
only realistic attack is to trick the user into booting a hacked linux
system from USB or DVD.

There's also a lot of debate around "fairly invisibly".  If your hack
involves shim->grub->linux->windows, that's a fairly long boot process
with time for the user to notice something.

Obviously, a boot loader that breaks the trust chain is ideal as a
windows attack vector, which is why most pre bootloaders on virgin
systems do a present user test (tell the user what they're doing and ask
permission to continue).  I really think that if the shim+MOK system
always paused and asked to continue if the MOK Boot Services variables
aren't present (i.e. it's a first boot virgin system), we've solved the
windows attack vector problem, and we can move on from this rather
sterile debate to think of how we can use secure boot to enhance Linux
security for the machine owner.

James



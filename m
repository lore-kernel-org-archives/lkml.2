Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753140Ab1EWKtz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 06:49:55 -0400
Received: from service87.mimecast.com ([94.185.240.25]:49760 "HELO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751813Ab1EWKty convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 06:49:54 -0400
Subject: Re: Linux 2.6.39
From: Catalin Marinas <catalin.marinas@arm.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Mark Lord <kernel@teksavvy.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20110519092318.1a946dce.randy.dunlap@oracle.com>
References: <BANLkTikB37AvEgh1MAFBbYvFaxsL6W11OQ@mail.gmail.com>
	 <4DD53AE5.8020103@teksavvy.com>
	 <BANLkTi=7v40xpM6-jQ2CS09fEb0noFLYPg@mail.gmail.com>
	 <20110519092318.1a946dce.randy.dunlap@oracle.com>
Organization: ARM Limited
Date: Mon, 23 May 2011 11:49:41 +0100
Message-ID: <1306147781.7196.2.camel@e102109-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1
X-OriginalArrivalTime: 23 May 2011 10:49:54.0328 (UTC) FILETIME=[264B8180:01CC1937]
X-MC-Unique: 111052311494507701
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-05-19 at 17:23 +0100, Randy Dunlap wrote:
> On Thu, 19 May 2011 17:16:32 +0100 Catalin Marinas wrote:
> > On 19 May 2011 16:44, Mark Lord <kernel@teksavvy.com> wrote:
> > > Here's some more funny business that was new after rc7-git12:
> > >
> > > warning: (AX88796_93CX6 && RTL8180 && RTL8187 && ADM8211 && RT2400PCI &&
> > > RT2500PCI && RT61PCI && RT2800PCI && R8187SE) selects EEPROM_93CX6 which has
> > > unmet direct dependencies (MISC_DEVICES)
> > > warning: (ACPI_APEI) selects PSTORE which has unmet direct dependencies
> > > (MISC_FILESYSTEMS)
> > >
> > > The exact same .config didn't do that with rc7-git12,
> > > but does do it with 2.6.39 final.
> > >
> > > Odd thing is, if I select both MISC_DEVICES and MISC_FILESYSTEMS,
> > > but do NOT select anything from under either of those,
> > > the warnings go away.
> > >
> > > Which likely means the warnings are totally bogus.
> >
> > The problem is:
> >
> > AX88796_93CX6 selects EEPROM_93CX6
> > EEPROM_93CX6 depends on MISC_DEVICES (as part of the EEPROM menu which
> > is only included if MISC_DEVICES)
> >
> > By enabling MISC_DEVICES, you allow AX88796_93CX6 to select
> > EEPROM_93CX6 without any warning as it has the dependencies met.
> >
> > The issue here is that EEPROM_93CX6 doesn't really depend on any
> > MISC_DEVICES infrastructure. That's just a directory for various
> > drivers and MISC_DEVICES only has a visibility role. There was a
> > proposal last year for kbuild to differentiate between dependency and
> > visibility but I don't know what happened to it.
> 
> fwiw, there is a VISIBLE attribute now.  It defaults to yes/on.

OK. It helps but only if all the misc devices have "visible if
MISC_DEVICES" in their config options and entirely eliminate the
"if/endif" block.

Alternatively, maybe the if/endif block could generate a visibility
expression rather than a dependency. It works for MISC_DEVICES but I'm
not sure whether this is applicable across the kernel.

-- 
Catalin



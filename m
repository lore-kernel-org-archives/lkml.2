Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933507Ab1ESQYM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 12:24:12 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:45038 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932238Ab1ESQYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 12:24:10 -0400
Date: Thu, 19 May 2011 09:23:18 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Mark Lord <kernel@teksavvy.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.39
Message-Id: <20110519092318.1a946dce.randy.dunlap@oracle.com>
In-Reply-To: <BANLkTi=7v40xpM6-jQ2CS09fEb0noFLYPg@mail.gmail.com>
References: <BANLkTikB37AvEgh1MAFBbYvFaxsL6W11OQ@mail.gmail.com>
	<4DD53AE5.8020103@teksavvy.com>
	<BANLkTi=7v40xpM6-jQ2CS09fEb0noFLYPg@mail.gmail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4DD54404.0047:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 May 2011 17:16:32 +0100 Catalin Marinas wrote:

> On 19 May 2011 16:44, Mark Lord <kernel@teksavvy.com> wrote:
> > Here's some more funny business that was new after rc7-git12:
> >
> > warning: (AX88796_93CX6 && RTL8180 && RTL8187 && ADM8211 && RT2400PCI &&
> > RT2500PCI && RT61PCI && RT2800PCI && R8187SE) selects EEPROM_93CX6 which has
> > unmet direct dependencies (MISC_DEVICES)
> > warning: (ACPI_APEI) selects PSTORE which has unmet direct dependencies
> > (MISC_FILESYSTEMS)
> >
> > The exact same .config didn't do that with rc7-git12,
> > but does do it with 2.6.39 final.
> >
> > Odd thing is, if I select both MISC_DEVICES and MISC_FILESYSTEMS,
> > but do NOT select anything from under either of those,
> > the warnings go away.
> >
> > Which likely means the warnings are totally bogus.
> 
> The problem is:
> 
> AX88796_93CX6 selects EEPROM_93CX6
> EEPROM_93CX6 depends on MISC_DEVICES (as part of the EEPROM menu which
> is only included if MISC_DEVICES)
> 
> By enabling MISC_DEVICES, you allow AX88796_93CX6 to select
> EEPROM_93CX6 without any warning as it has the dependencies met.
> 
> The issue here is that EEPROM_93CX6 doesn't really depend on any
> MISC_DEVICES infrastructure. That's just a directory for various
> drivers and MISC_DEVICES only has a visibility role. There was a
> proposal last year for kbuild to differentiate between dependency and
> visibility but I don't know what happened to it.

fwiw, there is a VISIBLE attribute now.  It defaults to yes/on.


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***

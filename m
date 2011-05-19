Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933014Ab1ESPsI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 11:48:08 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:43423 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753053Ab1ESPsG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 11:48:06 -0400
Date: Thu, 19 May 2011 08:47:51 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Mark Lord <kernel@teksavvy.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.39
Message-Id: <20110519084751.a2953fce.randy.dunlap@oracle.com>
In-Reply-To: <4DD53AE5.8020103@teksavvy.com>
References: <BANLkTikB37AvEgh1MAFBbYvFaxsL6W11OQ@mail.gmail.com>
	<4DD53AE5.8020103@teksavvy.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4DD53BB3.00F6:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 May 2011 11:44:37 -0400 Mark Lord wrote:

> Here's some more funny business that was new after rc7-git12:
> 
> warning: (AX88796_93CX6 && RTL8180 && RTL8187 && ADM8211 && RT2400PCI &&
> RT2500PCI && RT61PCI && RT2800PCI && R8187SE) selects EEPROM_93CX6 which has
> unmet direct dependencies (MISC_DEVICES)
> warning: (ACPI_APEI) selects PSTORE which has unmet direct dependencies
> (MISC_FILESYSTEMS)
> 
> The exact same .config didn't do that with rc7-git12,
> but does do it with 2.6.39 final.

I've seen those kconfig warnings plenty of times, before 2.6.39.

Tony Luck has posted a patch for the ACPI_APEI/PSTORE warning (yes, select
MISC_FILESYSTEMS).

> Odd thing is, if I select both MISC_DEVICES and MISC_FILESYSTEMS,
> but do NOT select anything from under either of those,
> the warnings go away.
> 
> Which likely means the warnings are totally bogus.

It's just the nature of the tree-structured kconfig hierarchy.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***

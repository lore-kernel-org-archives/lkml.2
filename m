Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758205Ab0DHGkq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 02:40:46 -0400
Received: from smtprelay02.ispgateway.de ([80.67.31.36]:45407 "EHLO
	smtprelay02.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753376Ab0DHGkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 02:40:45 -0400
Message-ID: <4BBD7997.1020803@ladisch.de>
Date: Thu, 08 Apr 2010 08:37:11 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Mark Knecht <markknecht@gmail.com>
CC: Robert Hancock <hancockrwd@gmail.com>,
       Linux Kernel List <linux-kernel@vger.kernel.org>
Subject: Re: Failed to initialize MSI interrupts && ioremap reserve_memtype
 failed -22
References: <x2w5bdc1c8b1004051355o3f803c75t2515ef46320e00bd@mail.gmail.com>	 <4BBC9CA1.5080102@ladisch.de>	 <m2l5bdc1c8b1004070857r823821ack6cc99354db73eaa0@mail.gmail.com>	 <4BBD1957.90502@gmail.com>	 <k2l5bdc1c8b1004072051h957c3f1crf0a139bd96a093a4@mail.gmail.com> <v2h51f3faa71004072054y4733bf9bq80a04574bebbadba@mail.gmail.com>
In-Reply-To: <v2h51f3faa71004072054y4733bf9bq80a04574bebbadba@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Df-Sender: linux-kernel@cl.domainfactory-kunde.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock wrote:
> Hmm, not really clear to me why MSI wouldn't be used.. there aren't
> any kernel messages that seem to say why MSI would be disabled or
> unsupported. Unless maybe that particular model doesn't support MSI?

This Intel onboard adapter always supports MSI, and AFAICS there is no
MSI quirk for this chipset.

Mark, is CONFIG_PCI_MSI actually enabled?

> > ioremap reserve_memtype failed -22

ioremap is used by drivers (and sometimes by the kernel itself) to get
access to some device's memory-mapped I/O range.  "-22" is -EINVAL and
is returned by reserve_memtype to indicate that the requested memory
range includes both RAM and not-RAM.

Without a following error message, it's not possible to find out which
device that is, and where that funny address range comes from.  The fact
that there is no error message might indicate that this is harmless, but
if you want to find out more, add the following lines to
arch/x86/mm/ioremap.c directly after the error message:

		printk(KERN_ERR "phys_addr: %#Lx, size: %#Lx\n",
		       (u64)phys_addr, (u64)size);
		dump_stack();


Regards,
Clemens

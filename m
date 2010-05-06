Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753877Ab0EFWzW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 18:55:22 -0400
Received: from kroah.org ([198.145.64.141]:43030 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751875Ab0EFWzV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 18:55:21 -0400
Date: Thu, 6 May 2010 15:44:29 -0700
From: Greg KH <greg@kroah.com>
To: Yinghai <yinghai.lu@oracle.com>
Cc: Greg KH <gregkh@suse.de>,
       Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, trenn@suse.de,
       hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: [2.6.31.13] Build failure at arch/x86/kernel/apic/io_apic.c
Message-ID: <20100506224429.GC7600@kroah.com>
References: <201004120230.o3C2UhfQ050532@www262.sakura.ne.jp>
 <20100412024446.GA28141@suse.de>
 <201004120410.o3C4Axwe066941@www262.sakura.ne.jp>
 <20100501180715.GA7745@suse.de>
 <4BDF04D6.7040003@oracle.com>
 <20100503174422.GC11676@suse.de>
 <4BDF0CF1.5070006@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BDF0CF1.5070006@oracle.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 03, 2010 at 10:50:41AM -0700, Yinghai wrote:
> On 05/03/2010 10:44 AM, Greg KH wrote:
> > On Mon, May 03, 2010 at 10:16:06AM -0700, Yinghai wrote:
> >> On 05/01/2010 11:07 AM, Greg KH wrote:
> >>> On Mon, Apr 12, 2010 at 01:10:59PM +0900, Tetsuo Handa wrote:
> >>>> Commit d539e5576605d048e6aeb21cbe3a8e71dc5eea81 "x86: Fix SCI on IOAPIC != 0"
> >>>> introduced "void setup_IO_APIC_irq_extra(u32 gsi)" which calls
> >>>> mp_find_ioapic() and mp_find_ioapic_pin().
> >>>>
> >>>> This commit does not compile if CONFIG_X86_IO_APIC=y and CONFIG_ACPI=n .
> >>>
> >>> Why would you want to build without ACPI on any modern system?  Anyway,
> >>> have a fix for this?
> >>>
> >> maybe just put #ifdef CONFIG_ACPI around the callee etc?
> > 
> > Ick.  How was it solved upstream?
> > 
> 
> those two functions are moved to arch/x86/kernel/apic/io_apic.c
> 
> maybe you can put that patch to 2.6.31.xx?

In looking at it further, that patch is just too big for .31 at this
point in time, sorry.  Just select ACPI as a config option, and you
should be fine.

Actually, use .32 or .33, I wouldn't recommend using .31 anymore anyway.

thanks,

greg k-h

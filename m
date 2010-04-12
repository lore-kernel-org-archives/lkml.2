Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751180Ab0DLENL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 00:13:11 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:60287 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750847Ab0DLENJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 00:13:09 -0400
Message-Id: <201004120410.o3C4Axwe066941@www262.sakura.ne.jp>
Subject: Re: [2.6.31.13] Build failure at arch/x86/kernel/apic/io_apic.c
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To: gregkh@suse.de, trenn@suse.de, yinghai@kernel.org, hpa@zytor.com
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Mon, 12 Apr 2010 13:10:59 +0900
References: <201004120230.o3C2UhfQ050532@www262.sakura.ne.jp> <20100412024446.GA28141@suse.de>
In-Reply-To: <20100412024446.GA28141@suse.de>
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: K-Prox Anti-Virus Powered by Kaspersky, bases: 11042010 #3700788, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit d539e5576605d048e6aeb21cbe3a8e71dc5eea81 "x86: Fix SCI on IOAPIC != 0"
introduced "void setup_IO_APIC_irq_extra(u32 gsi)" which calls
mp_find_ioapic() and mp_find_ioapic_pin().

This commit does not compile if CONFIG_X86_IO_APIC=y and CONFIG_ACPI=n .

Regards.

Greg KH wrote:
> On Mon, Apr 12, 2010 at 11:30:43AM +0900, Tetsuo Handa wrote:
> > Hello.
> > 
> >   CC      arch/x86/kernel/apic/io_apic.o
> > arch/x86/kernel/apic/io_apic.c: In function `setup_IO_APIC_irq_extra':
> > arch/x86/kernel/apic/io_apic.c:1575: error: implicit declaration of function `mp_find_ioapic'
> > arch/x86/kernel/apic/io_apic.c:1579: error: implicit declaration of function `mp_find_ioapic_pin'
> > make[3]: *** [arch/x86/kernel/apic/io_apic.o] Error 1
> > make[2]: *** [arch/x86/kernel/apic] Error 2
> > make[1]: *** [arch/x86/kernel] Error 2
> > make: *** [arch/x86] Error 2
> > 
> > This is because
> > 
> > #ifdef CONFIG_ACPI
> > (...snipped...)
> > #ifdef CONFIG_X86_IO_APIC
> > extern int mp_find_ioapic(int gsi);
> > extern int mp_find_ioapic_pin(int ioapic, int gsi);
> > #endif
> > (...snipped...)
> > #endif
> > 
> > but CONFIG_X86_IO_APIC=y and CONFIG_ACPI=n in my config.
> > 2.6.31.12 was OK.
> 
> What patch caused this?
> 
> thanks,
> 
> greg k-h

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754852Ab1DDRWE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 13:22:04 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:34911 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754075Ab1DDRWD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 13:22:03 -0400
Message-ID: <4D99FE36.1070307@monstr.eu>
Date: Mon, 04 Apr 2011 19:21:58 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: Michal Simek <monstr@monstr.eu>
CC: linux-kernel@vger.kernel.org, john.williams@petalogix.com,
        Russell King <linux@arm.linux.org.uk>,
        Ralf Baechle <ralf@linux-mips.org>, Ingo Molnar <mingo@redhat.com>,
        Alan Cox <alan@linux.intel.com>, linux-serial@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: Microblaze early console support
References: <1301934655-20495-1-git-send-email-monstr@monstr.eu>
In-Reply-To: <1301934655-20495-1-git-send-email-monstr@monstr.eu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

resent.

M

Michal Simek wrote:
> Hi,
> 
> I have one question about early console support on MMU kernel.
> When do you register an early console and what TLB mapping you use?
> 
> For Microblaze I registered it before main memory is setup that's why I was
> hardcoded TLB 63 to 1:1 mapping (virt addr = phys addr). 
> It is output only for early_printk messages but I would like to use it 
> as boot console. There are only some messages that's why TLB 63 was released
> later on.
> That is the current state.
> 
> I have added CON_BOOT flag and register early console by register_console function
> and I allocate TLB 63 for it. But unfortunately I haven't found any function 
> in unregister_console which is called for unregistering to help me to release TLB 63
> when early console is not used. Is there any way how to do it?
> 
> From our experiment in past there is performance degression when kernel can't use
> a TLB that's why I tried to find out a way to release TLB 63.
> This is the reason why I would like to know your opinion if my style is correct 
> or not.
> I created new remap_early_printk function which does ioremap for console space.
> This function is called from setup_arch when memory is setup. Then early mapping of TLB 63
> is automatically released and can be used for Linux purpose.
> Is it correct design how to do it?
> 
> How do you handle it in your arch? Do you register early console before memory initialization
> is done?
> 
> You can also look at my patch I have done.
> 
> Thanks for your suggestions,
> Michal

-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753822Ab3AHCbV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 21:31:21 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33257 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753014Ab3AHCbU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 21:31:20 -0500
Message-ID: <50EB84F2.4070708@suse.com>
Date: Mon, 07 Jan 2013 21:31:14 -0500
From: Jeff Mahoney <jeffm@suse.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] staging/sb105x: remove asm/segment.h dependency
References: <50EB4A3B.1020307@suse.com> <1357598164.5190.12.camel@gandalf.local.home>
In-Reply-To: <1357598164.5190.12.camel@gandalf.local.home>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/7/13 5:36 PM, Steven Rostedt wrote:
> This patch is obsoleted by:
> 
> https://lkml.org/lkml/2012/12/13/710
> 
> Which I just got the automated reply, and it's in Greg's staging tree
> now.
> 
> When I get time, I do want to try to get this driver (and device)
> working on my ppc64 box.

Ok, this blob (predictably) works to build on my ppc64 box.

--- a/drivers/staging/sb105x/sb_pci_mp.c
+++ b/drivers/staging/sb105x/sb_pci_mp.c
@@ -2836,7 +2836,8 @@ static void __init multi_init_ports(void
                                osc = 0;
                        for(j=0;j<osc;j++)
                                mtpt->port.uartclk *= 2;
-                       mtpt->port.flags    |= STD_COM_FLAGS | UPF_SHARE_IRQ ;
+                       mtpt->port.flags    |= UPF_BOOT_AUTOCONF|UPF_SKIP_TEST;
+                       mtpt->port.flags    |= UPF_SHARE_IRQ;
                        mtpt->port.iotype   = UPIO_PORT;
                        mtpt->port.ops      = &multi_pops;

-Jeff

> Thanks,
> 
> -- Steve
> 
> 
> On Mon, 2013-01-07 at 17:20 -0500, Jeff Mahoney wrote:
>> sb105x doesn't seem to actually need <asm/segment.h> (builds on x86
>> without it) and ppc/ppc64 doesn't provide it so it fails to build there.
>>
>> This patch removes the dependency. Unfortunately, it now fails to build
>> because STD_COM_FLAGS isn't defined on most architectures. I'm not familiar
>> enough with the tty/serial system to patch that aspect of it.
>>
>> CC: Steven Rostedt <rostedt@goodmis.org>
>> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
>> ---
>>
>>  drivers/staging/sb105x/sb_pci_mp.h |    1 -
>>  1 file changed, 1 deletion(-)
>>
>> --- a/drivers/staging/sb105x/sb_pci_mp.h
>> +++ b/drivers/staging/sb105x/sb_pci_mp.h
>> @@ -19,7 +19,6 @@
>>  #include <asm/uaccess.h>
>>  #include <asm/io.h>
>>  #include <asm/irq.h>
>> -#include <asm/segment.h>
>>  #include <asm/serial.h>
>>  #include <linux/interrupt.h>
>>  
>>
>>
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


-- 
Jeff Mahoney
SUSE Labs

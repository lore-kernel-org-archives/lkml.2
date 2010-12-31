Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753772Ab0LaSdt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Dec 2010 13:33:49 -0500
Received: from xenotime.net ([72.52.115.56]:49275 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751104Ab0LaSds (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Dec 2010 13:33:48 -0500
Date: Fri, 31 Dec 2010 10:33:45 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
To: yotam.medini@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: APM_CONFIG on x86 - Is it possible?
Message-Id: <20101231103345.baba0f8c.rdunlap@xenotime.net>
In-Reply-To: <20101231193858.2c742025@janini.home>
References: <20101231193858.2c742025@janini.home>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 Dec 2010 19:38:58 +0200 Yotam Medini wrote:

> Hello,
> 
> To an ancient target (my UMAX 530T ActionBook - plz don't laugh...)
> I am trying to build a lean kernel based on 2.6.32.24 (~ Ubuntu 10.04).
> Battery monitoring used to be based on /proc/apm.
> I believe ACPI is not supported on this old notebook.
> Now, it seems that  CONFIG_APM_POWER  cannot be set, since:
> 
> 1. The configuration place for  APM_POWER  is in:
>    ./drivers/power/Kconfig:25:
> 	config APM_POWER
> 		tristate "APM emulation for class batteries"
> 		depends on APM_EMULATION
> 
> 2. The configuration place for  APM_EMULATION  is in:
>     ./kernel/power/Kconfig:201:
>     config APM_EMULATION
> 	    tristate "Advanced Power Management Emulation"
> 	    depends on PM && SYS_SUPPORTS_APM_EMULATION
> 
> 3. But the configuration places for the latter -  
>       SYS_SUPPORTS_APM_EMULATION
>   - exists only in:
>     ./arch/powerpc/Kconfig:185:config SYS_SUPPORTS_APM_EMULATION
>     ./arch/sh/Kconfig:120:config SYS_SUPPORTS_APM_EMULATION
>     ./arch/mips/Kconfig:896:config SYS_SUPPORTS_APM_EMULATION
>     ./arch/arm/Kconfig:32:config SYS_SUPPORTS_APM_EMULATION
>   and none under arch/x86 ! :():
> 
> So my bottom line questions are:
> + Am I missing something?
> + What is the 'right way' to configure a 2.6.3m.nn kernel
>   that should support battery monitoring on such ancient laptops.
> 
> When replying, please CC: yotam DOT medini AT Gmail DOT c0m
> regards -- yotam
> --


arch/x86/Kconfig has the kconfig symbol "APM":

menuconfig APM
	tristate "APM (Advanced Power Management) BIOS support"
	depends on X86_32 && PM_SLEEP
=> /proc/apm for battery status information

so as long as your target system is 32-bit X86, you should be OK.

PM_SLEEP depends on SUSPEND || HIBERNATION.  PM needs to be enabled,
and SWAP has to be enabled for HIBERNATION.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
desserts:  http://www.xenotime.net/linux/recipes/

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754358Ab0LaWXi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Dec 2010 17:23:38 -0500
Received: from xenotime.net ([72.52.115.56]:33265 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754196Ab0LaWXh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Dec 2010 17:23:37 -0500
Date: Fri, 31 Dec 2010 14:23:35 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
To: yotam.medini@gmail.com
Cc: linux-kernel@vger.kernel.org, Avery Pennarun <apenwarr@alumnit.ca>
Subject: Re: APM_CONFIG on x86 - Is it possible?
Message-Id: <20101231142335.84e00497.rdunlap@xenotime.net>
In-Reply-To: <20101231234010.0165f0e8@janini.home>
References: <20101231193858.2c742025@janini.home>
	<20101231103345.baba0f8c.rdunlap@xenotime.net>
	<20101231212800.1e47f200@janini.home>
	<20101231113954.dc9adbdf.rdunlap@xenotime.net>
	<20101231234010.0165f0e8@janini.home>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 Dec 2010 23:40:10 +0200 Yotam Medini wrote:

> The .config I ended up with does have:
>    CONFIG_APM=m
> But no CONFIG_APM_POWER setting, 
> When booting the kernel, I don not have /proc/apm.
> I do get:
> 
>   $ sudo modprobe apm
>   FATAL: Error inserting apm 
>     (/lib/modules/2.6.32.yumax/kernel/arch/x86/kernel/apm.ko): No such device
> 
> Please note that 
>   drivers/power/Makefile:118
> has:
>   obj-$(CONFIG_APM_POWER) += apm_power.o
> 
> Also the "/proc/apm" is created in 
>   drivers/char/Makefile:71
>     obj-$(CONFIG_APM_EMULATION)	+= apm-emulation.o
>   drivers/char/apm-emulation.c:668-670

Hint: This is not the only place that /proc/apm is created.


>     #ifdef CONFIG_PROC_FS
> 	    proc_create("apm", 0, NULL, &apm_proc_fops);
>     #endif
> As far as I understand, CONFIG_APM is not sufficient 
> for the creation of "/proc/apm".


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
desserts:  http://www.xenotime.net/linux/recipes/

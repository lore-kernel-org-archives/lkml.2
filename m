Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755336Ab0D1PdT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 11:33:19 -0400
Received: from compulab.co.il ([67.18.134.219]:47881 "EHLO compulab.co.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755228Ab0D1PdS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 11:33:18 -0400
Message-ID: <4BD854F0.9040107@compulab.co.il>
Date: Wed, 28 Apr 2010 18:32:00 +0300
From: Mike Rapoport <mike@compulab.co.il>
User-Agent: Thunderbird 2.0.0.23 (X11/20100106)
MIME-Version: 1.0
To: Graeme Russ <graeme.russ@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Request For Help - Embedded x86, Kernel 2.6.33 boots, Mounts
 JFFS2 rootfs, Stops at init
References: <4BD8415C.9060409@gmail.com>
In-Reply-To: <4BD8415C.9060409@gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-ACL-Warn: {
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - compulab.site5.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Graeme Russ wrote:
> Hi All,
> 
> I've been working for a while now getting the x86 U-Boot port up to speed
> to boot a linux kernel
> 
> I now have a root fs (build from Linux-From-Scratch and trimmed to <15M
> using qemu) but all attempts to get any serial console output past
> launching of init have failed.
> 
> I have taken the root fs which successfully boots using qemu and created a
> jffs2 image and flashed it onto one of the on-board flash chips. U-Boot can
> successfully 'ls' the root fs
> 
> My bootags are:
> 
>   root=/dev/mtdblock1 rw rootfstype=jffs2 console=ttyS0,115200
> 
> as Linux can mount the root partition:
> [    1.447819] Serial: 8250/16550 driver, 6 ports, IRQ sharing disabled

[ snip ]

> [    1.911896] Write protecting the kernel read-only data: 596k
> [    1.915842] kernel_execve(/sbin/init)
> 
> (I've added a printk in kernel_execve() which gives me the last line)
> 
> I  initially had hot-plug support compiled into the kernel and was getting
> a lot of kernel_execve(/sbin/hotplug) messages as well (plus a udev:
> starting version 151 message which appear 100+ seconds and the above
> messages), but I have since removed that and used mknod to create
> /dev/ttyS0 directly
> 
> I have also tried the following test script:
> 
> #!/bin/bash
> stty -F /dev/ttyS0 115200
> cat hello > /dev/ttyS0
> 
> but still no luck
> 
> Does anyone have any advise on how I can debug this problem?

Have you tried with init=/bin/sh?
Also, make sure you have /dev/null and /dev/console nodes.

> 
> Regards,
> 
> Graeme
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


-- 
Sincerely yours,
Mike.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755398Ab0D1QIu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 12:08:50 -0400
Received: from lo.gmane.org ([80.91.229.12]:55786 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754551Ab0D1QIt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 12:08:49 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
connect(): No such file or directory
From: Alexander Clouter <alex@digriz.org.uk>
Subject: Re: Request For Help - Embedded x86, Kernel 2.6.33 boots, Mounts JFFS2 rootfs, Stops at init
Date: Wed, 28 Apr 2010 16:37:00 +0100
Message-ID: <s91ma7-76h.ln1@chipmunk.wormnet.eu>
References: <4BD8415C.9060409@gmail.com>
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: chipmunk.wormnet.eu
User-Agent: tin/1.9.3-20080506 ("Dalintober") (UNIX) (Linux/2.6.26-2-sparc64-smp (sparc64))
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Graeme Russ <graeme.russ@gmail.com> wrote:
> 
> I've been working for a while now getting the x86 U-Boot port up to speed
> to boot a linux kernel
>
...ewww x86.
 
> [snipped]
>
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
> 
What does you /dev directory look like?  You need to have at least the 
following:
----
mknod console c 5 1
mknod null c 1 3
mknod ttyS0 c 4 64
----

Cheers

-- 
Alexander Clouter
.sigmonster says: Your love life will be... interesting.


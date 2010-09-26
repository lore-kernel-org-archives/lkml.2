Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758178Ab0IZWkV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Sep 2010 18:40:21 -0400
Received: from xenotime.net ([72.52.115.56]:51944 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757876Ab0IZWkV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Sep 2010 18:40:21 -0400
Date: Sun, 26 Sep 2010 15:40:11 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Thomas Meyer <thomas@m3y3r.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        jbeulich@novell.com, r.marek@assembler.cz, guenter.roeck@ericsson.com
Subject: Re: 2.6.36-rc5+: drivers/hwmon/coretemp.c:506: error: implicit
 declaration of function 'cpu_sibling_mask'
Message-Id: <20100926154011.61333ffd.rdunlap@xenotime.net>
In-Reply-To: <201009262317.50500.thomas@m3y3r.de>
References: <201009262317.50500.thomas@m3y3r.de>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 26 Sep 2010 23:17:50 +0200 Thomas Meyer wrote:

> $ make V=2
>   CHK     include/linux/version.h
>   CHK     include/generated/utsrelease.h
>   CALL    scripts/checksyscalls.sh - due to target is PHONY
>   CHK     include/generated/compile.h
>   CC [M]  drivers/hwmon/coretemp.o - due to target missing
> drivers/hwmon/coretemp.c: In function 'coretemp_device_remove':
> drivers/hwmon/coretemp.c:506: error: implicit declaration of function 'cpu_sibling_mask'
> make[2]: *** [drivers/hwmon/coretemp.o] Error 1
> make[1]: *** [drivers/hwmon] Error 2
> make: *** [drivers] Error 2
> 
> above function is not defined on UP.

Patch just posted:

http://lkml.org/lkml/2010/9/26/112


> This commit introduced the error:
> 
> commit e40cc4bdfd4b89813f072f72bd9c7055814d3f0f
> Author: Jan Beulich <jbeulich@novell.com>
> Date:   Mon Sep 13 10:23:05 2010 +0000
> 
>     x86/hwmon: register alternate sibling upon CPU removal
>     
>     Just like pkgtemp registers another core of the same package when one
>     gets removed, coretemp should register another hyperthread (if
>     available) in that situation.
>     
>     As pointed out in the patch fixing the respective code in pkgtemp, the
>     list protectng mutex must be dropped before calling
>     coretemp_device_add(), and due to the restructured loop (including an
>     explicit return) the "safe" variant of the list iterator isn't needed
>     anymore.
>     
>     Signed-off-by: Jan Beulich <jbeulich@novell.com>
>     Cc: Rudolf Marek <r.marek@assembler.cz>
>     Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
> --


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***

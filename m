Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754899Ab0JHWeK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 18:34:10 -0400
Received: from asmtpout026.mac.com ([17.148.16.101]:36853 "EHLO
	asmtpout026.mac.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754187Ab0JHWeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 18:34:08 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; CHARSET=US-ASCII
Subject: Re: kgdb errors with serial console
From: Elvis Dowson <elvis.dowson@mac.com>
In-reply-to: <4CAF19FA.7010206@windriver.com>
Date: Sat, 09 Oct 2010 02:33:30 +0400
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>
Message-id: <C90C915C-B8A6-47F3-9935-63C9A060BDB1@mac.com>
References: <BDD07355-7199-4A2E-8426-F6D43EA5D313@mac.com>
 <4CAE4BB6.7080509@windriver.com>
 <7BA01CAF-DD25-4AB6-9498-8AB89E2EDDE1@mac.com>
 <4CAE5B40.3070701@windriver.com>
 <917F9CCC-F3D3-4E23-B955-412F08CE8E2E@mac.com> <4CAF19FA.7010206@windriver.com>
To: Jason Wessel <jason.wessel@windriver.com>
X-Mailer: Apple Mail (2.1081)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jason,
                    Some good news. I switch the GDB command set from mi to mi1, and it seems to be working now. 

What I did is added the kgdbwait command to the bootargs as follows (not sure if it was necessary, but will try once again without it)

setenv mmcargs 'setenv bootargs console=${console} vram=12M omapfb.vram=0:4M omapfb.mode=dvi:${dvimode} omapdss.def_disp=${defaultdisplay} root=/dev/mmcblk0p2 rw rootfstype=ext3 rootwait kgdb=${console} kgdboc=${console} kgdbwait'

Then I launched the debugger, and it did something, and resumed normally. 

Then I manually went to the console and activated kgdb by typing 

echo g > /proc/sysrq-trigger

This caused the debugger on the Eclipse side to process something, and then it stopped in file kgdb.c at the call to arch_kgdb_breakpoint(), in the following method:

void kgdb_breakpoint(void)
{
	atomic_set(&kgdb_setting_breakpoint, 1);
	wmb(); /* Sync point before breakpoint */
	arch_kgdb_breakpoint();
	wmb(); /* Sync point after breakpoint */
	atomic_set(&kgdb_setting_breakpoint, 0);
}

I can now clearly see all the registers and variables in Eclipse. 

Question 02: sys_sync doesn't seem to be called in the ARM arch files, it only exists for x86 and sparc architectures.

Is there any other kernel file I can set a break-point into, to be able to check if everything is working ok?

For example, if I type a normal cd or ls command? 

Best regards,

Elvis


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753925Ab2DBR4B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 13:56:01 -0400
Received: from server1.neighborhoods.net ([207.154.13.48]:33115 "EHLO
	server1.neighborhoods.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753273Ab2DBR4A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 13:56:00 -0400
X-Greylist: delayed 364 seconds by postgrey-1.27 at vger.kernel.org; Mon, 02 Apr 2012 13:56:00 EDT
Message-ID: <4F79E6BE.4030302@meetinghouse.net>
Date: Mon, 02 Apr 2012 13:49:50 -0400
From: Miles Fidelman <mfidelman@meetinghouse.net>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:11.0) Gecko/20120312 Firefox/11.0 SeaMonkey/2.8
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: QUESTION: reboot.c and X86-64 architectures
References: <S1753510Ab2DBRUx/20120402172053Z+301@vger.kernel.org>
In-Reply-To: <S1753510Ab2DBRUx/20120402172053Z+301@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Folks,

I hope this is an appropriate question here, I've exhausted other resources:

I've recently migrated from running a 32bit kernel to a 64bit one 
(specifically Debian Lenny 32bit environment to 2.6.32-5-xen-amd64 on 
top of xen-4.0-amd64 hypervisor build).

This is a somewhat older, and apparently quirky, hardware box.  I've 
found that the only way to reboot it, short of power cycling, is jumping 
through the bios - using the "reboot=bios" kernel option at boot time 
works just fine for an X86_32 kernel.  But... this doesn't work with the 
64bit kernel.

Pouring through both the documentation and the code for linux 
<http://lxr.linux.no/linux+*/>/arch 
<http://lxr.linux.no/linux+*/arch>/x86 
<http://lxr.linux.no/linux+*/arch/x86>/kernel 
<http://lxr.linux.no/linux+*/arch/x86/kernel>/reboot.c 
<http://lxr.linux.no/linux+*/arch/x86/kernel/reboot.c> yields the very 
specific admonition "bios Reboot by jumping through the BIOS (only for 
X86_32)", and the code seems to support this (though I haven't quite 
waded through all the paths that might execute machine_real_restart).

None of the other available command line options seem to work with this 
hardware, which leads to two questions:

1. What's the logic behind this?  Why not enable a bios reboot for 64bit 
kernels?

2. Anybody know a workaround, short of patching and compiling a custom 
kernel? (Note: None of the available command line options seem to work on
this particular box/bios combination, and kexec-reboot is not available 
for this combination of kernel and hypervisor).

Thank you very much,

Miles Fidelman

-- 
In theory, there is no difference between theory and practice.
In practice, there is.   .... Yogi Berra



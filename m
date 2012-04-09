Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757431Ab2DIPjg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 11:39:36 -0400
Received: from server1.neighborhoods.net ([207.154.13.48]:42022 "EHLO
	server1.neighborhoods.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753190Ab2DIPjf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 11:39:35 -0400
Message-ID: <4F8302B4.8040901@meetinghouse.net>
Date: Mon, 09 Apr 2012 11:39:32 -0400
From: Miles Fidelman <mfidelman@meetinghouse.net>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:11.0) Gecko/20120312 Firefox/11.0 SeaMonkey/2.8
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        peter.chubb@nicta.com.au, michael.d.labriola@gmail.com, mjg@redhat.com
Subject: reboot via bios on X86_64?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[cc'd to maintainers of reboot.c]

Re. the 2.6.32.5 kernel (currently used in Debian stable), and this 
seems to apply to
later ones as well:

The reboot code in arch/x86/kernel/reboot.c provides for rebooting 
through the bios
by either a kernel option of "reboot=bios" or as automatically invoked 
by quite
a few of the quirks case statements.

But... reboot=bios is  enabled only when configured for 32-bit mode - 
which just bit me
when I moved from a 32bit kernel to a 64bit one on an old P4 box, which 
hangs on
reboot for all reboot options except reboot=bios when running in 32 bit 
mode.

Which leads to two questions:

1. What's the logic behind this?  Why not enable a bios reboot for 64bit
kernels?  Is there any reason why the machine_real_restart code wouldn't
work just as well in 64bit mode?  Anybody know the history?

2. Anybody know a workaround, short of patching and compiling a custom
kernel? Are there other paths through the reboot code that can invoke a 
bios
reboot?  [Note: someone suggested trying a kexec-reboot, but that's also
not supported on my configuration (running over a Xen hypervisor).]

Thank you very much,

Miles Fidelman

-- 
In theory, there is no difference between theory and practice.
In practice, there is.   .... Yogi Berra



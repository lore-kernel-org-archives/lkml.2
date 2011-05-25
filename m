Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932832Ab1EYOTv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 10:19:51 -0400
Received: from host1743200242118.direcway.com ([174.32.118.242]:51354 "EHLO
	aexorsyst.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S932743Ab1EYOTu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 10:19:50 -0400
X-Greylist: delayed 303 seconds by postgrey-1.27 at vger.kernel.org; Wed, 25 May 2011 10:19:48 EDT
From: "John Z. Bohach" <jzb2@aexorsyst.com>
To: linux-kernel@vger.kernel.org
Subject: NO S5 poweroff with nfsroot (works with same kernel and same rootfs on local storage)
Date: Wed, 25 May 2011 07:12:07 -0700
User-Agent: KMail/1.9.6
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201105250712.07085.jzb2@aexorsyst.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I'm running Linux version 2.6.36.1 on an LFS (linuxfromscratch)-based 
distro. and am trying to get the host (AMD-athlon) to physically remove 
power (S5) on a 'halt -n -d -f -p' command issued from runstate "init 
1" from an NFS rootfs (and yes the eth0 rootfs mount is still up in my 
run-level 1).

The results are the kernel code is entered, the "md" device is shutdown, 
and the following:

pci 0000:00:07.0: wake-up cabability enabled by ACPI
ACPI: Preparing to enter system sleep state S5
Disabling non-boot CPU's
SMP alternatives: switching to UP code

Then it hangs, though after a few minutes, I still get some NFS timeout 
messages, though I can't tell which mount, probably the rootfs?

'reboot -n -d -f' does reset the machine from the same state.

The reason I'm posting this here is because when I run the SAME kernel 
and the SAME rootfs from a local disk (/dev/sda1), the system does 
power-off successfully.  I have some custom tweaks to the rc-scripts to 
allow running identical rootfs over NFS and local disk, but I try to 
rule out any runtime differences by restricting my question to 
run-level 1.

Both BIOS and kernel support ACPI and I've fixed the rootfs to run in 
r/o mode, and made some other customizations to allow proper shutdown 
for nfsroot, but to rule out all non-interesting things, I run the 
halt -n -d -f -p command from run-level 1, and I've even run some 
manual commands to kill off every process and every mount that was 
still around.  Obviously I can't kill the root mount over NFS and eth0 
is still up.

Is this supported or is the root cause between the keyboard and the 
chair?

Thanks,
John Z. Bohach

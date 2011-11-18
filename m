Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758054Ab1KRPDQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 10:03:16 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:38330 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757811Ab1KRPDP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 10:03:15 -0500
Message-ID: <4EC673B0.5050300@davidkrider.com>
Date: Fri, 18 Nov 2011 10:03:12 -0500
From: David Krider <david@davidkrider.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111116 Thunderbird/9.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Problems with sata_nv/ata since 2.6.37
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've seen problems with my disk subsystem since 2.6.37. I have a nForce 
780i-based mobo. I HAD a stripe of WDC WD740GD-00FLA1's (old Raptors) on 
fakeraid (shared with Windows). I thought this might be the problem, so 
I bought a (single) INTEL SSDSA2CW160G3 SSD, but the problems remain. So 
I have to conclude that the problem isn't fakeraid- or SSD-related.

These problems manifest themselves two ways. First, when I REBOOT my 
computer from Linux, it will come up to the BIOS, go to grub, proceed to 
EITHER Windows or Linux (again), and then spontaneously reboot when it 
gets to the point of mounting the OS. If I simply SHUT DOWN, and then 
power up the computer again, the BIOS will briefly pop up, and then the 
computer will again spontaneously reboot back into the BIOS.

Secondly, in Linux, I see these sorts of kernel errors in the log:

Nov  6 22:50:17 enterprise kernel: [ 1511.385491] ata1: EH in SWNCQ
mode,QC:qc_active 0x7 sactive 0x7
Nov  6 22:50:17 enterprise kernel: [ 1511.385496] ata1: SWNCQ:qc_active
0x6 defer_bits 0x1 last_issue_tag 0x2
Nov  6 22:50:17 enterprise kernel: [ 1511.385497]   dhfis 0x6 dmafis 0x6
sdbfis 0x1
Nov  6 22:50:17 enterprise kernel: [ 1511.385501] ata1: ATA_REG 0x41
ERR_REG 0x84
Nov  6 22:50:17 enterprise kernel: [ 1511.385503] ata1: tag : dhfis
dmafis sdbfis sacitve
Nov  6 22:50:17 enterprise kernel: [ 1511.385505] ata1: tag 0x1: 1 1 0 1
Nov  6 22:50:17 enterprise kernel: [ 1511.385508] ata1: tag 0x2: 1 1 0 1
Nov  6 22:50:17 enterprise kernel: [ 1511.385516] ata1.00: exception
Emask 0x1 SAct 0x7 SErr 0x0 action 0x6 frozen
Nov  6 22:50:17 enterprise kernel: [ 1511.385519] ata1.00: Ata error.
fis:0x21
Nov  6 22:50:17 enterprise kernel: [ 1511.385522] ata1.00: failed
command: READ FPDMA QUEUED
Nov  6 22:50:17 enterprise kernel: [ 1511.385528] ata1.00: cmd
60/08:00:50:b5:63/00:00:00:00:00/40 tag 0 ncq 4096 in
Nov  6 22:50:17 enterprise kernel: [ 1511.385529]          res
41/84:14:78:76:67/84:00:00:00:00/40 Emask 0x10 (ATA bus error)
Nov  6 22:50:17 enterprise kernel: [ 1511.385532] ata1.00: status: {
DRDY ERR }
Nov  6 22:50:17 enterprise kernel: [ 1511.385534] ata1.00: error: { ICRC
ABRT }
Nov  6 22:50:17 enterprise kernel: [ 1511.385536] ata1.00: failed
command: READ FPDMA QUEUED
Nov  6 22:50:17 enterprise kernel: [ 1511.385542] ata1.00: cmd
60/08:08:68:76:67/00:00:00:00:00/40 tag 1 ncq 4096 in
Nov  6 22:50:17 enterprise kernel: [ 1511.385543]          res
41/84:14:78:76:67/84:00:00:00:00/40 Emask 0x10 (ATA bus error)
Nov  6 22:50:17 enterprise kernel: [ 1511.385546] ata1.00: status: {
DRDY ERR }
Nov  6 22:50:17 enterprise kernel: [ 1511.385548] ata1.00: error: { ICRC
ABRT }
Nov  6 22:50:17 enterprise kernel: [ 1511.385550] ata1.00: failed
command: READ FPDMA QUEUED
Nov  6 22:50:17 enterprise kernel: [ 1511.385556] ata1.00: cmd
60/10:10:78:76:67/00:00:00:00:00/40 tag 2 ncq 8192 in
Nov  6 22:50:17 enterprise kernel: [ 1511.385557]          res
41/84:14:78:76:67/84:00:00:00:00/40 Emask 0x10 (ATA bus error)
Nov  6 22:50:17 enterprise kernel: [ 1511.385559] ata1.00: status: {
DRDY ERR }
Nov  6 22:50:17 enterprise kernel: [ 1511.385562] ata1.00: error: { ICRC
ABRT }
Nov  6 22:50:17 enterprise kernel: [ 1511.385566] ata1: hard resetting link
Nov  6 22:50:17 enterprise kernel: [ 1511.385568] ata1: nv: skipping
hardreset on occupied port
Nov  6 22:50:17 enterprise kernel: [ 1511.870025] ata1: SATA link up 3.0
Gbps (SStatus 123 SControl 300)
Nov  6 22:50:17 enterprise kernel: [ 1511.910210] ata1.00: configured
for UDMA/133
Nov  6 22:50:17 enterprise kernel: [ 1511.910228] ata1: EH complete


I created bug 40902 on bugzilla, but I haven't been able to get back 
there to check on it for a long time. I also opened bug #829413 on 
Launchpad, where it was confirmed, but since has lied dormant.

I've tried compiling various custom kernels to find out where the break 
occurred, and settled on post-.37 versions. The problem has twice caused 
me to need to fsck to get running again, but I've not actually lost 
anything (yet). I've stayed on Ubuntu 10.10 as this has a 2.6.35 kernel, 
and I never have any problems with that version.

I wanted to check to see if this problem had been resolved, so I tried 
compiling a 3.1.1. It's still there. In fact, it was so bad, grub marked 
the OS volume as read-only. I did some more research and tried "acpi=off 
noapic". This got me booted, but when I tried to actually do anything on 
the drive, I saw more of the errors I've included above.

I've seen a lot of comments about these KINDS of errors around, but 
nothing definitive by way of an answer. I'm just a punk, but I'm willing 
to try a git bisect to determine where the problem started, ***IF*** 
that's what needs doing (as I tried to gauge from the bug at Launchpad). 
Do you guys already know what's going on here? If it's a known issue, I 
can just wait for the fix. Is this something that you could use more 
info on? If so, I can do the legwork to get it.

Thanks for all you do!
dk

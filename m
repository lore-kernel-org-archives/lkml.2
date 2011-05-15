Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752109Ab1EOEn3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 00:43:29 -0400
Received: from qmta07.emeryville.ca.mail.comcast.net ([76.96.30.64]:52288 "EHLO
	qmta07.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751005Ab1EOEn2 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 00:43:28 -0400
X-Greylist: delayed 339 seconds by postgrey-1.27 at vger.kernel.org; Sun, 15 May 2011 00:43:28 EDT
From: "Michael Barton" <mgb@inyankara.org>
To: <linux-kernel@vger.kernel.org>
Subject: PROBLEM: kernel Oops during shutdown of 3.6.38 kernel on EFI system
Date: Sat, 14 May 2011 22:37:47 -0600
Message-ID: <021401cc12b9$d7961a10$0100a8c0@Canberra>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
X-Mailer: Microsoft Office Outlook 11
Thread-Index: AcwSudbcq7LeTROnQXGS3nijX/kClg==
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3664
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[1.] One line summary of the problem:  

During system shutdown, the kernel panics
  
[2.] Full description of the problem/report:

During system shutdown, the kernel dies and the machine locks up.  The
console shows:
* Restarting system.
BUG: unable to handle kernel paging request at .....
IP: ....
PGD 0
Oops: 0000 [#1] SMP
Last sysfs file:
/sys/devices/pci0000:00/0000:00:1d.o/usb2/2-1/2-1.2:1.1/bInterfaceClass
CPU 0
Modules linked in:
Pid: 1278, comm, reboot Not tainted 2.6.38-8-generic #42-Ubuntu Gateway
FX6850/FX6580
...
Call Trace:
console_unlock
duwn_trylock
efi_call4
default_spin_lock_flags
virt_efi_reset_system
native_machine_emergency_restart
disable_IO_APIC
natice_machine_restart
...
do_page_fault
iterate_supers
system_call_fastpath

[3.] Keywords (i.e., modules, networking, kernel):

Kernel restart

[4.] Kernel version (from /proc/version):

Linux version: 2.6.38-8-generic - gcc version 4.5.2 #42 Ubuntu

[5.] Output of Oops.. message (if applicable) with symbolic information 
     resolved (see Documentation/oops-tracing.txt)

Oops: 0000 [#1] SMP

[6.] A small shell script or example program which triggers the
     problem (if possible)

'/sbin/shutdown -r now'

[7.] Environment
[7.1.] Software (add the output of the ver_linux script here)
[7.2.] Processor information (from /proc/cpuinfo):

Processor: 7 
Vendor_id: GenuineIntel
Cpu family : 6
Model: 42
Model name: Intel(R) Core(TM) i7-2600 CPU @ 3.40GHz
...
Address sizes : 36 bits physical, 48 bits virtual

[7.3.] Module information (from /proc/modules):
[7.4.] Loaded driver and hardware information (/proc/ioports, /proc/iomem)
[7.5.] PCI information ('lspci -vvv' as root)
[7.6.] SCSI information (from /proc/scsi/scsi)
[7.7.] Other information that might be relevant to the problem
       (please look in /proc and include all information that you
       think to be relevant):
[X.] Other notes, patches, fixes, workarounds:

I have installed Ubuntu 11.04 on a GPT partition, on a Gateway FX6850.
i7-2600, H67 chipset.  I installed and boot in EFI mode.

The problem is 100% reproducible, so let me know what additional details you
need, and I can acquire them.

Michael

--- 
 
Michael Barton
Engineering Software Solutions, Inc.
303-948-6199
mgb@inyankara.org


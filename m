Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756707Ab0DEV41 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 17:56:27 -0400
Received: from mail-pz0-f136.google.com ([209.85.222.136]:50897 "EHLO
	mail-pz0-f136.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756545Ab0DEV4V convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 17:56:21 -0400
X-Greylist: delayed 1082 seconds by postgrey-1.27 at vger.kernel.org; Mon, 05 Apr 2010 17:56:21 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=EWmKDL8UVBSdmDdYU9D3w+lPO6htHcXmNpoU/feyqcViLnWdzfLecuNcdexyYepLrz
         l+L2CErVgOd/7um2EnBMLSESGZI1NG0FMxEYbXVpLMUySPSyoy4FSn7g6us2Sa/3bqx4
         8FdWqctKaBpm6T6QAELdM5Ucn6MjqiegrQoXw=
MIME-Version: 1.0
In-Reply-To: <l2v8f84f9951004051430ic196f0e0r3230884afe515187@mail.gmail.com>
References: <l2v8f84f9951004051430ic196f0e0r3230884afe515187@mail.gmail.com>
Date: Mon, 5 Apr 2010 14:38:19 -0700
Message-ID: <h2k8f84f9951004051438ue340cab0yb8ce0eec7f76b6a@mail.gmail.com>
Subject: Fwd: request help in analyze this kdb data on 2.6.20-17.39 kernel
From: Frank Hu <frank.hu.2001@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---------- Forwarded message ----------
From: Frank Hu <frank.hu.2001@gmail.com>
Date: Mon, Apr 5, 2010 at 2:30 PM
Subject: request help in analyze this kdb data on 2.6.20-17.39 kernel
To: linux-kernel@vger.kernel.org



I have a Ubuntu 7.4 system (2.6.20-17.39 kernel). The processor is a
dual-core T7300 and 4GB memory. The kernel has kdb patched to it.
After the device was rebooted, it entered the kdb  prompt because of
NULL pointer access in kernel space. So that's good -- it's what I
expected.

One problem confusing me is the inconsistent stack traces from "bt"
command and "dmesg" command. They should be showing the same stack
trace, if I understand them correctly.

Another question is that I do not see the function "shrink_all_memory"
was invoked from "filp_close". Could that function "shrink_all_memory"
come from kdb?

not quite experienced with kdb on linux... So will appreciate your
feedback if any.

Frank


[0]kdb>
[0]kdb> bt
Stack traceback for pid 5753
0x5fd28a70     5753     5515  1    0   R  0x5fd28c20 *sleep
esp        eip        Function (args)
0xf5de7f00 0x4015007b shrink_all_memory+0x1ab
0xf5de7f10 0x40163de1 filp_close+0x21
0xf5de7f30 0x4011ed55 put_files_struct+0x95
0xf5de7f4c 0x4011fdf5 do_exit+0x135
0xf5de7f98 0x401204d9 do_group_exit+0x29
0xf5de7fac 0x4012053f sys_exit_group+0xf
0xf5de7fb4 0x401030f6 sysenter_past_esp+0x5f
[0]kdb> dmesg 50
...
<1>[  201.250000] BUG: unable to handle kernel paging request at
virtual address f9560f94
<1>[  201.250000]  printing eip:
<4>[  201.250000] 40163de1
<1>[  201.250000] *pde = 00000000
<0>[  201.250000] Oops: 0000 [#1]
<0>[  201.250000] SMP
[0]more>
<4>[  201.250000] Modules linked in: 8021q iptable_filter ip_tables
x_tables ip_gre i2c_dev i2c_qs i2c_algo_bit dev_acpi video battery
asus_acpi container ac dock button sbs i2c_ec i2c_core backlight
af_packet parport_pc lp parport ixgbe tpm_infineon tpm tpm_bios evdev
psmouse serio_raw shpchp pci_hotplug pcspkr ext3 jbd mbcache sg sd_mod
ata_generic ahci libata scsi_mod generic ehci_hcd uhci_hcd usbcore
thermal processor fan
<0>[  201.250000] CPU:    0
<0>[  201.250000] EIP:    0060:[<40163de1>]    Tainted: PF     VLI
<0>[  201.250000] EFLAGS: 00210286   (2.6.20-17.39-procurve9 #1)
<0>[  201.250000] EIP is at filp_close+0x21/0x70
<0>[  201.250000] eax: f9560f60   ebx: f5fe4f00   ecx: f5fe4f00   edx: 5fd91680
<0>[  201.250000] esi: 5fd91680   edi: 00000000   ebp: f5de7f2c   esp: f5de7f1c
<0>[  201.250000] ds: 007b   es: 007b   ss: 0068
<0>[  201.250000] Process sleep (pid: 5753, ti=f5de6000 task=5fd28a70
task.ti=f5de6000)
<0>[  201.250000] Stack: 5fcb65c8 0000000f 5dc8d720 00000000 f5de7f48
4011ed55 5fd91680 00000014
<0>[  201.250000]        5fd91680 5fd28a70 00000001 f5de7f94 4011fdf5
00000000 5de72508 00000014
<0>[  201.250000]        00000000 0000804c f5de7fb8 5fd28f14 5fd28a70
00000000 37eed1e4 5dc0d480
<0>[  201.250000] Call Trace:
<0>[  201.250000]  [<4010477a>] show_trace_log_lvl+0x1a/0x30
<0>[  201.250000]  [<40104841>] show_stack_log_lvl+0xb1/0xe0
<0>[  201.250000]  [<40104a31>] show_registers+0x1c1/0x2b0
<0>[  201.250000]  [<40104c30>] die+0x110/0x2c0
<0>[  201.250000]  [<402e16f2>] do_page_fault+0x372/0x6d0
<0>[  201.250000]  [<402dfb3c>] error_code+0x7c/0x90
<0>[  201.250000]  [<4011ed55>] put_files_struct+0x95/0xa0
<0>[  201.250000]  [<4011fdf5>] do_exit+0x135/0x7f0
<0>[  201.250000]  [<401204d9>] do_group_exit+0x29/0x80
<0>[  201.250000]  [<4012053f>] sys_exit_group+0xf/0x20
[0]more> \
Only 'q' or 'Q' are processed at more prompt, input ignored
<0>[  201.250000]  [<401030f6>] sysenter_past_esp+0x5f/0x89
<0>[  201.250000]  =======================
<0>[  201.250000] Code: eb fe 90 8d b4 26 00 00 00 00 55 89 e5 83 ec
10 89 5d f4 89 c3 89 75 f8 89 d6 89 7d fc 8b 40 14 85 c0 74 46 8b 43
10 85 c0 74 35 <8b> 48 34 85 c9 74 2e 89 d8 ff d1 89 c7 89 f2 89 d8 e8
19 41 03
<0>[  201.250000] EIP: [<40163de1>] filp_close+0x21/0x70 SS:ESP 0068:f5de7f1c
<4>[  201.250000]
[0]kdb>
[0]kdb>
[0]kdb> cpu 0


Entering kdb (current=0x5fd28a70, pid 5753) on processor 0 due to cpu switch
[0]kdb> cpu 1


Entering kdb (current=0x47baa550, pid 0) on processor 1 due to cpu switch
[1]kdb> bt
Stack traceback for pid 0
0x47baa550        0        1  1    1   I  0x47baa700 *swapper
esp        eip        Function (args)
0x47b4ff4c 0xf8814fc8 [processor]acpi_processor_idle+0x1ed
0x47b4ff74 0x401013ab cpu_idle+0x3b
0x47b4ff84 0x403da390 start_secondary+0x2f0
[1]kdb> cpu 0


Entering kdb (current=0x5fd28a70, pid 5753) on processor 0 due to cpu switch
[0]kdb> %eip
%eip = 0x40163de1 (filp_close+0x21)
[0]kdb> %esp
%esp = 0xf5de7f1c
[0]kdb> %ebp
%ebp = 0xf5de7f2c
[0]kdb> md %ebp
0xf5de7f2c f5de7f48 4011ed55 5fd91680 00000014   H...U..@..._....
0xf5de7f3c 5fd91680 5fd28a70 00000001 f5de7f94   ..._p.._........
0xf5de7f4c 4011fdf5 00000000 5de72508 00000014   ...@.....%.]....
0xf5de7f5c 00000000 0000804c f5de7fb8 5fd28f14   ....L.........._
0xf5de7f6c 5fd28a70 00000000 37eed1e4 5dc0d480   p.._.......7...]
0xf5de7f7c 5fd91680 00000000 f5de7f9c 47bac080   ..._...........G
0xf5de7f8c 00000000 37f98294 f5de7fa8 401204d9   .......7.......@
0xf5de7f9c 00000000 37f98294 37f98294 f5de7fb0   .......7...7....
[0]kdb> 0x4011ed554011ed55
[0]kdb> 0x4011ed554011ed5
[0]kdb> 0x4011ed554011ed
[0]kdb> 0x4011ed554011e
[0]kdb> 0x4011ed554011
[0]kdb> 0x4011ed55401
[0]kdb> 0x4011ed5540
0x4011ed55 = 0x4011ed55 (put_files_struct+0x95)

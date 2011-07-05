Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753402Ab1GEFEJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 01:04:09 -0400
Received: from linux.securehostdns.com ([174.36.253.246]:41668 "EHLO
	linux.securehostdns.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753299Ab1GEFEG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 01:04:06 -0400
X-Greylist: delayed 16185 seconds by postgrey-1.27 at vger.kernel.org; Tue, 05 Jul 2011 01:04:05 EDT
MIME-Version: 1.0
Date: Tue, 5 Jul 2011 10:34:03 +0530
Message-ID: <BANLkTim5EUP5J4xTTy-hBc8+tZbAzU8swg@mail.gmail.com>
Subject: mwait_idle_with_hints() causes NMI lockups
From: Tomar <tomar@linuxsmiths.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - linux.securehostdns.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - linuxsmiths.com
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
      I observed the following crash on my Dell R310 machine. It crashes quite
frequently with similar backtrace. The server is not running any load and is
mostly idling. The kernel version is 2.6.32.

>>>>>>>>>>>> snip <<<<<<<<<<<<<<<

[ 4997.164914] BUG: NMI Watchdog detected LOCKUP on CPU1, ip
ffffffff8101a399, registers:
[ 4997.165025] CPU 1
[ 4997.165121] Modules linked in: netconsole configfs xfrm_user
xfrm4_tunnel tunnel4 ipcomp xfrm_ipcomp esp4 ah4 deflate zlib_deflate
ctr twofish twofish_common camellia serpent blowfish cast5 des_generic
cryptd aes_x86_64 aes_generic xcbc rmd160 sha256_generic sha1_generic
crypto_null af_key bonding xfs exportfs joydev usbhid hid igb dca
e1000e sctp crc32c libcrc32c dell_wmi 8021q dcdbas garp stp
power_meter tcp_westwood tcp_veno tcp_vegas tcp_hybla bnx2 lp parport
[ 4997.167856] Pid: 0, comm: swapper Not tainted 2.6.32-27-server-test
#0test2 PowerEdge R310
[ 4997.167968] RIP: 0010:[<ffffffff8101a399>]  [<ffffffff8101a399>]
mwait_idle_with_hints+0x99/0xf0
[ 4997.168109] RSP: 0018:ffff88013baffe48  EFLAGS: 00000046
[ 4997.168217] RAX: 0000000000000020 RBX: 0000000000000020 RCX: 0000000000000001
[ 4997.168290] RDX: 0000000000000000 RSI: ffff88013bafffd8 RDI: 0000000000000000
[ 4997.168363] RBP: ffff88013baffe68 R08: 0000000000000000 R09: 0000000000000060
[ 4997.168435] R10: 0000048d19b9c2bd R11: 0000000000000000 R12: 0000000000000001
[ 4997.168508] R13: 0000000000000003 R14: 0000000000000000 R15: 0000000000000000
[ 4997.168581] FS:  0000000000000000(0000) GS:ffff88000d620000(0000)
knlGS:0000000000000000
[ 4997.168724] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[ 4997.168795] CR2: 00007f03388da000 CR3: 0000000001001000 CR4: 00000000000006e0
[ 4997.168867] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 4997.168940] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 4997.169013] Process swapper (pid: 0, threadinfo ffff88013bafe000,
task ffff88013baf44a0)
[ 4997.169153] Stack:
[ 4997.169216]  ffff880139e09530 ffff880139e09000 122be5d25988d251
0000000000000000
[ 4997.169427] <0> ffff88013baffe78 ffffffff8102c9c2 ffff88013baffe88
ffffffff8130e6e6
[ 4997.169741] <0> ffff88013baffee8 ffffffff8130ea04 ffff88013baffea8
ffffffff81088718
[ 4997.170115] Call Trace:
[ 4997.170182]  [<ffffffff8102c9c2>] acpi_processor_ffh_cstate_enter+0x32/0x40
[ 4997.170310]  [<ffffffff8130e6e6>] acpi_idle_do_entry+0x15/0x67
[ 4997.170382]  [<ffffffff8130ea04>] acpi_idle_enter_bm+0x20b/0x2c8
[ 4997.170456]  [<ffffffff81088718>] ? hrtimer_start+0x18/0x20
[ 4997.170529]  [<ffffffff81551f96>] ? notifier_call_chain+0x16/0x80
[ 4997.170602]  [<ffffffff814437dd>] ? menu_select+0x10d/0x2a0
[ 4997.170673]  [<ffffffff81442717>] cpuidle_idle_call+0xa7/0x140
[ 4997.170746]  [<ffffffff81010e63>] cpu_idle+0xb3/0x110
[ 4997.170817]  [<ffffffff81547086>] start_secondary+0xa8/0xaa
[ 4997.170887] Code: 8b 34 25 c8 cb 00 00 48 89 d1 48 8d 86 38 e0 ff
ff 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75 09 48 89 d8 4c 89
e1 0f 01 c9 <48> 8b 1c 24 4c 8b 64 24 08 4c 8b 6c 24 10 4c 8b 74 24 18
c9 c3

>>>>>>>>>>>> snip <<<<<<<<<<<<<<<

I investigated this and here are my findings.

The crash is due to the NMI watchdog detecting lockup on this CPU. The
EFLAGS value 0x46 indicates that the interrupts are indeed disabled.
The cpu was running the idle loop and as a result had executed the MWAIT
instruction waiting to be woken up if any other cpu writes to the need_resched
flag. This is fine.

What I fail to understand is that, the mwait_idle_with_hints() functions calls
MWAIT with interrupts disabled. This means that the CPU will not handle any
interrupts till the MWAIT itself is woken up and that can only happen when
there is a write to the MONITORed region (the need_resched flag in our case).
The other reason for wakeup could be interrupts but they are disabled.

What if in a completely idle system, there is no activity and the CPU is not
woken up from MWAIT, for say 5 secs. This is bound to cause NMI lockups ?
Also, the processor will not be able to handle any interrupts till then, which
appears bad.

My question is : Why does mwait_idle_with_hints() explicitly call __mwait()
and not __sti_mwait() ?

I might be missing something here, as this code has been there for very long
and I guess it should be working fine. Even google also does not show
many such incidents.

I looked up the Intel manual and here is a relevant bit from the MWAIT
description.

"A store to the address range set by the MONITOR instruction, an interrupt,
NMI, SMI, a debug exception, a machine check exception, the BINIT# signal, the
INIT# signal, or the RESET# signal will exit the optimized state. Note that an
interrupt will cause the processor to exit the optimized state only if the
state was entered with interrupts enabled."

So, if the interrupts are not enabled, the only way a processor in MWAIT can
come out of the sleep is by some other processor writing to the MONITORed
region or an NMI.

Are other people seeing similar lockups ?

Thanks,
Tomar

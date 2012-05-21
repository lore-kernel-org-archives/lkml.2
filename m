Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754885Ab2EUGwW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 02:52:22 -0400
Received: from nm24-vm0.bullet.mail.bf1.yahoo.com ([98.139.213.161]:25031 "HELO
	nm24-vm0.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751352Ab2EUGwU convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 02:52:20 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 609645.6788.bm@omp1036.mail.bf1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Message-ID:Date:From:Reply-To:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=cpWC99MsjaDy6GK6Zr/4ogXKCyMXiDfr5OFMi/iePYG56xMKgrRfNRWP3HAOc/pexDwia7HCMREzb3NyXlwLOt4bzQjRikvTulJBmAyXg1J6Tr0XjXOoD124aCRXFmchs0EtIyrAAQzkgcUb5I19ImAl+3ie3MbbbQ1chgjTU04=;
X-YMail-OSG: Z7Gzwc8VM1kSqkJfd0_TjOtZ1Al.tnA0GhL4sT81.gIToTA
 .Dn5d.wasmwDL_.0qaCuayrRYfHl1NICpAyQAvkYhcChZBUPCsrhtP9UNyXO
 rCVTAjWhvu2ryjXq1UTBsm1a4dmZR.vBt39u9BMtq48ApARB3rYNpi6zgVJd
 3OLlwT.YSMOvdSSH_Fgfe9vnnbjHvx492pp5Ispczl8GnjVkvsyb04ZoWDRE
 yPEyYlQMLeQ5EfIuMekr7RTCCgVThzBWjZQfsNv46_CF4lYTGPq3xP7jmbXO
 fAvFE9GOSARKpzZFyuL7_KHnBNljamapT_ggtpLraCmC4vrnqjIAuKLgKco4
 kg4mX.JUBiPDVOTH6ooMNdqujndcJ9T0.5PedSDQtqbsFIgav4eWNZptEEN6
 n4tLDKa5u7Qa1coctOXNfdyeE7_kCjqwVvGT_Nng9wQOOWt3GHZbTgSClfH2
 O_769ws_wF4NBYohgGaJ2qw30k61CA8erqOoO92D8r1VjDguzKE20N8c_99s
 zflcZD7ltcKnrULhk6ESpVcAY.J1WgmKYUQW35odFyTD79RMmlsXXXfYixOh
 nUw6rSIcfQPty2GKdfif6ZEHGNN9Fx9I7zZjJc6Tbmn052V3HkE1hNHtSkpl
 kBauFQn9zAcNi2wehEIdQDy.lWIkP9TcnL5ddh0eNq06UA.N1601DIqASR_3
 WOGCt11pK2CZHA42d7UoMzqFK0aLHCYUqDx5gvB9DMbzCtuX08oBTjuOx5n2
 ev7gpq397_r9JAqhr_1UaWJkUmISPmanlBDnF8NQrsOgCYHzqxF4P3WyFdSP
 1P5jkkHylLWkOBpFl8qrusxY5.xZnIKt9BzhlroZq_mkrTFmjoM4mBtlskPE
 wcdtepA4BLZa4wPEh3HZQ39lhECmoKrHn7lKP3ajcYCNN63oYB5QKW._1QQN
 a26tOuGxicPpssKe0oaHCbKvibjl7tw--
X-Mailer: YahooMailWebService/0.8.118.349524
Message-ID: <1337583139.52527.YahooMailNeo@web161806.mail.bf1.yahoo.com>
Date: Sun, 20 May 2012 23:52:19 -0700 (PDT)
From: Mikko Vinni <mmvinni@yahoo.com>
Reply-To: Mikko Vinni <mmvinni@yahoo.com>
Subject: uswsusp and plymouth don't play nice together
To: "plymouth@lists.freedesktop.org" <plymouth@lists.freedesktop.org>,
        "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Rabin Vincent <rabin@rab.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

has any uswsusp[1] (aka suspend-utils) or plymouth[2] developer tested the
two together? It seems there is a hang during resume from s2disk, and the
resume can be continued by pressing ALT-SysRq-K or ALT-SysRq-E.

This is not hardware specific neither new. For example, there is a bug report
for Debian[3] opened in 2010 (don't get confused by the reference to the
blinking fb cursor bug). Personally, I have tested on Ubuntu 12.04 and
Arch Linux (stable and some rc kernel versions for some months now).
Easily reproduced also in a virtual machine, without graphical splash.

The hang does not occur if using the in-kernel hibernation, nor when
not starting plymouth before resume.

ALT-SysRq-T shows this backtrace for the 'plymouthd' and 'resume' processes:

[   51.853427] plymouthd       D 0000000000000000     0    55      1 0x00000004 
[   51.853427]  ffff88000da6fd18 0000000000000086 ffff88000da58000 ffff88000da6ffd8 
[   51.853427]  ffff88000da6ffd8 ffff88000da6ffd8 ffff88000da59000 ffff88000da58000 
[   51.853427]  0000000000000000 ffff88000da58490 ffff88000da6fc78 ffff88000d9bd500 
[   51.853427] Call Trace: 
[   51.853427]  [<ffffffff8107d879>] ? finish_task_switch+0x49/0xd0 
[   51.853427]  [<ffffffff8145daa1>] ? __schedule+0x431/0x900 
[   51.853427]  [<ffffffff8145e0af>] schedule+0x3f/0x60 
[   51.853427]  [<ffffffff8109b9b3>] __refrigerator+0x43/0xe0 
[   51.853427]  [<ffffffff810bdb72>] ? cgroup_freezing+0x32/0x40 
[   51.853427]  [<ffffffff8106499d>] get_signal_to_deliver+0x56d/0x600 
[   51.853427]  [<ffffffff8118687c>] ? destroy_inode+0x3c/0x70 
[   51.853427]  [<ffffffff81014278>] do_signal+0x68/0x750 
[   51.853427]  [<ffffffff811b04f1>] ? ep_poll+0x2a1/0x360 
[   51.853427]  [<ffffffff811b09ed>] ? sys_epoll_ctl+0xad/0x850 
[   51.853427]  [<ffffffff8116dfeb>] ? fput+0x16b/0x210 
[   51.853427]  [<ffffffff810149e5>] do_notify_resume+0x65/0x80 
[   51.853427]  [<ffffffff81460122>] int_signal+0x12/0x17
[   51.853427] resume          S ffff88000da593c8     0    57      1 0x00000000 
[   51.853427]  ffff88000da5fd48 0000000000000082 ffff88000da59000 ffff88000da5ffd8 
[   51.853427]  ffff88000da5ffd8 ffff88000da5ffd8 ffffffff8180d020 ffff88000da59000 
[   51.853427]  ffff88000da59000 ffff88000da5ffd8 ffff88000da5ffd8 ffff88000da5ffd8 
[   51.853427] Call Trace: 
[   51.853427]  [<ffffffff8108014c>] ? ttwu_do_wakeup+0x2c/0x120 
[   51.853427]  [<ffffffff8145eed8>] ? _raw_spin_unlock_irqrestore+0x38/0x50 
[   51.853427]  [<ffffffff8145e0af>] schedule+0x3f/0x60 
[   51.853427]  [<ffffffff812e20f7>] vt_event_wait+0xa7/0x130 
[   51.853427]  [<ffffffff81072570>] ? abort_exclusive_wait+0xb0/0xb0 
[   51.853427]  [<ffffffff812e225d>] vt_waitactive+0x2d/0x60 
[   51.853427]  [<ffffffff8145cc26>] ? mutex_lock+0x16/0x30 
[   51.853427]  [<ffffffff812e4886>] vt_move_to_console+0x56/0xc0 
[   51.853427]  [<ffffffff81094388>] pm_prepare_console+0x18/0x40 
[   51.853427]  [<ffffffff81095974>] hibernation_restore+0x14/0x130 
[   51.853427]  [<ffffffff8109afe8>] snapshot_ioctl+0x218/0x4a0 
[   51.853427]  [<ffffffff8117e787>] do_vfs_ioctl+0x97/0x530 
[   51.853427]  [<ffffffff8118ae14>] ? mntput+0x24/0x40 
[   51.853427]  [<ffffffff8116dfeb>] ? fput+0x16b/0x210 
[   51.853427]  [<ffffffff8117ecb9>] sys_ioctl+0x99/0xa0 
[   51.853427]  [<ffffffff8145fe69>] system_call_fastpath+0x16/0x1b 


Does plymouthd register to listen for console change, or something else
that it can't do while refrigerated?

There was on May 18th a patch proposed for the vt_event_wait() function[4],
but that patch has no effect for this particular hang.

Apparently Mandriva has a patch[5] to add plymouth support to uswsusp, but one
would assume that s2disk/resume should not hang in its default state.

Any ideas?


Mikko

--
[1] http://suspend.sourceforge.net/
[2] http://cgit.freedesktop.org/plymouth/
[3] http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=593795
[4] "Race in vt_event_wait() during suspend/resume": http://article.gmane.org/gmane.linux.kernel/1299487
[5] changelog e.g.: http://rpmfind.net//linux/RPM/mandriva/2011/x86_64/media/main/release/suspend-0.8-12.20080612.x86_64.html

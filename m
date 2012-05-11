Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932149Ab2EKCVd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 22:21:33 -0400
Received: from nm3-vm0.bullet.mail.bf1.yahoo.com ([98.139.212.154]:30610 "HELO
	nm3-vm0.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756295Ab2EKCVb convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 22:21:31 -0400
X-Greylist: delayed 406 seconds by postgrey-1.27 at vger.kernel.org; Thu, 10 May 2012 22:21:30 EDT
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 767433.24331.bm@omp1055.mail.bf1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Message-ID:Date:From:Reply-To:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=ox/hHlzGeUO72VJ+U3sTf9yALFuJTav+PwcZkdbkAkZR+XQQXo1yg7fv3zDm24Q9/fsBeOkatnZWOiLkMunhQhl5ZdjHI2dZHJIP5N7SzVZl4rWTaZqlNupxzLO55yQNSrY+C4ZVunb63HK9N9sjI5DgiFx3IpCoxVfZEcGfqtQ=;
X-YMail-OSG: yEaI248VM1mb8Hx8VtYJj0YCCJP6.tdkrLCcIdSHWiyf_UF
 vWmzDBzg7lHztvpEA_XJOxf3EIVY7_lScseSzo3.BShzA.JHCzajX5vKXVY2
 2K5N5TfTQWKP0b1RtvDSQSA8DWcvG3UEEuLD1UtArAUTk2Mt023LCkpBCG1d
 CW8ZkN0aGbDKlMZA1EYdmhIiJJJPuKaBAtXjmes0QZyPCWQR.YTXMGfz5_o5
 393CwDfDqX89ltKMNkhJYR3nznhKTjFP9Vn57xNRICLmm2bOspIukRfQ6_dF
 Q.S9z1zCXRYxg0DXjmud2Ewt_07BZOAjXhJ2StRF8OBU7uYFWx5YhT46RGO3
 zD7jZRtQfTSTDj3ac7CDyiWwsb7u8B4W7N7ozRNjWq03VaVIHpZ2ayNRdtYW
 qtFROhG0qObL1CTy9yGWJlU5VY_HgZL2d3TqlDw8YJj7Jksqqd0ZYzXft7Q5
 2M.qaa3HfoPgkh10oabcWBR_Z3OK4JxrhZPD6vDGgQcMVG98LLb4df7Acyxf
 prNbmJPZbjZcYZjo4QggQMptH1.AEkYDrT5PIwfFNjNd6QLIiUIopQV99h7H
 qIwk-
X-Mailer: YahooMailWebService/0.8.118.349524
Message-ID: <1336702483.88676.YahooMailNeo@web160804.mail.bf1.yahoo.com>
Date: Thu, 10 May 2012 19:14:43 -0700 (PDT)
From: joe shmoe <joeshmoeypeter@yahoo.com>
Reply-To: joe shmoe <joeshmoeypeter@yahoo.com>
Subject: rcu_sched_state detected stall (serial 8250 wait_for_xmitr)
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "joeshmoeypeter@yahoo.com" <joeshmoeypeter@yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am relatively a newbie in kernel matters, so please be gentle. I am trying to learn things.

I am using non-tained 2.6.35.14 kernel and hitting a CPU stall that is reproducible whenever I send a lot of data through the serial console (klogd -2 -c 7). 

I've tried looking through the changelog and don't find any patch that directly addresses this (it is my understanding 

that RCU has changed quite a bit since 2.6.35.14 though).

Could someone please suggest how to go about debugging this further, or what more information I can provide for the community to understand what the potential issue here might be?

I referenced stallwarn.txt and turned on CONFIG_PROVE_RCU, CONFIG_TRACE_RCU and related config flags, recompiled and reproduced the issue. The stack trace seems to indicate the trouble is in this loop which loops for only 10ms:

http://lxr.linux.no/linux+*/drivers/serial/8250.c#L1860

[  481.553694]
[  481.553697] Pid: 142, comm: rcu_torture_rea Not tainted 2.6.35-14EIsmp g6os X8DTH/X8DTH-i/6/iF/6F
[  481.553699] RIP: 0010:[<ffffffff812146a7>]  [<ffffffff812146a7>] delay_tsc+0x2f/0x4f
[  481.553704] RSP: 0018:ffff880002c43a88  EFLAGS: 00000087
[  481.553706] RAX: 0000000000000128 RBX: ffffffff82a5c8c0 RCX: 0000000000000002
[  481.553708] RDX: 0000000000000184 RSI: 0000000000000002 RDI: 00000000000009e6
[  481.553709] RBP: ffff880002c43a90 R08: 00000000ad22a044 R09: ffffffff81293821
[  481.553711] R10: ffffffff81db0754 R11: 0000000000000000 R12: 0000000000000000
[  481.553713] R13: 0000000000002709 R14: 0000000000000020 R15: 000000000000002e
[  481.553715] FS:  0000000000000000(0000) GS:ffff880002c40000(0000) knlGS:0000000000000000
[  481.553717] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  481.553718] CR2: 00007f9473337830 CR3: 000000022a734000 CR4: 00000000000006e0
[  481.553720] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  481.553722] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  481.553724] Process rcu_torture_rea (pid: 142, threadinfo ffff88013eae6000, task ffff88013eabf000)
[  481.553725] Stack:
[  481.553726]  0000000000000000 ffff880002c43aa0 ffffffff81214635 ffff880002c43ab0
[  481.553728] <0> ffffffff81214676 ffff880002c43ae0 ffffffff81291b7b ffffffff82a5c8c0
[  481.553731] <0> 000000000000000a ffffffff81291bc6 ffffffff82a5c8c0 ffff880002c43b00
[  481.553734] Call Trace:
[  481.553735]  <IRQ>
[  481.553737]  [<ffffffff81214635>] __delay+0xa/0xc
[  481.553739]  [<ffffffff81214676>] __const_udelay+0x3f/0x41
[  481.553743]  [<ffffffff81291b7b>] wait_for_xmitr+0x56/0xa1
[  481.553745]  [<ffffffff81291bc6>] ? serial8250_console_putchar+0x0/0x34
[  481.553748]  [<ffffffff81291be5>] serial8250_console_putchar+0x1f/0x34
[  481.553750]  [<ffffffff8128e78b>] uart_console_write+0x41/0x52
[  481.553753]  [<ffffffff8129387c>] serial8250_console_write+0xb2/0x116
[  481.553755]  [<ffffffff8103e4dd>] __call_console_drivers+0x67/0x79
[  481.553758]  [<ffffffff8103e54a>] _call_console_drivers+0x5b/0x5f
[  481.553760]  [<ffffffff8103e937>] release_console_sem+0x12a/0x1c5
[  481.553762]  [<ffffffff8103efaf>] vprintk+0x373/0x3a3
[  481.553765]  [<ffffffff8103f046>] ? printk+0x67/0x69
[  481.553767]  [<ffffffff8103f046>] printk+0x67/0x69
[  481.553771]  [<ffffffff8106597e>] ? trace_hardirqs_on+0xd/0xf
[  481.553790]  [<ffffffffa012e2d2>] ? debug_print_prefix+0x135/0x146 [scst]
[  481.553802]  [<ffffffffa010b6a3>] scst_cmd_done_local+0xc3/0x280 [scst]
[  481.553807]  [<ffffffffa0199d61>] blockio_endio+0xcf/0xee [scst_vdisk]

This gdb is from an earlier run (but same loops is responsible all the time).

(gdb) list *(wait_for_xmitr+0x56)
0x5ae is in wait_for_xmitr (drivers/serial/8250.c:1863).
1858    {
1859            unsigned int status, tmout = 10000;
1860
1861            /* Wait up to 10ms for the character(s) to be sent. */
1862            do {
1863                    status = serial_in(up, UART_LSR);
1864
1865                    up->lsr_saved_flags |= status & LSR_SAVE_FLAGS;
1866
1867                    if (--tmout == 0)
(gdb)Thank you for any help.
Regards.

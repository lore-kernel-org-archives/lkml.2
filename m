Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760436Ab2FDM3S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 08:29:18 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:44661 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760156Ab2FDM3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 08:29:16 -0400
Date: Mon, 4 Jun 2012 14:29:30 +0200
From: Fredrik Gustafsson <iveqy@iveqy.com>
To: linux-kernel@vger.kernel.org
Subject: Oops 817, pjslib
Message-ID: <20120604122930.GA23095@paksenarrion.iveqy.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
when running pj_init from pjlib (an open source VoIP implementation) I
got an Oops. This is on an ARM AT91sam20 using glibc. An other
version of the system with mixed glibc and uclibc and the same
kernel, does not result in an oops.

The kernel runned is:
linux-2.6.27-rc8-at91-exp

This is from dmesg:

atmel_ssc_startup: SSC_SR=0x204
atmel_ssc_dau: Stopping clock c02aa690
atmel_ssc_startup: SSC_SR=0x204
atmel_ssc_dau: Stopping clock c02aa690
Unable to handle kernel NULL pointer dereference at virtual address
00000000
pgd = c0ed8000
[00000000] *pgd=20e47031, *pte=00000000, *ppte=00000000
Internal error: Oops: 817 [#1]
Modules linked in:
CPU: 0    Not tainted  (2.6.27-rc8-at91-exp-svn190-dirty686 #4)
PC is at __clk_disable+0x18/0x60
LR is at clk_disable+0x1c/0x24
pc : [<c002a2d4>]    lr : [<c002a338>]    psr: 60000093
sp : c038de80  ip : c038de98  fp : c038de94
r10: c02b9f48  r9 : c02b9d70  r8 : c02b9e38
r7 : c02b9dd8  r6 : 00000000  r5 : 00000000  r4 : c02aa690
r3 : 00000000  r2 : c02abf58  r1 : c02abf58  r0 : c02aa690
Flags: nZCv  IRQs off  FIQs on  Mode SVC_32  ISA ARM  Segment user
Control: 0005317f  Table: 20ed8000  DAC: 00000015
Process voip-ua (pid: 309, stack limit = 0xc038c268)
Stack: (0xc038de80 to 0xc038e000)
de80: a0000093 a0000093 c038deac c038de98 c002a338 c002a2cc c0c4c580
c02b9dc8 
dea0: c038decc c038deb0 c01890c8 c002a32c c02b9b60 c02b9f68 c0363c80
c0ca5cc0 
dec0: c038defc c038ded0 c0185594 c0188ff8 00000000 c0ca5cc0 c0ca5cc0
c03a5c40 
dee0: c0c828e0 c0c81108 c038c000 00000000 c038df14 c038df00 c0173f38
c01854f4 
df00: 00000001 c0c81000 c038df3c c038df18 c0173fb0 c0173eec c0173f6c
c0c828e0 
df20: c0960bf0 c03123a0 c094e438 c0020c68 c038df5c c038df40 c0077f90
c0173f7c 
df40: 00000000 c0c828e0 c0cb3ec0 00000006 c038df6c c038df60 c0078078
c0077f44 
df60: c038df8c c038df70 c0075080 c0078054 00000003 c0cb3ec0 c0c828e0
00187ae8 
df80: c038dfa4 c038df90 c0075108 c0075030 00187ae8 00000000 00000000
c038dfa8 
dfa0: c0020ac0 c007509c 00187ae8 00000000 00000004 4016ce54 00000002
00000000 
dfc0: 00187ae8 00000000 00187ae8 00000006 00000000 40e58880 00187494
beaf2edc 
dfe0: 00187a98 beaf2be8 4016ce68 4010d7ac 60000010 00000004 e28e1001
e3510003 
Backtrace: 
[<c002a2bc>] (__clk_disable+0x0/0x60) from [<c002a338>]
(clk_disable+0x1c/0x24)
r4:a0000093 r3:a0000093
[<c002a31c>] (clk_disable+0x0/0x24) from [<c01890c8>]
(atmel_ssc_shutdown+0xe0/0x148)
r4:c02b9dc8 r3:c0c4c580
[<c0188fe8>] (atmel_ssc_shutdown+0x0/0x148) from [<c0185594>]
(soc_codec_close+0xb0/0x184)
r7:c0ca5cc0 r6:c0363c80 r5:c02b9f68 r4:c02b9b60
[<c01854e4>] (soc_codec_close+0x0/0x184) from [<c0173f38>]
(snd_pcm_release_substream+0x5c/0x90)
[<c0173edc>] (snd_pcm_release_substream+0x0/0x90) from [<c0173fb0>]
(snd_pcm_release+0x44/0x88)
r4:c0c81000 r3:00000001
[<c0173f6c>] (snd_pcm_release+0x0/0x88) from [<c0077f90>]
(__fput+0x5c/0x110)
r8:c0020c68 r7:c094e438 r6:c03123a0 r5:c0960bf0 r4:c0c828e0
r3:c0173f6c
[<c0077f34>] (__fput+0x0/0x110) from [<c0078078>] (fput+0x34/0x38)
r7:00000006 r6:c0cb3ec0 r5:c0c828e0 r4:00000000
[<c0078044>] (fput+0x0/0x38) from [<c0075080>]
(filp_close+0x60/0x6c)
[<c0075020>] (filp_close+0x0/0x6c) from [<c0075108>]
(sys_close+0x7c/0xb4)
r6:00187ae8 r5:c0c828e0 r4:c0cb3ec0 r3:00000003
[<c007508c>] (sys_close+0x0/0xb4) from [<c0020ac0>]
(ret_fast_syscall+0x0/0x2c)
r5:00000000 r4:00187ae8
Code: e24cb004 e1d032bc e1a04000 e3530000 (05833000) 
---[ end trace 78aa07dd19a459c6 ]---

-- 
Med vänliga hälsningar
Fredrik Gustafsson

tel: 0733-608274
e-post: iveqy@iveqy.com

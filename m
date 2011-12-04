Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752797Ab1LDJ47 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Dec 2011 04:56:59 -0500
Received: from 50.23.254.54-static.reverse.softlayer.com ([50.23.254.54]:43082
	"EHLO softlayer.compulab.co.il" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752528Ab1LDJ45 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Dec 2011 04:56:57 -0500
Message-ID: <4EDB43DC.2050000@compulab.co.il>
Date: Sun, 04 Dec 2011 11:56:44 +0200
From: Igor Grinberg <grinberg@compulab.co.il>
Organization: CompuLab Ltd.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en; rv:1.9.2.17) Gecko/20110824 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: NeilBrown <neilb@suse.de>
CC: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: Re: [PATCH] MFD: TWL: add power off functionality
References: <1321177790-5886-1-git-send-email-grinberg@compulab.co.il>	<4ED205F9.3070908@compulab.co.il> <20111203123516.5ebb057b@notabene.brown>
In-Reply-To: <20111203123516.5ebb057b@notabene.brown>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - softlayer.compulab.co.il
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Neil,

On 12/03/11 03:35, NeilBrown wrote:
> On Sun, 27 Nov 2011 11:42:17 +0200 Igor Grinberg <grinberg@compulab.co.il>
> wrote:
> 
>> ping!
> 
> pong ...
> 
> 
> Hi,
>  I've been trying this patch out on my GTA04 with 3.2-rc4 and it doesn't
>  work :-(

Probably, v3.2-rc4 is not the best to try things out...
This patch is based on v3.1, can you try v3.1, so at least we can
check the that the patch itself has no problems?
Also, CC'ing linux-omap.

> 
>  As soon as it tries to touch the i2c controller to send the power-down
>  message I get:
> 
> [   96.130920] Unhandled fault: external abort on non-linefetch (0x1028) at 0xfa070008
> [   96.138885] Internal error: : 1028 [#1] PREEMPT
> [   96.143585] Modules linked in: bluetooth ipv6 g_ether hso rfkill
> [   96.149841] CPU: 0    Not tainted  (3.2.0-rc4+ #145)
> [   96.155029] PC is at omap_i2c_wait_for_bb+0xc4/0x100
> [   96.160186] LR is at omap_i2c_wait_for_bb+0xac/0x100
> [   96.165344] pc : [<c02e84d4>]    lr : [<c02e84bc>]    psr: 60000013
> [   96.165344] sp : d4a1ddc0  ip : d4a1dd20  fp : 00000002
> [   96.177246] r10: 00000002  r9 : c0d1f2c8  r8 : dbda9c00
> [   96.182678] r7 : c05d2a88  r6 : dbda9c00  r5 : ffff9aa8  r4 : c0d1f458
> [   96.189453] r3 : 00000008  r2 : 00000002  r1 : fa070000  r0 : 00000001
> [   96.196228] Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
> [   96.203643] Control: 10c5387d  Table: 8bdc8019  DAC: 00000015
> [   96.209625] Process poweroff (pid: 722, stack limit = 0xd4a1c2f0)
> 
> The call trace is 
> [   96.373413] [<c02e84d4>] (omap_i2c_wait_for_bb+0xc4/0x100) from [<c02e8aa8>] (omap_i2c_xfer+0x34/0x4fc)
> [   96.383178] [<c02e8aa8>] (omap_i2c_xfer+0x34/0x4fc) from [<c02e6978>] (i2c_transfer+0xac/0x130)
> [   96.392211] [<c02e6978>] (i2c_transfer+0xac/0x130) from [<c0259d20>] (twl_i2c_read+0xd8/0x12c)
> [   96.401153] [<c0259d20>] (twl_i2c_read+0xd8/0x12c) from [<c025ba0c>] (twl4030_power_off+0x34/0x124)
> [   96.410583] [<c025ba0c>] (twl4030_power_off+0x34/0x124) from [<c000f130>] (machine_power_off+0x1c/0x28)
> [   96.420349] [<c000f130>] (machine_power_off+0x1c/0x28) from [<c004ad94>] (sys_reboot+0x124/0x1e0)
> [   96.429565] [<c004ad94>] (sys_reboot+0x124/0x1e0) from [<c000e780>] (ret_fast_syscall+0x0/0x3c)

Have you modified the patch?
Because, there is no twl_i2c_read() call in twl4030_power_off() function...
Are there any other changes we need to be aware of?

> 
> 
> It has accessed this same address 0xfa070008 multiple times during normally
> running, but here at shutdown it gets an external abort.
> Presumably something is being turned of earlier in the shutdown sequence so
> that i2c is no longer available, but I have no idea what.

What distro are you using?
Does it do any kernel related sub systems power games?

> 
> Do you have any idea what might be being disabled/turned-off/unmapped/
> cleared/whatever that could cause this?

No idea currently, I need to examine the changes between v3.1 and v3.2-rc4.

> 
> I see:
> [   96.029968] twl 1-0048: shutdown
> [   96.038604] i2c i2c-1: shutdown
> 
> amongst the messages, but as far as I can tell there is no actual shutdown
> method for these to call so they don't do anything.
> 
> Ideas?

I haven't seen those messages in my v3.1.
I will try to look at this, but it will take time
as I'm on something else right now.

-- 
Regards,
Igor.

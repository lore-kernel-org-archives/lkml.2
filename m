Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754046Ab0D0Dvt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 23:51:49 -0400
Received: from mail.digidescorp.com ([66.244.163.200]:25461 "EHLO
	digidescorp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753847Ab0D0Dvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 23:51:33 -0400
X-Spam-Processed: digidescorp.com, Mon, 26 Apr 2010 22:51:33 -0500
X-Authenticated-Sender: steve@digidescorp.com
X-MDRemoteIP: 99.142.27.17
X-Return-Path: prvs=1733b75585=steve@digidescorp.com
X-Envelope-From: steve@digidescorp.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Subject: Re: [microblaze-uclinux] Re: [PATCH 1/2] microblaze: add stack
 unwinder
From: "Steven J. Magnani" <steve@digidescorp.com>
Reply-To: steve@digidescorp.com
To: monstr@monstr.eu
Cc: linux-kernel@vger.kernel.org, microblaze-uclinux@itee.uq.edu.au
In-Reply-To: <4BD5B28B.4000401@monstr.eu>
References: <1271220928-3502-1-git-send-email-steve@digidescorp.com>
	 <4BC820B2.6060604@monstr.eu>
	 <1271428410.3366.23.camel@iscandar.digidescorp.com>
	 <4BD5B28B.4000401@monstr.eu>
Content-Type: text/plain
Organization: Digital Design Corporation
Date: Mon, 26 Apr 2010 22:36:41 -0500
Message-Id: <1272339401.17476.7.camel@iscandar.digidescorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-04-26 at 17:34 +0200, Michal Simek wrote:

> I finally looked at it and here is what I found.
> 
> # ./reboot
> Restarting system.
> Machine restart...
> Machine shutdown...
> Stack:
> 4f3ffdc8: 48004aec 00000008
> 4f3ffdd0: 00000000 00000001 4f3e0150 00000001 4f3ffdec 48004b14 481dc68c 
> 48241318
> 4f3ffdf0: ffffffff 00001099 00003fff 482f49cc 4801f518 481dc6a4 48241318 
> ffffffff
> 4f3ffe10: 00001083 00003fff 482f49cc 48020150 481e3048 00000000 000001a2 
> 00000000
> 4f3ffe30: 00000000 00000000 28121969 48006b38 48240dc0 481d549c 481d53a8 
> 481d549c
> 4f3ffe50: 00aa4812 481d523c 0000c350 00000035 48029618 4f3ffe70 000001a2 
> 4f96c04c
> 4f3ffe70: 481d6390 0000c350 4f3fff58 4f3ffee0 481d639c 481d6370 00000009 
> 4f3ffee0
> 4f3ffe90: 00000000 00000000 00000000 4f3ffee0 48029df4 00000001 4f3e0150 
> 00000001
> 4f3ffeb0: 00000001 00000001 00000000 00000001 00000001 48029f34 4801b2a8 
> 4800c5e0
> 4f3ffed0: 00000020 00000000 0000c350 00000000 00000001 00000000 00000000 
> 00000035
> 4f3ffef0: 00ab0b62 00000035 00aa4812 480294e0 482425c0 00000000 00000000 
> 00000000
> 4f3fff10: 0000c350 00000001 0000c350 4f3ead40 4f3fff58 00000001 00000000 
> 00000000
> 4f3fff30: 00000001 4f3e0150 00000001 48006b38 00000000 4f3eaf68 00000000 
> 00010000
> 4f3fff50: 00000000 00000000 00000000 fee1dead 01234567 00000000 00000000 
> 4f3eaebc
> 4f3fff70: 00000000 00000000 00000000 fee1dead 28121969 01234567 00000008 
> 00000000
> 4f3fff90: 00000000 28121969 00000058 00000000 4f3e0320 4f3e0274 00000000 
> 00000000
> 4f3fffb0: 7fffff82 00000000 00000000 00000000 fee1dead 01234567 00000000 
> 00000000
> 4f3fffd0: 00000001 4f3e0150 00000001 00000000 00000000 4f96c04c 4f3e0324 
> 000001a0
> 4f3ffff0: 00000000 00000000 000001a0 00000000
> 
> 
> Call Trace:
>      Unwinding with PC=480050d4, FP=4f3ffd74
> [<480050d4>] microblaze_unwind+0xa8/0xc4
> pc 0x480050ac instr 0x30210024
>      Invalid frame size -36 at 0x480050ac
>      Failed to find previous stack frame
> 
> Below is the dump - then you can see that 36 is correct.
> That could be due to different toolchain behavior.
> 
> Thanks,
> Michal
> 
> 
> 4800502c <microblaze_unwind>:
> 4800502c:       b000482f        imm     18479
> 48005030:       e86043a8        lwi     r3, r0, 17320   // 482f43a8 <mbc>
> 48005034:       3021ffdc        addik   r1, r1, -36
> 48005038:       fa61001c        swi     r19, r1, 28
> 4800503c:       fac10020        swi     r22, r1, 32
> 48005040:       f9e10000        swi     r15, r1, 0
> 48005044:       e8830020        lwi     r4, r3, 32
> 48005048:       12650000        addk    r19, r5, r0
> 4800504c:       99fc2000        brald   r15, r4
> 48005050:       12c60000        addk    r22, r6, r0
> 48005054:       b000482f        imm     18479
> 48005058:       e86043a8        lwi     r3, r0, 17320   // 482f43a8 <mbc>
> 4800505c:       e8830008        lwi     r4, r3, 8
> 48005060:       99fc2000        brald   r15, r4
> 48005064:       80000000        or      r0, r0, r0
> 48005068:       be130068        beqid   r19, 104                // 480050d0
> 4800506c:       10b30000        addk    r5, r19, r0
> 48005070:       b0004800        imm     18432
> 48005074:       30c069e0        addik   r6, r0, 27104   // 480069e0 
> <_switch_to>
> 48005078:       165f9800        rsubk   r18, r31, r19
> 4800507c:       be120034        beqid   r18, 52         // 480050b0
> 48005080:       11360000        addk    r9, r22, r0
> 48005084:       e8730004        lwi     r3, r19, 4
> 48005088:       10b30000        addk    r5, r19, r0
> 4800508c:       e903004c        lwi     r8, r3, 76
> 48005090:       e8e3003c        lwi     r7, r3, 60
> 48005094:       b9f4fc7c        brlid   r15, -900       // 48004d10 
> <microblaze_unwind_inner>
> 48005098:       11360000        addk    r9, r22, r0
> 4800509c:       e9e10000        lwi     r15, r1, 0
> 480050a0:       ea61001c        lwi     r19, r1, 28
> 480050a4:       eac10020        lwi     r22, r1, 32
> 480050a8:       b60f0008        rtsd    r15, 8
> 480050ac:       30210024        addik   r1, r1, 36
> 480050b0:       e8730004        lwi     r3, r19, 4
> 480050b4:       30631f68        addik   r3, r3, 8040
> 480050b8:       e903003c        lwi     r8, r3, 60
> 480050bc:       e8c30080        lwi     r6, r3, 128
> 480050c0:       e8e30004        lwi     r7, r3, 4
> 480050c4:       b9f4fc4c        brlid   r15, -948       // 48004d10 
> <microblaze_unwind_inner>
> 480050c8:       80000000        or      r0, r0, r0
> 480050cc:       b800ffd0        bri     -48             // 4800509c
> 480050d0:       80e10000        or      r7, r1, r0
> 480050d4:       b8d40008        brlid   r6, 8
> 480050d8:       80000000        or      r0, r0, r0
> 480050dc:       11130000        addk    r8, r19, r0
> 480050e0:       11360000        addk    r9, r22, r0
> 480050e4:       b9f4fc2c        brlid   r15, -980       // 48004d10 
> <microblaze_unwind_inner>
> 480050e8:       10bf0000        addk    r5, r31, r0
> 480050ec:       b800ffb0        bri     -80             // 4800509c
> 

Wow. Your compiler generates code very different from mine. (What's its
pedigree?) With mine, the rtsd and "addik r1, r1, +foo" instructions are
always at the end of each function. So, I had find_frame_creation()
treat these as crossing into a different function, and give up. I will
remove those checks when I respin the patch - they're not needed with my
compiler, and with yours they prevent the backtrace from completing
properly.

Thanks for testing.

------------------------------------------------------------------------
 Steven J. Magnani               "I claim this network for MARS!
 www.digidescorp.com              Earthling, return my space modulator!"

 #include <standard.disclaimer>



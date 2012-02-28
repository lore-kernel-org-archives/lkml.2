Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754988Ab2B1Aw6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 19:52:58 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:51980 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754295Ab2B1Aw5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 19:52:57 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of kjwinchester@gmail.com designates 10.204.151.86 as permitted sender) smtp.mail=kjwinchester@gmail.com; dkim=pass header.i=kjwinchester@gmail.com
MIME-Version: 1.0
In-Reply-To: <20120227115905.GB9943@elte.hu>
References: <1330041476-719-1-git-send-email-kjwinchester@gmail.com>
	<20120227115905.GB9943@elte.hu>
Date: Mon, 27 Feb 2012 20:52:55 -0400
Message-ID: <CAELBVzDQx-geNELEvHYheSL0hKbaXfUAvjperNcPELThT9bqWg@mail.gmail.com>
Subject: Re: [PATCH v4 0/5] x86: Cleanup and simplify cpu-specific data
From: Kevin Winchester <kjwinchester@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, Randy Dunlap <rdunlap@xenotime.net>,
        Nick Bowler <nbowler@elliptictech.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27 February 2012 07:59, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Kevin Winchester <kjwinchester@gmail.com> wrote:
>
>> Various per-cpu fields are define in arch/x86/kernel/smpboot.c
>> that are basically equivalent to the cpu-specific data in
>> struct cpuinfo_x86. By moving these fields into the structure,
>> a number of codepaths can be simplified since they no longer
>> need to care about those fields not existing on !SMP builds.
>
> Works mostly fine, except with the attached 32-bit UP !APIC
> config I get various build failures (resolved via the patch
> below) and a link failure (not resolved):
>

I get the following failure before I get to link time:

In file included from
/home/kevin/linux/linux-2.6/arch/x86/include/asm/uaccess.h:573:0,
                 from
/home/kevin/linux/linux-2.6/arch/x86/include/asm/sections.h:5,
                 from
/home/kevin/linux/linux-2.6/arch/x86/include/asm/hw_irq.h:26,
                 from include/linux/irq.h:357,
                 from
/home/kevin/linux/linux-2.6/arch/x86/include/asm/hardirq.h:5,
                 from include/linux/hardirq.h:7,
                 from include/linux/interrupt.h:12,
                 from net/core/pktgen.c:135:
In function ‘copy_from_user’,
    inlined from ‘pktgen_if_write’ at net/core/pktgen.c:877:20:
/home/kevin/linux/linux-2.6/arch/x86/include/asm/uaccess_32.h:211:26:
error: call to ‘copy_from_user_overflow’ declared with attribute
error: copy_from_user() buffer size is not provably correct
make[2]: *** [net/core/pktgen.o] Error 1

On:

gcc (GCC) 4.6.2 20120120 (prerelease)

Is that my fault, or something else?

Kevin

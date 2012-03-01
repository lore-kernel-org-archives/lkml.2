Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030964Ab2CANG7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 08:06:59 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:56782 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030944Ab2CANG4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 08:06:56 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of kjwinchester@gmail.com designates 10.204.143.151 as permitted sender) smtp.mail=kjwinchester@gmail.com; dkim=pass header.i=kjwinchester@gmail.com
MIME-Version: 1.0
In-Reply-To: <ad7809d2-4c66-4d55-929b-2c1ae76f1420@email.android.com>
References: <1330041476-719-1-git-send-email-kjwinchester@gmail.com>
	<20120227115905.GB9943@elte.hu>
	<CAELBVzDQx-geNELEvHYheSL0hKbaXfUAvjperNcPELThT9bqWg@mail.gmail.com>
	<4F4C4D5C.70908@zytor.com>
	<20120228082422.GG21106@elte.hu>
	<ad7809d2-4c66-4d55-929b-2c1ae76f1420@email.android.com>
Date: Thu, 1 Mar 2012 09:06:55 -0400
Message-ID: <CAELBVzAPHfnZWRTU82V3yHuW9iY8SfAgDNmro1q4dpOvKTwnBg@mail.gmail.com>
Subject: Re: [PATCH v4 0/5] x86: Cleanup and simplify cpu-specific data
From: Kevin Winchester <kjwinchester@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, Randy Dunlap <rdunlap@xenotime.net>,
        Nick Bowler <nbowler@elliptictech.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28 February 2012 04:31, H. Peter Anvin <hpa@zytor.com> wrote:
> Better yet, fix the problem...
>

It appears that some attempts have been made at fixing this problem already:

https://lkml.org/lkml/2011/7/6/6
https://lkml.org/lkml/2011/7/7/480

So perhaps I can just turn off that config setting for now.  I'm going
away for a few days, but I'll try to fix up the patch series next
week.


> Ingo Molnar <mingo@elte.hu> wrote:
>
>>
>>* H. Peter Anvin <hpa@zytor.com> wrote:
>>
>>> >In function ‘copy_from_user’,
>>> >     inlined from ‘pktgen_if_write’ at net/core/pktgen.c:877:20:
>>>
>>>/home/kevin/linux/linux-2.6/arch/x86/include/asm/uaccess_32.h:211:26:
>>> >error: call to ‘copy_from_user_overflow’ declared with attribute
>>> >error: copy_from_user() buffer size is not provably correct
>>> >make[2]: *** [net/core/pktgen.o] Error 1
>>> >
>>> >On:
>>> >
>>> >gcc (GCC) 4.6.2 20120120 (prerelease)
>>> >
>>> >Is that my fault, or something else?
>>> >
>>> >Kevin
>>> >
>>>
>>> That comes from compiling with warnings as errors.  Not that someone
>>> shouldn't look at that kind of problem.
>>
>>Can probably be worked around by disabling:
>>
>>CONFIG_DEBUG_STRICT_USER_COPY_CHECKS
>>

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755786Ab2KUTSM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 14:18:12 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:55555 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755738Ab2KUTSL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 14:18:11 -0500
MIME-Version: 1.0
In-Reply-To: <50AD0D85.5070906@zytor.com>
References: <1353482170-10160-1-git-send-email-yinghai@kernel.org>
	<1353482170-10160-9-git-send-email-yinghai@kernel.org>
	<50AD0D85.5070906@zytor.com>
Date: Wed, 21 Nov 2012 11:18:10 -0800
X-Google-Sender-Auth: DNVFStpbkfNqJONb1rddH5o2kC4
Message-ID: <CAE9FiQVVjAoXS3mqq-dnoggM0F+Kn1Kvefu0N6TNM1UXV-6w1Q@mail.gmail.com>
Subject: Re: [PATCH v3 08/12] x86, boot: Don't check if cmd_line_ptr is
 accessible in misc/decompressor()
From: Yinghai Lu <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 21, 2012 at 9:21 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 11/20/2012 11:16 PM, Yinghai Lu wrote:
>>
>> At that stage, it is already in 32bit protected mode or 64bit mode.
>> so we do not need to check if ptr less 1M.
>>
>> When go from other boot loader (kexec) instead of boot/ code path.
>>
>> Move out accessible checking out __cmdline_find_option....
>>
>> So misc.c will parse cmdline and have debug print out.
>
>
> Your description doesn't seem to match the code, and is incredibly confusing
> to the reader.
>
> The reason why is because you leave out an essential piece of information:
> cmdline.c is included both in 16-bit code and in the decompressor (32/64-bit
> code), so you want to move the test out of the shared code.

updated change log to:

Subject: [PATCH] x86, boot: move checking of cmd_line_ptr out of common path

cmdline.c::__cmdline_find_option... are shared between
16-bit setup code and 32/64 bit decompressor code.

for 32/64 only path via kexec, we should not check if ptr less 1M.
as those cmdline could be put above 1M even 4G.

Move out accessible checking out of __cmdline_find_option....
So decompressor in misc.c can parse cmdline correctly.

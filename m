Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755738Ab2D3RLt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 13:11:49 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53725 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751911Ab2D3RLq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 13:11:46 -0400
MIME-Version: 1.0
In-Reply-To: <4F9EC6E9.9000102@codeaurora.org>
References: <1335237509-17113-1-git-send-email-sboyd@codeaurora.org>
 <201204301415.56690.arnd@arndb.de> <4F9EBF3E.8060401@codeaurora.org>
 <201204301638.29398.arnd@arndb.de> <4F9EC6E9.9000102@codeaurora.org>
From: Matt Turner <mattst88@gmail.com>
Date: Mon, 30 Apr 2012 13:11:25 -0400
Message-ID: <CAEdQ38GUKdAxEhAUWCUGv_4znmYANEgd0TY2vYOaO6Y2=p2vog@mail.gmail.com>
Subject: Re: [PATCH] Move most arches to asm-generic/current.h
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-alpha@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 30, 2012 at 1:07 PM, Stephen Boyd <sboyd@codeaurora.org> wrote:
> On 04/30/12 09:38, Arnd Bergmann wrote:
>
>> On Monday 30 April 2012, Stephen Boyd wrote:
>>> I admit I haven't compile tested this on all the affected architectures.
>>> Looking at the architectures that are migrated here I don't see any that
>>> are defining get_current() as a macro except for alpha. Should I drop
>>> alpha from the patch? Or would it be easier if someone threw this into
>>> linux-next and see if it blows up?
>>>
>>> In the meantime I can scrounge around for those kernel.org
>>> cross-compilers and see if I can compile alpha.
>> I'd say either get an Ack from the Alpha maintainers or drop that
>> hunk from your patch.
>>
>
> Ok. Alpha maintainers, do you see any problem with a static inline
> function for get_current() instead of the current macro? My compile of
> alpha with the kernel.org 4.6.3 compilers doesn't show any new build
> failures than what is already there:
>
>  LD      .tmp_vmlinux1
> drivers/built-in.o: In function `ide_set_disk_chs':
> drivers/ide/ide.c:269:(.text+0x732a8): relocation truncated to fit: GPREL16 against `.sbss'
> drivers/ide/ide.c:269:(.text+0x732b0): relocation truncated to fit: GPREL16 against `.sbss'
> drivers/ide/ide.c:267:(.text+0x73310): relocation truncated to fit: GPREL16 against `.sbss'
> drivers/ide/ide.c:267:(.text+0x73318): relocation truncated to fit: GPREL16 against `.sbss'
> drivers/built-in.o: In function `ide_dev_apply_params':
> drivers/ide/ide.c:299:(.text+0x73714): relocation truncated to fit: GPREL16 against `.sbss'
> drivers/ide/ide.c:303:(.text+0x73724): relocation truncated to fit: GPREL16 against `.sbss'
> drivers/ide/ide.c:308:(.text+0x73734): relocation truncated to fit: GPREL16 against `.sbss'
> drivers/ide/ide.c:315:(.text+0x73744): relocation truncated to fit: GPREL16 against `.sbss'
> drivers/built-in.o: In function `unexpected_intr':
> drivers/ide/ide-io.c:734:(.text+0x74dfc): relocation truncated to fit: GPREL16 against `.sbss'
> drivers/ide/ide-io.c:736:(.text+0x74e00): relocation truncated to fit: GPREL16 against `.sbss'
> drivers/ide/ide-io.c:734:(.text+0x74e10): additional relocation overflows omitted from the output
> make[1]: *** [.tmp_vmlinux1] Error 1
> make: *** [sub-make] Error 2

I'll take a look later this week.

The relocation truncated to fit: GPREL16 against ... error is caused
by the kernel being too large and compiling with -msmall-data. We've
really got to do something about this -- this happens way too often to
way too many people.

Matt

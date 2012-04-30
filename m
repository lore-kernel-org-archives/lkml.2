Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756447Ab2D3RH5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 13:07:57 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:33834 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755797Ab2D3RHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 13:07:54 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6697"; a="186238388"
Message-ID: <4F9EC6E9.9000102@codeaurora.org>
Date: Mon, 30 Apr 2012 10:07:53 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: linux-alpha@vger.kernel.org
CC: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>
Subject: Re: [PATCH] Move most arches to asm-generic/current.h
References: <1335237509-17113-1-git-send-email-sboyd@codeaurora.org> <201204301415.56690.arnd@arndb.de> <4F9EBF3E.8060401@codeaurora.org> <201204301638.29398.arnd@arndb.de>
In-Reply-To: <201204301638.29398.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/30/12 09:38, Arnd Bergmann wrote:

> On Monday 30 April 2012, Stephen Boyd wrote:
>> I admit I haven't compile tested this on all the affected architectures.
>> Looking at the architectures that are migrated here I don't see any that
>> are defining get_current() as a macro except for alpha. Should I drop
>> alpha from the patch? Or would it be easier if someone threw this into
>> linux-next and see if it blows up?
>>
>> In the meantime I can scrounge around for those kernel.org
>> cross-compilers and see if I can compile alpha.
> I'd say either get an Ack from the Alpha maintainers or drop that
> hunk from your patch.
>

Ok. Alpha maintainers, do you see any problem with a static inline
function for get_current() instead of the current macro? My compile of
alpha with the kernel.org 4.6.3 compilers doesn't show any new build
failures than what is already there:

  LD      .tmp_vmlinux1
drivers/built-in.o: In function `ide_set_disk_chs':
drivers/ide/ide.c:269:(.text+0x732a8): relocation truncated to fit: GPREL16 against `.sbss'
drivers/ide/ide.c:269:(.text+0x732b0): relocation truncated to fit: GPREL16 against `.sbss'
drivers/ide/ide.c:267:(.text+0x73310): relocation truncated to fit: GPREL16 against `.sbss'
drivers/ide/ide.c:267:(.text+0x73318): relocation truncated to fit: GPREL16 against `.sbss'
drivers/built-in.o: In function `ide_dev_apply_params':
drivers/ide/ide.c:299:(.text+0x73714): relocation truncated to fit: GPREL16 against `.sbss'
drivers/ide/ide.c:303:(.text+0x73724): relocation truncated to fit: GPREL16 against `.sbss'
drivers/ide/ide.c:308:(.text+0x73734): relocation truncated to fit: GPREL16 against `.sbss'
drivers/ide/ide.c:315:(.text+0x73744): relocation truncated to fit: GPREL16 against `.sbss'
drivers/built-in.o: In function `unexpected_intr':
drivers/ide/ide-io.c:734:(.text+0x74dfc): relocation truncated to fit: GPREL16 against `.sbss'
drivers/ide/ide-io.c:736:(.text+0x74e00): relocation truncated to fit: GPREL16 against `.sbss'
drivers/ide/ide-io.c:734:(.text+0x74e10): additional relocation overflows omitted from the output
make[1]: *** [.tmp_vmlinux1] Error 1
make: *** [sub-make] Error 2



-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762622Ab2DLTmI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 15:42:08 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:62167 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755662Ab2DLTmE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 15:42:04 -0400
MIME-Version: 1.0
In-Reply-To: <4F872ED8.1060608@kernel.org>
References: <1332960678-11879-1-git-send-email-andi@firstfloor.org>
	<1332960678-11879-2-git-send-email-andi@firstfloor.org>
	<CAMuHMdVX28zeebzN6277B5p2b=9s-Q06i01o5AHPyXAuKMigGQ@mail.gmail.com>
	<4F872ED8.1060608@kernel.org>
Date: Thu, 12 Apr 2012 21:42:02 +0200
X-Google-Sender-Auth: K5nuUwL8A2dfeKgmyueVPVrF8sU
Message-ID: <CAMuHMdXi6oOPz-9vV7ccdpVnoED3ayK1sT0bs6nZrcGzCw94Ew@mail.gmail.com>
Subject: Re: [PATCH 2/2] Add CONFIG_READABLE_ASM
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "H. Peter Anvin" <hpa@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org, x86@kernel.org,
        Andi Kleen <ak@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 12, 2012 at 21:36, H. Peter Anvin <hpa@kernel.org> wrote:
> On 04/12/2012 12:08 PM, Geert Uytterhoeven wrote:
>> On Wed, Mar 28, 2012 at 20:51, Andi Kleen <andi@firstfloor.org> wrote:
>>> +ifdef CONFIG_READABLE_ASM
>>> +# Disable optimizations that make assembler listings hard to read.
>>> +# reorder blocks reorders the control in the function
>>> +# ipa clone creates specialized cloned functions
>>> +# partial inlining inlines only parts of functions
>>> +KBUILD_CFLAGS += $(call cc-option,-fno-reorder-blocks,) \
>>> +                 $(call cc-option,-fno-ipa-cp-clone,) \
>>> +                 $(call cc-option,-fno-partial-inlining)
>>> +endif
>>
>> This (now in linux-next) causes m68k/allmodconfig to fail for me:
>>
>>   CHK     include/linux/version.h
>>   CHK     include/generated/utsrelease.h
>>   CC      kernel/bounds.s
>> cc1: error: unrecognized command line option "-fno-ipa-cp-clone"
>>
>> Somehow, "$(call cc-option,-fno-ipa-cp-clone,)" doesn't detect that my
>> toolchain (gcc version 4.1.2 20061115 (prerelease) (Ubuntu 4.1.1-21))
>> doesn't support this option.
>>
>> I tried playing with the trailing comma (why do the first 2 tests have it,
>> and the 3rd one doesn't?), but that didn't make a difference.
>>
>> linux-next builds (using a newer toolchain) don't show this.
>>
>
> Sounds like the fundamental action item is to find out what makes
> cc-option not work.

FWIW, it did detect that:
  - -fno-reorder-blocks is supported,
  - -fno-partial-inlining is not supported.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds

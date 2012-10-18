Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754233Ab2JRFva (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 01:51:30 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:42105 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754178Ab2JRFv2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 01:51:28 -0400
MIME-Version: 1.0
In-Reply-To: <507F78B0.70808@snapgear.com>
References: <20121018103713.0ccb63374964501c3d8d99a5@canb.auug.org.au>
	<20121018103826.c8e1312904747b31caa376f6@canb.auug.org.au>
	<507F78B0.70808@snapgear.com>
Date: Thu, 18 Oct 2012 07:51:26 +0200
X-Google-Sender-Auth: Oe1nkTyc6_f6AolAPlGBtQWlOUw
Message-ID: <CAMuHMdWX2ZVNcz1Ubsk0W3HH7qcBQhctaWSFVq=x+YwbuUE9YA@mail.gmail.com>
Subject: Re: linux-next: manual merge of the m68knommu tree with the tree
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Greg Ungerer <gerg@snapgear.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Thu, Oct 18, 2012 at 5:34 AM, Greg Ungerer <gerg@snapgear.com> wrote:
> On 18/10/12 09:38, Stephen Rothwell wrote:
>>
>> [Just cc'ing Geert]
>>
>> On Thu, 18 Oct 2012 10:37:13 +1100 Stephen Rothwell <sfr@canb.auug.org.au>
>> wrote:
>>>
>>>
>>> Hi Greg,
>>>
>>> Today's linux-next merge of the m68knommu tree got conflicts in
>>> arch/m68k/include/asm/termios.h, arch/m68k/include/uapi/asm/auxvec.h,
>>> arch/m68k/include/uapi/asm/msgbuf.h, arch/m68k/include/uapi/asm/sembuf.h,
>>> arch/m68k/include/uapi/asm/shmbuf.h, arch/m68k/include/uapi/asm/socket.h,
>>> arch/m68k/include/uapi/asm/sockios.h and
>>> arch/m68k/include/uapi/asm/termbits.h between commit 10b3a979347d ("UAPI:
>>> (Scripted) Disintegrate arch/m68k/include/asm") from the m68k-current
>>> tree and various commits from the m68knommu tree that use the asm-generic
>>> versions.
>>>
>>> I just deleted all those files and added the following merge fix patch
>>> and can carry the fix as necessary.
>>>
>>> I think that this is the correct thing to do ...
>
>
> I think that is right. Thanks.

I still have to do a proper review of your changes (I noticed a few
things I have
to double-check). After that, I guess it's easiest if I take your
patch, updated for
the UAPI disintegration?

>
> Regards
> Greg
>
>
>
>>> From: Stephen Rothwell <sfr@canb.auug.org.au>
>>> Date: Thu, 18 Oct 2012 10:32:20 +1100
>>> Subject: [PATCH] m68k: fix up for UAPI changes
>>>
>>> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
>>> ---
>>>   arch/m68k/include/uapi/asm/Kbuild |    8 --------
>>>   1 file changed, 8 deletions(-)
>>>
>>> diff --git a/arch/m68k/include/uapi/asm/Kbuild
>>> b/arch/m68k/include/uapi/asm/Kbuild
>>> index 972bce1..aebdbf5 100644
>>> --- a/arch/m68k/include/uapi/asm/Kbuild
>>> +++ b/arch/m68k/include/uapi/asm/Kbuild
>>> @@ -2,25 +2,17 @@
>>>   include include/uapi/asm-generic/Kbuild.asm
>>>
>>>   header-y += a.out.h
>>> -header-y += auxvec.h
>>>   header-y += byteorder.h
>>>   header-y += cachectl.h
>>>   header-y += fcntl.h
>>>   header-y += ioctls.h
>>> -header-y += msgbuf.h
>>>   header-y += param.h
>>>   header-y += poll.h
>>>   header-y += posix_types.h
>>>   header-y += ptrace.h
>>> -header-y += sembuf.h
>>>   header-y += setup.h
>>> -header-y += shmbuf.h
>>>   header-y += sigcontext.h
>>>   header-y += signal.h
>>> -header-y += socket.h
>>> -header-y += sockios.h
>>>   header-y += stat.h
>>>   header-y += swab.h
>>> -header-y += termbits.h
>>> -header-y += termios.h
>>>   header-y += unistd.h
>>> --
>>> 1.7.10.280.gaa39

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds

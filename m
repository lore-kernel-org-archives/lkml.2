Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756508Ab2EPQAE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 12:00:04 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:64265 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756441Ab2EPP76 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 11:59:58 -0400
MIME-Version: 1.0
In-Reply-To: <1337179563.2985.80.camel@dabdike.int.hansenpartnership.com>
References: <1337157034-22773-1-git-send-email-geert@linux-m68k.org>
	<CAMuHMdUtL4_mv-e-EQAZmNcb9dAT=PXB59i7Vuj2vf8NnaBFzQ@mail.gmail.com>
	<1337179563.2985.80.camel@dabdike.int.hansenpartnership.com>
Date: Wed, 16 May 2012 17:59:56 +0200
X-Google-Sender-Auth: A8uuJZodSPpoT1ilUfjtnPpvZmE
Message-ID: <CAMuHMdX13f4-3_Oe8bwZAnZpwDSV11Oxdgh--njiNGJ2KLAAww@mail.gmail.com>
Subject: Re: Build regressions/improvements in v3.4-rc7
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: linux-kernel@vger.kernel.org, Linuxppc-dev <linuxppc-dev@ozlabs.org>,
        Parisc List <linux-parisc@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Dmitry Kasatkin <dmitry.kasatkin@intel.com>,
        James Morris <jmorris@namei.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 16, 2012 at 4:46 PM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> On Wed, 2012-05-16 at 10:47 +0200, Geert Uytterhoeven wrote:
>> On Wed, May 16, 2012 at 10:30 AM, Geert Uytterhoeven
>> <geert@linux-m68k.org> wrote:
>>   + lib/mpi/generic_mpih-mul1.c: error: inconsistent operand
>> constraints in an 'asm':  => 50:70
>>   + lib/mpi/generic_mpih-mul2.c: error: inconsistent operand
>> constraints in an 'asm':  => 49:70
>>   + lib/mpi/generic_mpih-mul3.c: error: inconsistent operand
>> constraints in an 'asm':  => 49:70
>>   + lib/mpi/mpih-div.c: error: inconsistent operand constraints in an
>> 'asm':  => 135:122, 135:371, 97:122, 106:121, 106:370, 97:371
>>
>> parisc-allmodconfig
>
> Wow, lib/mpi/ is a complete horror: it's full of hand crafted asm code.
> The error in this case appears to be that umul_ppm() is implemented as
> an xmpyu instruction.  That's a floating point instruction.  We
> deliberately compile the kernel with floating point disabled because we
> don't want to save and restore the floating point register file on each
> context switch, hence the operand constraints are unsatisfiable.

It also does fishy things on m68k, cfr. https://lkml.org/lkml/2012/3/11/22

> It appears to be completely untested on non-x86 and to have been
> imported via the security tree ... what are we supposed to do with this?
> I thought the general principle was that asm code was really supposed to
> be confined to the arch directories?

Kick it out again, or contain it in staging?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds

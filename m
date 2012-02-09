Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752458Ab2BIK6Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 05:58:24 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:62463 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722Ab2BIK6X convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 05:58:23 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFx9iopC+jibPrdFqcff-h==8JVXipjeVt9_=0qAZzgYLA@mail.gmail.com>
References: <CA+55aFwc+VvFyv3TJgZ+wZVz738sWA+csi3_u5AeZG4AiXn82g@mail.gmail.com>
	<CAMO-S2i8Z7q2NQN4WDwvwjrNAoe2uFKhFcfpLb4gRHoZtiynzQ@mail.gmail.com>
	<CA+55aFx9iopC+jibPrdFqcff-h==8JVXipjeVt9_=0qAZzgYLA@mail.gmail.com>
Date: Thu, 9 Feb 2012 11:58:21 +0100
X-Google-Sender-Auth: SodidXQEvUORc8ZUBpFMHbSuKUc
Message-ID: <CAMuHMdWFmTP5anMb36z-OQLXeRQ4=LfsmpiM9FKnMiH=GVcdDA@mail.gmail.com>
Subject: Re: [PATCH] asm-generic: architecture independent readq/writeq for
 32bit environment
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Hitoshi Mitake <h.mitake@gmail.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Roland Dreier <roland@purestorage.com>,
        Matthew Garrett <mjg@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        James Bottomley <James.Bottomley@parallels.com>,
        Ravi Anand <ravi.anand@qlogic.com>,
        James Bottomley <jbottomley@parallels.com>,
        Len Brown <lenb@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Jason Uhlenkott <juhlenko@akamai.com>,
        Kashyap Desai <Kashyap.Desai@lsi.com>, linux-kernel@vger.kernel.org,
        Vikas Chaudhary <vikas.chaudhary@qlogic.com>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>, mingo@elte.hu
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 8, 2012 at 17:28, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Wed, Feb 8, 2012 at 8:14 AM, Hitoshi Mitake <h.mitake@gmail.com> wrote:
>> On Tue, Feb 7, 2012 at 12:56, Linus Torvalds
>> <torvalds@linux-foundation.org> wrote:
>>>
>>> On Feb 6, 2012 6:47 PM, "Hitoshi Mitake" <h.mitake@gmail.com> wrote:
>>>>
>>>>  All of them are endian aware
>>>
>>> I think that part is wrong.
>>>
>>> Pci is little-endian, so readl and writel are always already little-endian.
>>> Trying to make readq be endian-aware is wrong.
>>
>> Is every memory area which can be read/written by read[wl]/write[wl]
>> always little-endian?
>>
>> If so, of course I have to eliminate the big-endian version.
>> But I'm not sure about this point because the new readq/writeq is
>> in asm-generic which is used by every archs, so I'd like to ask you about it.
>
> Yes, PCI is always little-endian everywhere.
>
> Now, some architectures may have some unified IO space where parts of
> it is PCI, and other parts are programmed the same way but is for some
> other bus, but the PCI part will always be little-endian because
> otherwise no common driver would ever work. But those non-PCI things
> would never be relevant for an emulated readq/writeq anyway, and would
> need some bus-specific accessor functions.

IIRC, some crazy hardware manufacturers did swizzle PCI busses in hardware.
So doing a PCI "little endian" 32-bit read must be performed using a native
(big endian) 32-bit read. And it causes more headaches for 16-bit accesses.

Of course this must all be hidden in your readX() implementations, to make the
common drivers work.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds

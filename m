Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932132Ab1JCODT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 10:03:19 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:64735 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751339Ab1JCODO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 10:03:14 -0400
MIME-Version: 1.0
In-Reply-To: <CADLM8XP09kFhxjMYbxD80+4cS00cm2aWZE1Zvjoby0Afrdz9eQ@mail.gmail.com>
References: <CADLM8XNiaxLFRZXs4NKJmoORvED-DV0bNxPF6eHsfnLqtxw09w@mail.gmail.com>
	<20111003192458.14d198a3.kamezawa.hiroyu@jp.fujitsu.com>
	<CAMuHMdVuMHjbDkAdrkfTS-ZaYCwN-avihsQyDsOAVFt+PdWqYw@mail.gmail.com>
	<CADLM8XP09kFhxjMYbxD80+4cS00cm2aWZE1Zvjoby0Afrdz9eQ@mail.gmail.com>
Date: Mon, 3 Oct 2011 16:03:14 +0200
X-Google-Sender-Auth: kFxPT3VO7GnQPlKFLXzWNxv-1rk
Message-ID: <CAMuHMdV_aKGscAw1UmQU45VZONtdvYLTK18nTYX4wvg0YLTx4A@mail.gmail.com>
Subject: Re: One comment on the __release_region in kernel/resource.c
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Wei Yang <weiyang.kernel@gmail.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 3, 2011 at 15:35, Wei Yang <weiyang.kernel@gmail.com> wrote:
> 2011/10/3 Geert Uytterhoeven <geert@linux-m68k.org>
>> On Mon, Oct 3, 2011 at 12:24, KAMEZAWA Hiroyuki
>> <kamezawa.hiroyu@jp.fujitsu.com> wrote:
>> > On Sun, 2 Oct 2011 21:57:07 +0800
>> > Wei Yang <weiyang.kernel@gmail.com> wrote:
>> >
>> >> Dear experts,
>> >>
>> >> I am viewing the source code of __release_region() in
>> >> kernel/resource.c.
>> >> And I have one comment for the performance issue.
>> >>
>> >> For example, we have a resource tree like this.
>> >> 10-89
>> >>    20-79
>> >>        30-49
>> >>        55-59
>> >>        60-64
>> >>        65-69
>> >>    80-89
>> >> 100-279
>> >>
>> >> If the caller wants to release a region of [50,59], the original code
>> >> will
>>                                              ^^^^^^^
>> Do you really mean [50,59]?
>
> Yes.
>>
>> I don't think that's allowed, as the tree has [55,59], so you would
>> release a
>> larger region that allocated.
>
> So you mean the case I mentioned will not happen?

Indeed, it should not happen.
Actually I'm surprised it doesn't return an error code.

> Actually, I believe every developer should pass the resource region which
> has been allocated.
> While if some one made a mistake and pass a region which is not allocated
> before and overlap
> some "BUSY" region?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds

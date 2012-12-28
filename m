Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754360Ab2L1WDp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 17:03:45 -0500
Received: from mail-vc0-f175.google.com ([209.85.220.175]:40467 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753969Ab2L1WDm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 17:03:42 -0500
MIME-Version: 1.0
In-Reply-To: <20121228130734.GB13224@x1.alien8.de>
References: <CA+8YGd6UqfbzEHOb2NUL5p3EF4OECVq7yc2vRV3GViVT64CTbQ@mail.gmail.com>
	<20121227184034.GA2982@debian.debian>
	<CABuSbKbk5DdhvuwYUeLkm=eub1CsSaOB_oX7bkBZcAV_MNsSdg@mail.gmail.com>
	<CAK7N6vpvLrAb=sZitaEBQ6Fx4K5ehGg+LTU70hiVK=1RdE4WwQ@mail.gmail.com>
	<CAOUxTKNgs4N-M5RR6YHyGeXQqRrg0_CJpxgT2OmN_buEP+jbjQ@mail.gmail.com>
	<CAK7N6vqw+DVSVaCXqiQBVa_d2o-rg-oA5t8+6WNaZ9Mb_iQqdw@mail.gmail.com>
	<87a9syhbma.fsf@xmission.com>
	<20121228130734.GB13224@x1.alien8.de>
Date: Fri, 28 Dec 2012 23:03:40 +0100
X-Google-Sender-Auth: Q8YNXwYmtFOIpOQqCCescSUS6ho
Message-ID: <CAMuHMdVo67RrcencMOTJSL_=fGjDFBtczRpvW6D8QbVxNy-t3g@mail.gmail.com>
Subject: Re: how to look for source code in kernel
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Borislav Petkov <bp@alien8.de>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        anish singh <anish198519851985@gmail.com>,
        amit mehta <gmate.amit@gmail.com>,
        Henrique Rodrigues <henriquesilvar@gmail.com>,
        kishore kumar <kishoreopen@gmail.com>,
        =?UTF-8?Q?Jonathan_Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>,
        linux-kernel@vger.kernel.org, Kernelnewbies@kernelnewbies.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 28, 2012 at 2:07 PM, Borislav Petkov <bp@alien8.de> wrote:
> On Thu, Dec 27, 2012 at 11:36:13PM -0800, Eric W. Biederman wrote:
>> git-ls-files | xargs fgrep 'struct f2fs_inode'
>>
>> That returns instantly and tells me where to look.  If you can do an
>> instant brute force search what is the point of an index?
>
> Not if you're using a lame-ass laptop with a rotating disk:
>
> $ time git ls-files | xargs grep -E 'struct mce\W*{'
> arch/x86/include/uapi/asm/mce.h:struct mce {
> arch/x86/kernel/cpu/mcheck/mce.c:               if (!final || memcmp(m, final, sizeof(struct mce))) {
>
> real    2m48.415s
> user    0m2.388s
> sys     0m15.668s

That's the first run. Now everything is in the buffer cache (assumed you have
enough RAM), and try again...

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds

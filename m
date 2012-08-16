Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752897Ab2HPPDw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 11:03:52 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:37529 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026Ab2HPPDu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 11:03:50 -0400
MIME-Version: 1.0
In-Reply-To: <1345125049.26882.16.camel@joe2Laptop>
References: <CAMuHMdVEKpVYn+Yr5rzdOvV5zUWrD12Fas197Mn2oVDC5YgVgw@mail.gmail.com>
	<1345125049.26882.16.camel@joe2Laptop>
Date: Thu, 16 Aug 2012 17:03:49 +0200
X-Google-Sender-Auth: EMxFFFwT664oapZ3U9hW3b-yoWA
Message-ID: <CAMuHMdVed0OU+D_tdrG-UtFiLzFp0KQKWVpY+OS9M1oCs_4SnQ@mail.gmail.com>
Subject: Re: Regression: Spurious "^A" in UML output
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Joe Perches <joe@perches.com>
Cc: uml-devel <user-mode-linux-devel@lists.sourceforge.net>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe,

On Thu, Aug 16, 2012 at 3:50 PM, Joe Perches <joe@perches.com> wrote:
> On Thu, 2012-08-16 at 15:17 +0200, Geert Uytterhoeven wrote:
>> In v3.6-rc1 UML, I see spurious "^A" (ASCII 1, SOH) characters in some kernel
>> messages:
>>
>> Calibrating delay loop... 4640.76 BogoMIPS (lpj=23203840)
>> pid_max: default: 32768 minimum: 301
>> Mount-cache hash table entries: 256
>> ^AChecking that host ptys support output SIGIO...Yes
>> ^AChecking that host ptys support SIGIO on close...No, enabling workaround
>> ^AUsing 2.6 host AIO
>> NET: Registered protocol family 16
>> bio: create slab <bio-0> at 0
>> Switching to clocksource itimer
>>
>> This happens for all output using the "printk(UM_KERN_XXX ...)" idiom.
>
> Were these emitted with "KERN_<LEVEL>" string constants
> before this change (not <[0-7]>", but the string text
> KERN_INFO, KERN_WARNING, etc...)?

They were emitted with the "<x>" string constants.

This is used in the userspace part of UML, which runs as a userspace
application on the host. Hence it cannot include kernel header files
directly.

However, now include/linux/kern_levels.h is fairly self-container, perhaps
we should just include that file directly instead of, and get rid of all
DEFINE_STR() users.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds

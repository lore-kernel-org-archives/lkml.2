Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751593Ab2I2U7A (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2012 16:59:00 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:39417 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751563Ab2I2U67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2012 16:58:59 -0400
MIME-Version: 1.0
In-Reply-To: <20120929204314.GK13973@ZenIV.linux.org.uk>
References: <1348938460-20919-1-git-send-email-geert@linux-m68k.org>
	<1348938460-20919-2-git-send-email-geert@linux-m68k.org>
	<1348949440.3294.2.camel@joe-AO722>
	<CAMuHMdWiDKV2=kbO8UGqZBETdrYExLRbaRFNnVTVRcWUs16OcA@mail.gmail.com>
	<20120929204314.GK13973@ZenIV.linux.org.uk>
Date: Sat, 29 Sep 2012 22:58:58 +0200
X-Google-Sender-Auth: wS8HxHhRfNfN_6mwccFL5N05G3w
Message-ID: <CAMuHMdVS3Z6bEP=+=oOxvucyz86v7xwB15zDVRNsGYuoAZ7ZpQ@mail.gmail.com>
Subject: Re: [PATCH 2/4] arch/um/os-Linux: Drop UM_ prefix from printk() level specifiers
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Joe Perches <joe@perches.com>, Richard Weinberger <richard@nod.at>,
        user-mode-linux-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, x86@kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 29, 2012 at 10:43 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Sat, Sep 29, 2012 at 10:27:44PM +0200, Geert Uytterhoeven wrote:
>> On Sat, Sep 29, 2012 at 10:10 PM, Joe Perches <joe@perches.com> wrote:
>> >> @@ -88,7 +88,7 @@ static int do_aio(aio_context_t ctx, enum aio_type type, int fd, char *buf,
>> >>               iocbp->aio_nbytes = sizeof(c);
>> >>               break;
>> >>       default:
>> >> -             printk(UM_KERN_ERR "Bogus op in do_aio - %d\n", type);
>> >> +             printk(KERN_ERR "Bogus op in do_aio - %d\n", type);
>> >
>> > Maybe a follow-on patch to convert these to pr_<level>?
>>
>> That requires adding pr_<level> to arch/um/include/shared/user.h first.
>> Or to avoid duplication, extracting the pr_<level> definitions from
>> include/linux/printk.h to a new header file, and preincluding that one for
>> the user part of UML, too.
>
> Yecchhh....  Just how many of those pre-includes do you want to add?
> Seriously, if we get enough of those, it might make more sense to take
> them into a separate directory and add it to search paths, including
> that for userland objects of uml.  If not, I'd rather copy them to
> include/generated in arch/um/Makefile and explicitly #include <generated/foo.h>
> them from user.h.  It's trivially doable and as long as we have relatively
> few of those guys it's less PITA...

Fine for me! I was just following the initial example with
preincluding user.h...

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds

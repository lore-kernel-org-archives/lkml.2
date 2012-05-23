Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933118Ab2EWUv3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 16:51:29 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:61134 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753183Ab2EWUv2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 16:51:28 -0400
MIME-Version: 1.0
In-Reply-To: <20120523181917.GN11775@ZenIV.linux.org.uk>
References: <20120523170740.ae058d8d5468d471eb948c39@canb.auug.org.au>
	<4FBD090E.5020901@xenotime.net>
	<20120523181917.GN11775@ZenIV.linux.org.uk>
Date: Wed, 23 May 2012 22:51:26 +0200
X-Google-Sender-Auth: JUBH8uYZWvbjvQcPuo4vA1xntZw
Message-ID: <CAMuHMdVVtMwuXULhK3dHexdSex+7JSj=Vk9z8fWohfMvrOuCWQ@mail.gmail.com>
Subject: Re: linux-next: Tree for May 23 (uml)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Richard Weinberger <richard@nod.at>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 23, 2012 at 8:19 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>> uml defconfig on x86_64:
>>
>> arch/um/kernel/process.c: In function 'interrupt_end':
>> arch/um/kernel/process.c:122:14: error: 'struct task_struct' has no member named 'replacement_session_keyring'
>> arch/um/kernel/process.c:123:4: error: implicit declaration of function 'key_replace_session_keyring'
>
> Grr...  That's a conflict between uml gaining TIF_NOTIFY_RESUME (needed
> prereq to task_work_add() series) and patch in said series doing away
> with explicit calls of key_replace_session_keyring().  Fixup is to remove
> those two lines in arch/um/process.c, same as done on other architectures
> by "keys: kill the dummy key_replace_session_keyring()" (commit c1cb001).

JFYI, also on m68k:

http://kisskb.ellerman.id.au/kisskb/buildresult/6353103/

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751617Ab1FGHJu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 03:09:50 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:38962 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750801Ab1FGHJr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 03:09:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Ni/oIyAiN/q/x+g1KyrxgH85jx88M/iEkw9GK4qKWQODspSBhSkOHTw8O+F+yvVskK
         q+P/3eJXoAlpJ2xrGnLfv4+Qd4nopzG2De0WSHUz6610eqYbHcErocb77DLU8mEbvam3
         6orowqTjl1SpZhvoEj9rqulBeaiKQI3TtyjBI=
MIME-Version: 1.0
In-Reply-To: <201106062211.15247.arnd@arndb.de>
References: <1307390873-29687-1-git-send-email-geert@linux-m68k.org>
	<201106062211.15247.arnd@arndb.de>
Date: Tue, 7 Jun 2011 09:09:45 +0200
X-Google-Sender-Auth: u-NazQI5fogJUsnxvLnSYJBKopI
Message-ID: <BANLkTin8XNA+ocdjUhtzVOQNxOGFsYa1mA@mail.gmail.com>
Subject: Re: [PATCH/RFC] m68k/bitops: Make bitmap data pointer of atomic ops volatile
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-m68k@vger.kernel.org, Akinobu Mita <akinobu.mita@gmail.com>,
        linux-kernel@vger.kernel.org, Ben Hutchings <ben@decadent.org.uk>,
        linux-ide@vger.kernel.org, dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 6, 2011 at 22:11, Arnd Bergmann <arnd@arndb.de> wrote:
> On Monday 06 June 2011 22:07:53 Geert Uytterhoeven wrote:
>>
>> This fixes a.o.
>>
>> drivers/ide/ide-io.c: In function ‘ide_lock_host’:
>> drivers/ide/ide-io.c:415: warning: passing argument 2 of ‘__constant_test_and_set_bit’ discards qualifiers from pointer target type
>> drivers/ide/ide-io.c:415: warning: passing argument 2 of ‘__generic_test_and_set_bit’ discards qualifiers from pointer target type
>>
>> Suggested-by: Ben Hutchings <ben@decadent.org.uk>
>> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
>
> I think the correct fix would be to mark the variable not volatile, as it
> clearly has no business be marked as such. That doesn't mean your patch

You mean the host_busy variable in the IDE code?
That would also apply to context_flag in the DRM code:

drivers/gpu/drm/drm_context.c:233: warning: passing argument 2 of
‘__constant_test_and_set_bit’ discards qualifiers from pointer target
type
drivers/gpu/drm/drm_context.c:233: warning: passing argument 2 of
‘__generic_test_and_set_bit’ discards qualifiers from pointer target
type

> is wrong, though. It probably doesn't hurt to do both.

asm-generic/bitops/atomic.h has the volatiles everywhere. That's why
I'm wondering.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds

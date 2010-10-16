Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753491Ab0JPH73 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 03:59:29 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:55334 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753241Ab0JPH70 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 03:59:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=UFjvoi7b5ZYQ0VqWxViJOj2C+5sI/+iPMtzPshPHpU3BQeUT/oB7cv2uGMbhGWjgkw
         H6z/TBNNALnWg/NMKB002UUBbBTTI8HbUe9fyV4yzNRFPkt7AN8CkePNQyS3t1mNQPFc
         dOc8nf4GbE4QNGMnBInZwU87GlcV5t9CQ1r98=
MIME-Version: 1.0
In-Reply-To: <201010151253.15653.arnd@arndb.de>
References: <1287135981-17604-1-git-send-email-akinobu.mita@gmail.com>
	<1287135981-17604-23-git-send-email-akinobu.mita@gmail.com>
	<201010151253.15653.arnd@arndb.de>
Date: Sat, 16 Oct 2010 09:59:24 +0200
X-Google-Sender-Auth: 7w9Cj525iuq26HIjjIK-nAY5KnY
Message-ID: <AANLkTi=cA=yf7NmPVKXaZdoTBYmwdmy_frk7b_feG-WG@mail.gmail.com>
Subject: Re: [PATCH 22/22] bitops: remove minix bitops from asm/bitops.h
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Akinobu Mita <akinobu.mita@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Linux/m68k" <linux-m68k@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 15, 2010 at 12:53, Arnd Bergmann <arnd@arndb.de> wrote:
> On Friday 15 October 2010, Akinobu Mita wrote:
>> minix bit operations are only used by minix filesystem and useless
>> by other modules.
>
> Right.
>
>> This provides new config option CONFIG_MINIX_FS_LITTLE_ENDIAN and
>> CONFIG_MINIX_FS_NATIVE_ENDIAN that each architecture selects one of which.
>> Then we can remove minix bit operations from asm/bitops.h from all
>> architectures by making them minix filesystem local macros.
>
> I would say that any architecture that defines minix bitops as
> little-endian is broken and we should not even need the #define.
>
> You have defined these as "native endian":
>
> always LE:
>        alpha, blackfin, ia64, score, tile, x86
>
> always BE:
>        h8300, microblaze, s390, sparc
>
> configurable:
>        m32r, mips, sh, xtensa
>
> The only ones among these that possibly ever cared about mounting minix
> file systems on a big-endian kernel are really old sparc and mips systems,
> everyone else probably never noticed their mistake.
>
> I'd say let's define the minix bitops as always LE and be done with it.

Funny, m68k uses the little endian minix file system?

Perhaps this was due to minix using the ext2 accessors? And ext2 being
switched from big to little endian ext2 on m68k, without anyone
noticing the impact
on minix?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds

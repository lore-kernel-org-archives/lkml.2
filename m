Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755213Ab0JVHzQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 03:55:16 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:51087 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753684Ab0JVHzL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 03:55:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=mpMmBnSKstx9DLRcTFkn7l5n9pUyXstHmlym37NJ+jQYNOxjCIg+A2Yr72JW50XNt5
         Q83T6T8CZZNxSWB/bBJ/YtOVBxD1eny+9lyVPQHv344mXS8RmbSVReoMwTI+9vk1T/2c
         1WVHn7Rd+eVEUwOlv7mRJCMdl9uCi2aFUGYZ4=
MIME-Version: 1.0
In-Reply-To: <4CC0CA8E.4050600@monstr.eu>
References: <1287672077-5797-1-git-send-email-akinobu.mita@gmail.com>
	<1287672077-5797-23-git-send-email-akinobu.mita@gmail.com>
	<4CC0CA8E.4050600@monstr.eu>
Date: Fri, 22 Oct 2010 16:55:10 +0900
Message-ID: <AANLkTikgRWWH0RhR2S5cFE+jkJbW30Arwsjic4UANuVd@mail.gmail.com>
Subject: Re: [PATCH v2 22/22] bitops: remove minix bitops from asm/bitops.h
From: Akinobu Mita <akinobu.mita@gmail.com>
To: monstr@monstr.eu
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Ungerer <gerg@uclinux.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Roman Zippel <zippel@linux-m68k.org>,
        Andreas Schwab <schwab@linux-m68k.org>, linux-m68k@vger.kernel.org,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux390@de.ibm.com,
        linux-s390@vger.kernel.org,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        microblaze-uclinux@itee.uq.edu.au,
        "David S. Miller" <davem@davemloft.net>, sparclinux@vger.kernel.org,
        Hirokazu Takata <takata@linux-m32r.org>, linux-m32r@ml.linux-m32r.org,
        Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
        Paul Mundt <lethal@linux-sh.org>, linux-sh@vger.kernel.org,
        Chris Zankel <chris@zankel.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/10/22 Michal Simek <monstr@monstr.eu>:
> Akinobu Mita wrote:
>> minix bit operations are only used by minix filesystem and useless
>> by other modules. Because byte order of inode and block bitmaps is
>> defferent on each architecture like below:
>>
>> m68k:
>>       big-endian 16bit indexed bitmaps
>>
>> h8300, microblaze, s390, sparc, m68knommu:
>>       big-endian 32 or 64bit indexed bitmaps
>
> Just one small fix microblaze little endian support is ready for merging
> to mainline which means that microblaze is
> big-endian 32bit  and  little-endian 32bit
>
>>
>> m32r, mips, sh, xtensa:
>>       big-endian 32 or 64bit indexed bitmaps for big-endian mode
>>       little-endian bitmaps for little-endian mode
>>
>> Others:
>>       little-endian bitmaps
>>
>> In order to move minix bit operations from asm/bitops.h to
>> architecture independent code in minix file system, this provides two
>> config options.
>>
>> CONFIG_MINIX_FS_BIG_ENDIAN_16BIT_INDEXED is only selected by m68k.
>> CONFIG_MINIX_FS_NATIVE_ENDIAN is selected by the architectures which
>> use native byte order bitmaps (h8300, microblaze, s390, sparc,
>> m68knommu, m32r, mips, sh, xtensa).
>> The architectures which always use little-endian bitmaps do not select
>> these options.
>
> I haven't created any Kconfig option for little/big endian microblaze
> but there should be a little bit different handling for MINIX_FS_NATIVE_ENDIAN
> as you are describing above.
> Anyway I think you don't need to reflect this in your patch because
> we are not using that filesystem and I will write it to my to-do list and
> will fix it later.

If upcomming microblade little-endian mode will use little-endian
bitmaps for minixfs, microblade can continue to select
CONFIG_MINIX_FS_NATIVE_ENDIAN and you don't need to change it.

But if it will use big-endian bitmaps, it may need some extra work
to support it. Becuase there is no little-endian architecture
which uses bit-endian bitmaps for minixfs.

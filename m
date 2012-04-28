Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752322Ab2D1IqL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2012 04:46:11 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:61965 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751015Ab2D1IqG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2012 04:46:06 -0400
MIME-Version: 1.0
In-Reply-To: <20120427165306.GC14743@mudshark.cambridge.arm.com>
References: <1335523376-14695-1-git-send-email-will.deacon@arm.com>
	<201204271217.50048.vapier@gentoo.org>
	<20120427165306.GC14743@mudshark.cambridge.arm.com>
Date: Sat, 28 Apr 2012 10:46:04 +0200
X-Google-Sender-Auth: MHSBauItwzvjiPQoBxkPkkGZmrc
Message-ID: <CAMuHMdV91reiQhg-62h8O8m575NWj4YOk0JmZ=0euwKGUVN5Kg@mail.gmail.com>
Subject: Re: [PATCH 1/2] asm-generic: io: remove {read,write} string functions
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Will Deacon <will.deacon@arm.com>
Cc: Mike Frysinger <vapier@gentoo.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "uclinux-dist-devel@blackfin.uclinux.org" 
	<uclinux-dist-devel@blackfin.uclinux.org>,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27, 2012 at 18:53, Will Deacon <will.deacon@arm.com> wrote:
> On Fri, Apr 27, 2012 at 05:17:47PM +0100, Mike Frysinger wrote:
>> On Friday 27 April 2012 06:42:55 Will Deacon wrote:
>> > The {read,write}s{b,w,l} functions are not defined across all
>> > architectures and therefore shouldn't be used by portable drivers. We
>> > should encourage driver writers to use the io{read,write}{8,16,32}_rep
>> > functions instead.
>>
>> well, that isn't true today as a grep of the drivers/ tree shows.  perhaps we
>> should fix that first ?  quite a number of architectures do implement these.
>
> Sure, and architectures can continue to implement these if they're using
> drivers that require them (I'll reintroduce them for blackfin). They
> shouldn't be used for new architectures though, so any drivers that are
> required by folks using asm-generic/io.h will need converting.

Doh, I'm just about to introduce them for m68k for 3.5...
https://lkml.org/lkml/2012/4/21/161

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds

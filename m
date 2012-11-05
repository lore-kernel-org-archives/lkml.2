Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753271Ab2KEIF0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 03:05:26 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:47629 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752209Ab2KEIFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 03:05:24 -0500
MIME-Version: 1.0
In-Reply-To: <5096EE29.8090304@suse.cz>
References: <1350646126-28537-1-git-send-email-jslaby@suse.cz>
	<CAMuHMdWzNxhs1+14qwr0=G+_uGVWm9QKb4wBDBy-6rx5+pxv7w@mail.gmail.com>
	<5096EE29.8090304@suse.cz>
Date: Mon, 5 Nov 2012 09:05:22 +0100
X-Google-Sender-Auth: km7xDS_H8qrqLQ9ROd2XrVV80NU
Message-ID: <CAMuHMdVH0Q6yjezDEqEF5483Dj6EdV-a4izq8=doWgzsz6YDQg@mail.gmail.com>
Subject: Re: [PATCH 1/1] HID: microsoft, fix invalid rdesc for 3k kbd
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Jiri Slaby <jirislaby@gmail.com>, jkosina@suse.cz,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

On Sun, Nov 4, 2012 at 11:37 PM, Jiri Slaby <jslaby@suse.cz> wrote:
> On 11/04/2012 10:06 PM, Geert Uytterhoeven wrote:
>> On Fri, Oct 19, 2012 at 1:28 PM, Jiri Slaby <jslaby@suse.cz> wrote:
>>> +       if ((quirks & MS_RDESC_3K) && *rsize == 106 &&
>>> +                       !memcmp((char []){ 0x19, 0x00, 0x29, 0xff },
>>> +                               &rdesc[94], 4)) {
>>
>> Which version of gcc are you using?
>
> 4.7.1. But that indeed fails too if memcmp is a macro. This is of course
> not the case for x86, so that I didn't hit that. I will post a patch to
> change this to standard array accesses. (This looked prettier though.)

On x86/32 it's also a macro, but a different one, which doesn't process the
parameters:

arch/m68k/include/asm/string.h:#define memcmp(d, s, n) __builtin_memcmp(d, s, n)
arch/x86/include/asm/string_32.h:#define memcmp __builtin_memcmp

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds

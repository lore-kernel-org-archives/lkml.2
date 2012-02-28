Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757318Ab2B1Tjc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 14:39:32 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:45228 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757287Ab2B1Tja convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 14:39:30 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of linus971@gmail.com designates 10.216.133.93 as permitted sender) smtp.mail=linus971@gmail.com; dkim=pass header.i=linus971@gmail.com
MIME-Version: 1.0
In-Reply-To: <m2d38ybvur.fsf@igel.home>
References: <CA+55aFytp=ZT++sj_P7nw9mNSKjPaqjB4srgSB6HYAAJW04-Pw@mail.gmail.com>
 <4F4B9FFE.5050709@teksavvy.com> <CA+55aFxMPOAdvu-iFL8vDzC=d1osVD91RfksLiE4sAP5Lf5oNQ@mail.gmail.com>
 <m2d38ybvur.fsf@igel.home>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 28 Feb 2012 11:39:09 -0800
X-Google-Sender-Auth: iD6S7dPo5x4UIPM7IZ3r_iN3_hI
Message-ID: <CA+55aFzqOAgrCYWmY1JkXqfGFLjYO0ohe_FZF-WHVgp_CPf0Mg@mail.gmail.com>
Subject: Re: Linux 3.3-rc5
To: Andreas Schwab <schwab@linux-m68k.org>
Cc: Mark Lord <kernel@teksavvy.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 28, 2012 at 11:29 AM, Andreas Schwab <schwab@linux-m68k.org> wrote:
>
> Originally the garbage looked like this:
>
> #define I8K_BIOS_VERSION       _IOR ('i', 0x80, 4)
> #define I8K_MACHINE_ID         _IOR ('i', 0x81, 16)
> #define I8K_POWER_STATUS       _IOR ('i', 0x82, sizeof(int))
> #define I8K_FN_STATUS          _IOR ('i', 0x83, sizeof(int))
> #define I8K_GET_TEMP           _IOR ('i', 0x84, sizeof(int))
> #define I8K_GET_SPEED          _IOWR('i', 0x85, sizeof(int))
> #define I8K_GET_FAN            _IOWR('i', 0x86, sizeof(int))
> #define I8K_SET_FAN            _IOWR('i', 0x87, sizeof(int)*2)
>
> Later they were modified by "[PATCH] use size_t for the broken ioctl
> numbers" and "Fix more ioctl _IOR/_IOW misusage." (see tglx's history
> tree).

Ahh, yes. That wasn't the only driver that did the "sizeof" by hand,
and as a result got "size_t" when the (nested) *real* sizeof then
happened.

That explains the history behind the garbage.

ioctl numbering have always been pretty painful. Oh, how I wish they
had been ASCII strings rather than random binary blobs. But that's the
way things are (and we certainly screwed up a few /proc files too, so
it's not like using text fixes all potential for screwing up)

                 Linus

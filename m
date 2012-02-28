Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030360Ab2B1T3H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 14:29:07 -0500
Received: from mail-out.m-online.net ([212.18.0.9]:47693 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030279Ab2B1T3F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 14:29:05 -0500
X-Auth-Info: UyQaBoEWwoxuzQsRTtL566dxHMrUnhjwCy45ACvgvKk=
From: Andreas Schwab <schwab@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mark Lord <kernel@teksavvy.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 3.3-rc5
References: <CA+55aFytp=ZT++sj_P7nw9mNSKjPaqjB4srgSB6HYAAJW04-Pw@mail.gmail.com>
	<4F4B9FFE.5050709@teksavvy.com>
	<CA+55aFxMPOAdvu-iFL8vDzC=d1osVD91RfksLiE4sAP5Lf5oNQ@mail.gmail.com>
X-Yow: There's a SALE on STRETCH SOCKS down at the "7-11"!!
Date: Tue, 28 Feb 2012 20:29:00 +0100
In-Reply-To: <CA+55aFxMPOAdvu-iFL8vDzC=d1osVD91RfksLiE4sAP5Lf5oNQ@mail.gmail.com>
	(Linus Torvalds's message of "Tue, 28 Feb 2012 10:30:30 -0800")
Message-ID: <m2d38ybvur.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.94 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> I also think that your explanation is wrong. The problem is not the
> use of _IOR() at all, the problem is that the data structure given
> *to* the _IOR() macro is complete grabage. For example:
>
>   #define I8K_GET_SPEED           _IOWR('i', 0x85, size_t)

Originally the garbage looked like this:

#define I8K_BIOS_VERSION       _IOR ('i', 0x80, 4)
#define I8K_MACHINE_ID         _IOR ('i', 0x81, 16)
#define I8K_POWER_STATUS       _IOR ('i', 0x82, sizeof(int))
#define I8K_FN_STATUS          _IOR ('i', 0x83, sizeof(int))
#define I8K_GET_TEMP           _IOR ('i', 0x84, sizeof(int))
#define I8K_GET_SPEED          _IOWR('i', 0x85, sizeof(int))
#define I8K_GET_FAN            _IOWR('i', 0x86, sizeof(int))
#define I8K_SET_FAN            _IOWR('i', 0x87, sizeof(int)*2)

Later they were modified by "[PATCH] use size_t for the broken ioctl
numbers" and "Fix more ioctl _IOR/_IOW misusage." (see tglx's history
tree).

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."

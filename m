Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754762Ab1BGTd1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 14:33:27 -0500
Received: from mail.perches.com ([173.55.12.10]:3628 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754702Ab1BGTd0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 14:33:26 -0500
Subject: Re: [PATCH] printk-formats.txt documentation update
From: Joe Perches <joe@perches.com>
To: Andrew Murray <amurray@mpcdata.com>
Cc: Wolfram Sang <w.sang@pengutronix.de>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        linux-embedded@vger.kernel.org,
        linux kernel <linux-kernel@vger.kernel.org>, trivial@kernel.org,
        rdunlap@xenotime.net
In-Reply-To: <AANLkTi=zbmf6QQ2qgv6jf_SJ_GwF=8XPW4CCs-9AJ16B@mail.gmail.com>
References: <AANLkTikj+FU8OF_-KFr2hmTSWqTHMK5JnrnTVyn-XtxQ@mail.gmail.com>
	 <AANLkTimcFvq-cSpain--STuVVg3dUJeTCDrykQ=24egg@mail.gmail.com>
	 <AANLkTimsTJ4smnJUfkvYEkJixKQoZNfq6RHU4moLhT0o@mail.gmail.com>
	 <AANLkTi=bHe_h1F6Lh=rv6BXmVzkyPSW9u5EKXxpYGuL_@mail.gmail.com>
	 <20110207092930.GA3123@pengutronix.de>
	 <AANLkTi=zbmf6QQ2qgv6jf_SJ_GwF=8XPW4CCs-9AJ16B@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 07 Feb 2011 11:33:25 -0800
Message-ID: <1297107205.17359.61.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-02-07 at 18:12 +0000, Andrew Murray wrote:
> On 7 February 2011 09:29, Wolfram Sang <w.sang@pengutronix.de> wrote:
> > On Sun, Feb 06, 2011 at 04:23:09PM +0000, Andrew Murray wrote:
> >> +
> >> +     For printing kernel pointers which should be hidden from unprivileged
> >> +     users. The behaviour of %pK depends on the kptr_resrict sysctl - see
> >
> > Typo: Should be kptr_restrict.
> Updated patch:

trivia:

> diff --git a/Documentation/printk-formats.txt b/Documentation/printk-formats.txt
[]
> +Kernel Pointers:
> +
> +	%pK	0x0

Bad example, leading zeros are emitted.

	%pK	0x01234567 or 0x01234567890abcdef

depending on 32/64 bit. For 2.6.38, output should be 0x00000000
for a 0 if kptr_restrict is set, "(null)" or value otherwise.

> +	For printing kernel pointers which should be hidden from unprivileged
> +	users. The behaviour of %pK depends on the kptr_restrict sysctl - see
> +	Documentation/sysctl/kernel.txt for more details.
> +
> +Struct Resources:
> +
> +	%pr	[mem 0x60000000-0x6fffffff flags 0x2200]
> +	%pR	[mem 0x60000000-0x6fffffff pref]
> +
> +	For printing struct resources. The 'R' and 'r' specifiers result in a
> +	printed resource with ('R') or without ('r') a decoded flags member.

Same issue, mem resources are printed using sizeof(resource_size_t) * 2

> +IPv6 addresses:
> +
> +	%pI6	0001:0002:0003:0004:0005:0006:0007:0008
> +	%pi6	00010002000300040005000600070008
> +	%pI6c	1:2:3:4:5:6:7:8
> +
> +	For printing IPv6 network-order 16 bit hex addresses. The 'I6' and 'i6'
> +	specifiers result in a printed address with ('I6') or without ('i6')
> +	colon-separators. Leading zeros are always used.
> +
> +	The additional 'c' specifier can be used with the 'I' specifier to
> +	print a compressed IPv6 address as described by
> +	http://tools.ietf.org/html/draft-ietf-6man-text-addr-representation-00.

It's probably better to use:

	http://tools.ietf.org/html/rfc5952

> +
> +UUID/GUID addresses:
> +
> +	%pU	00010203-0506-0708-090a-0b0c0d0e0fff

What happened to 04?

It's probably easier/simpler to just show all possible
output styles.  Assuming an in memory incrementing
16 byte array, output is:

	%pU	00010203-0405-0607-08090a0b0c0d0e0f
	
> +	%pU[bBlL]

	%pUb	00010203-0405-0607-08090a0b0c0d0e0f
	%pUB	00010203-0405-0607-08090A0B0C0D0E0F
	%pUl	03020100-0504-0706-08090a0b0c0d0e0f
	%pUL	03020100-0504-0706-08090A0B0E0D0E0F

> +	For printing 16 byte UUID/GUIDs addresses. The additional 'l', 'L',
> +	'b' and 'B' specifiers are used to specify a little endian order in
> +	lower ('l') or upper case ('L') hex characters - and big endian order
> +	in lower ('b') or upper case ('B') hex characters.
> +
> +	Where no additional specifiers are used the default little endian
> +	order with lower case hex characters will be printed.
> +
> +struct va_format:
> +
> +	%pV	
> +
> +	For printing struct va_format structures. These contain a format string
> +	and va_list as follows:
> +
> +	struct va_format {
> +		const char *fmt;
> +		va_lost *va;

va_list



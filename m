Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754555Ab1BGSOA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 13:14:00 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:44292 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753945Ab1BGSN7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 13:13:59 -0500
MIME-Version: 1.0
In-Reply-To: <20110207092930.GA3123@pengutronix.de>
References: <AANLkTikj+FU8OF_-KFr2hmTSWqTHMK5JnrnTVyn-XtxQ@mail.gmail.com>
	<AANLkTimcFvq-cSpain--STuVVg3dUJeTCDrykQ=24egg@mail.gmail.com>
	<AANLkTimsTJ4smnJUfkvYEkJixKQoZNfq6RHU4moLhT0o@mail.gmail.com>
	<AANLkTi=bHe_h1F6Lh=rv6BXmVzkyPSW9u5EKXxpYGuL_@mail.gmail.com>
	<20110207092930.GA3123@pengutronix.de>
Date: Mon, 7 Feb 2011 18:12:49 +0000
Message-ID: <AANLkTi=zbmf6QQ2qgv6jf_SJ_GwF=8XPW4CCs-9AJ16B@mail.gmail.com>
Subject: Re: [PATCH] printk-formats.txt documentation update
From: Andrew Murray <amurray@mpcdata.com>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, linux-embedded@vger.kernel.org,
        linux kernel <linux-kernel@vger.kernel.org>, trivial@kernel.org,
        rdunlap@xenotime.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7 February 2011 09:29, Wolfram Sang <w.sang@pengutronix.de> wrote:
> On Sun, Feb 06, 2011 at 04:23:09PM +0000, Andrew Murray wrote:
>> +
>> +     For printing kernel pointers which should be hidden from unprivileged
>> +     users. The behaviour of %pK depends on the kptr_resrict sysctl - see
>
> Typo: Should be kptr_restrict.

Updated patch:

From: Andrew Murray <amurray@mpc-data.co.uk>

This patch updates the incomplete documentation concerning the printk
extended format specifiers.

Signed-off-by: Andrew Murray <amurray@mpc-data.co.uk>
---
diff --git a/Documentation/printk-formats.txt b/Documentation/printk-formats.txt
index 1b5a5dd..cad0dda 100644
--- a/Documentation/printk-formats.txt
+++ b/Documentation/printk-formats.txt
@@ -1,4 +1,4 @@
-If variable is of Type,		use printk format specifier:
+f variable is of Type,		use printk format specifier:
 ---------------------------------------------------------
 		int			%d or %x
 		unsigned int		%u or %x
@@ -9,7 +9,111 @@ If variable is of Type,		use printk format specifier:
 		size_t			%zu or %zx
 		ssize_t			%zd or %zx

-Raw pointer value SHOULD be printed with %p.
+Raw pointer value SHOULD be printed with %p. The kernel supports
+the following extended format specifiers for pointer types:
+
+Symbols/Function Pointers:
+
+	%pF	versatile_init+0x0/0x110
+	%pf	versatile_init
+	%pS	versatile_init+0x0/0x110
+	%ps	versatile_init
+
+	For printing symbols and function pointers. The 'S' and 's' specifiers
+	result in the symbol name with ('S') or without ('s') offsets. Where
+	this is used on a kernel without KALLSYMS - the symbol address is
+	printed instead.
+
+	On ia64, ppc64 and parisc64 architectures function pointers are
+	actually function descriptors which must first be resolved. The 'F' and
+	'f' specifiers perform this resolution and then provide the same
+	functionality as the 'S' and 's' specifiers.
+
+Kernel Pointers:
+
+	%pK	0x0
+
+	For printing kernel pointers which should be hidden from unprivileged
+	users. The behaviour of %pK depends on the kptr_restrict sysctl - see
+	Documentation/sysctl/kernel.txt for more details.
+
+Struct Resources:
+
+	%pr	[mem 0x60000000-0x6fffffff flags 0x2200]
+	%pR	[mem 0x60000000-0x6fffffff pref]
+
+	For printing struct resources. The 'R' and 'r' specifiers result in a
+	printed resource with ('R') or without ('r') a decoded flags member.
+
+MAC/FDDI addresses:
+
+	%pM	00:01:02:03:04:05
+	%pMF	00-01-02-03-04-05
+	%pm	000102030405
+
+	For printing 6-byte MAC/FDDI addresses in hex notation. The 'M' and 'm'
+	specifiers result in a printed address with ('M') or without ('m') byte
+	separators. The default byte separator is the colon (':').
+
+	Where FDDI addresses are concerned the 'F' specifier can be used after
+	the 'M' specifier to use dash ('-') separators instead of the default
+	separator.
+
+IPv4 addresses:
+
+	%pI4	1.2.3.4
+	%pi4	001.002.003.004
+	%p[Ii][hnbl]
+	
+	For printing IPv4 dot-separated decimal addresses. The 'I4' and 'i4'
+	specifiers result in a printed address with ('i4') or without ('I4')
+	leading zeros.
+
+	The additional 'h', 'n', 'b', and 'l' specifiers are used to specify
+	host, network, big or little endian order addresses respectively. Where
+	no specifier is provided the default network/big endian order is used.
+
+IPv6 addresses:
+
+	%pI6	0001:0002:0003:0004:0005:0006:0007:0008
+	%pi6	00010002000300040005000600070008
+	%pI6c	1:2:3:4:5:6:7:8
+
+	For printing IPv6 network-order 16 bit hex addresses. The 'I6' and 'i6'
+	specifiers result in a printed address with ('I6') or without ('i6')
+	colon-separators. Leading zeros are always used.
+
+	The additional 'c' specifier can be used with the 'I' specifier to
+	print a compressed IPv6 address as described by
+	http://tools.ietf.org/html/draft-ietf-6man-text-addr-representation-00.
+
+UUID/GUID addresses:
+
+	%pU	00010203-0506-0708-090a-0b0c0d0e0fff
+	%pU[bBlL]
+
+	For printing 16 byte UUID/GUIDs addresses. The additional 'l', 'L',
+	'b' and 'B' specifiers are used to specify a little endian order in
+	lower ('l') or upper case ('L') hex characters - and big endian order
+	in lower ('b') or upper case ('B') hex characters.
+
+	Where no additional specifiers are used the default little endian
+	order with lower case hex characters will be printed.
+
+struct va_format:
+
+	%pV	
+
+	For printing struct va_format structures. These contain a format string
+	and va_list as follows:
+
+	struct va_format {
+		const char *fmt;
+		va_lost *va;
+	};
+
+	Do not use this feature without some mechanism to verify the
+	correctness of the format string and va_list arguments.

 u64 SHOULD be printed with %llu/%llx, (unsigned long long):

@@ -32,4 +136,5 @@ Reminder: sizeof() result is of type size_t.
 Thank you for your cooperation and attention.


-By Randy Dunlap <rdunlap@xenotime.net>
+By Randy Dunlap <rdunlap@xenotime.net> and
+Andrew Murray <amurray@mpc-data.co.uk>

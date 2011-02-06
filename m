Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753180Ab1BFQOx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 11:14:53 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:43890 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752601Ab1BFQOv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 11:14:51 -0500
MIME-Version: 1.0
In-Reply-To: <AANLkTimcFvq-cSpain--STuVVg3dUJeTCDrykQ=24egg@mail.gmail.com>
References: <AANLkTikj+FU8OF_-KFr2hmTSWqTHMK5JnrnTVyn-XtxQ@mail.gmail.com>
	<AANLkTimcFvq-cSpain--STuVVg3dUJeTCDrykQ=24egg@mail.gmail.com>
Date: Sun, 6 Feb 2011 16:14:50 +0000
Message-ID: <AANLkTimsTJ4smnJUfkvYEkJixKQoZNfq6RHU4moLhT0o@mail.gmail.com>
Subject: Re: [PATCH] printk-formats.txt documentation update
From: Andrew Murray <amurray@mpcdata.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-embedded@vger.kernel.org,
        linux kernel <linux-kernel@vger.kernel.org>, trivial@kernel.org,
        rdunlap@xenotime.net
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6 February 2011 10:16, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> In the mean time, we also got %pV and %pK. Can you please add them as well? Thx!

Ok how about this revised patch?

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
+	users. The behaviour of %pK depends on the kptr_resrict sysctl - see
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
+	seperators. The default byte seperator is the colon (':').
+
+	Where FDDI addresses are concerned the 'F' specifier can be used after
+	the 'M' specifier to use dash ('-') seperators instead of the default
+	seperator.
+
+IPv4 addresses:
+
+	%pI4	1.2.3.4
+	%pi4	001.002.003.004
+	%p[Ii][hnbl]
+	
+	For printing IPv4 dot-seperated decminal addresses. The 'I4' and 'i4'
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
+	colon-seperaters. Leading zeros are always used.
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
+	'b' and 'B' specifiers are used to specifiy a little endian order in
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

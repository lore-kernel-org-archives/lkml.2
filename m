Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755375Ab1FIT72 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 15:59:28 -0400
Received: from oproxy12-pub.bluehost.com ([67.222.39.55]:53823 "HELO
	oproxy12-pub.bluehost.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S1754817Ab1FIT70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 15:59:26 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=nlgCYPSZn7MQ5Amet5w28v4vcai4so8yiVReyzHd0qRHD3h1hO9lJok7bVxMoLkL0GY0jU2fmEOR0Uu6a0uTMWV2sbaNb8faKRrSxRpAG71ixaJBGxzkDEXhuHfTbfK4;
Date: Thu, 9 Jun 2011 12:45:49 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Andrew Murray <amurray@mpcdata.com>
Cc: joe@perches.com, w.sang@pengutronix.de, geert@linux-m68k.org,
        linux-embedded@vger.kernel.org, linux-kernel@vger.kernel.org,
        trivial@kernel.org, udknight@gmail.com, namhyung@gmail.com,
        Andrew Murray <amurray@mpc-data.co.uk>
Subject: Re: [PATCH] printk-formats.txt documentation update
Message-Id: <20110609124549.48117a75.rdunlap@xenotime.net>
In-Reply-To: <1307645735-24933-1-git-send-email-amurray@mpcdata.com>
References: <1307643649.1340.8.camel@leonhard>
	<1307645735-24933-1-git-send-email-amurray@mpcdata.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  9 Jun 2011 19:55:35 +0100 Andrew Murray wrote:

> From: Andrew Murray <amurray@mpc-data.co.uk>
> 
> This patch updates the incomplete documentation concerning the printk
> extended format specifiers
> 
> Signed-off-by: Andrew Murray <amurray@mpc-data.co.uk>
> ---
>  Documentation/printk-formats.txt |  119 +++++++++++++++++++++++++++++++++++++-
>  1 files changed, 117 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/printk-formats.txt b/Documentation/printk-formats.txt
> index 1b5a5dd..85a06aa 100644
> --- a/Documentation/printk-formats.txt
> +++ b/Documentation/printk-formats.txt
> @@ -9,7 +9,121 @@ If variable is of Type,		use printk format specifier:
>  		size_t			%zu or %zx
>  		ssize_t			%zd or %zx
>  
> -Raw pointer value SHOULD be printed with %p.
> +Raw pointer value SHOULD be printed with %p. The kernel supports
> +the following extended format specifiers for pointer types:
> +
> +Symbols/Function Pointers:
> +
> +	%pF	versatile_init+0x0/0x110
> +	%pf	versatile_init
> +	%pS	versatile_init+0x0/0x110
> +	%ps	versatile_init
> +	%pB	prev_fn_of_versatile_init+0x88/0x88
> +
> +	For printing symbols and function pointers. The 'S' and 's' specifiers
> +	result in the symbol name with ('S') or without ('s') offsets. Where
> +	this is used on a kernel without KALLSYMS - the symbol address is
> +	printed instead.
> +
> +	The 'B' specifier results in the symbol name with offsets and should be
> +	used when printing stack backtraces. The specifier takes into
> +	consideration the effect of compiler optimisations which may occur
> +	when tail-call's are used and marked with the noreturn GCC attribute.
> +
> +	On ia64, ppc64 and parisc64 architectures function pointers are
> +	actually function descriptors which must first be resolved. The 'F' and
> +	'f' specifiers perform this resolution and then provide the same
> +	functionality as the 'S' and 's' specifiers.
> +
> +Kernel Pointers:
> +
> +	%pK	0x01234567 or 0x0123456789abcdef
> +
> +	For printing kernel pointers which should be hidden from unprivileged
> +	users. The behaviour of %pK depends on the kptr_restrict sysctl - see
> +	Documentation/sysctl/kernel.txt for more details.
> +
> +Struct Resources:
> +
> +	%pr	[mem 0x60000000-0x6fffffff flags 0x2200] or
> +		[mem 0x0000000060000000-0x000000006fffffff flags 0x2200]
> +	%pR	[mem 0x60000000-0x6fffffff pref] or
> +		[mem 0x0000000060000000-0x000000006fffffff pref]
> +
> +	For printing struct resources. The 'R' and 'r' specifiers result in a
> +	printed resource with ('R') or without ('r') a decoded flags member.
> +
> +MAC/FDDI addresses:
> +
> +	%pM	00:01:02:03:04:05
> +	%pMF	00-01-02-03-04-05
> +	%pm	000102030405
> +
> +	For printing 6-byte MAC/FDDI addresses in hex notation. The 'M' and 'm'
> +	specifiers result in a printed address with ('M') or without ('m') byte
> +	separators. The default byte separator is the colon (':').
> +
> +	Where FDDI addresses are concerned the 'F' specifier can be used after
> +	the 'M' specifier to use dash ('-') separators instead of the default
> +	separator.
> +
> +IPv4 addresses:
> +
> +	%pI4	1.2.3.4
> +	%pi4	001.002.003.004
> +	%p[Ii][hnbl]
> +	
> +	For printing IPv4 dot-separated decimal addresses. The 'I4' and 'i4'
> +	specifiers result in a printed address with ('i4') or without ('I4')
> +	leading zeros.
> +
> +	The additional 'h', 'n', 'b', and 'l' specifiers are used to specify
> +	host, network, big or little endian order addresses respectively. Where
> +	no specifier is provided the default network/big endian order is used.
> +
> +IPv6 addresses:
> +
> +	%pI6	0001:0002:0003:0004:0005:0006:0007:0008
> +	%pi6	00010002000300040005000600070008
> +	%pI6c	1:2:3:4:5:6:7:8
> +
> +	For printing IPv6 network-order 16 bit hex addresses. The 'I6' and 'i6'

You lost the hyphen in 16-bit.  The previous patch version had it... :(

> +	specifiers result in a printed address with ('I6') or without ('i6')
> +	colon-separators. Leading zeros are always used.
> +
> +	The additional 'c' specifier can be used with the 'I' specifier to
> +	print a compressed IPv6 address as described by
> +	http://tools.ietf.org/html/rfc5952
> +
> +UUID/GUID addresses:
> +
> +	%pUb	00010203-0405-0607-0809-0a0b0c0d0e0f
> +	%pUB	00010203-0405-0607-0809-0A0B0C0D0E0F
> +	%pUl	03020100-0504-0706-0809-0a0b0c0e0e0f
> +	%pUL	03020100-0504-0706-0809-0A0B0C0E0E0F
> +
> +	For printing 16 byte UUID/GUIDs addresses. The additional 'l', 'L',

same for 16-byte

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
> +		va_list *va;
> +	};
> +
> +	Do not use this feature without some mechanism to verify the
> +	correctness of the format string and va_list arguments.
>  
>  u64 SHOULD be printed with %llu/%llx, (unsigned long long):
>  
> @@ -32,4 +146,5 @@ Reminder: sizeof() result is of type size_t.
>  Thank you for your cooperation and attention.
>  
>  
> -By Randy Dunlap <rdunlap@xenotime.net>
> +By Randy Dunlap <rdunlap@xenotime.net> and
> +Andrew Murray <amurray@mpc-data.co.uk>
> -- 
> 1.7.4.1
> 


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***

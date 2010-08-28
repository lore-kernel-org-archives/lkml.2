Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752635Ab0H1J5J (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Aug 2010 05:57:09 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:64738 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752095Ab0H1J5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Aug 2010 05:57:07 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [PATCH v2] ARM: uaccess: Implement strict user copy checks
Date: Sat, 28 Aug 2010 11:56:56 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35+; KDE/4.5.0; x86_64; ; )
Cc: Stephen Boyd <sboyd@codeaurora.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
References: <4C61EE55.5030506@codeaurora.org> <4C7867D4.10404@codeaurora.org> <20100828074304.GA2183@osiris.boeblingen.de.ibm.com>
In-Reply-To: <20100828074304.GA2183@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201008281156.56958.arnd@arndb.de>
X-Provags-ID: V02:K0:USVWTCf0GeAlJVV89kqHN8z/g2n5navIXgavaEmam0V
 NRdrNv2Vn7PO9mkfISgp+3p6WwgkjqzxidPVjD0c7dJiL+xDdD
 lXylpgir9VZNk2KnUXjceQeWRLymvoDfofWbc3jH+xvPzQ6K3/
 WlKvH8RbtHZ3LHTM1Gb/4Vpr0UPbtdW660o/3hn9WP8Jx1usBS
 E2QUXVLnojSJWwQMgIPAQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 28 August 2010 09:43:04 Heiko Carstens wrote:
> In function 'copy_from_user',
>     inlined from '__tun_chr_ioctl' at drivers/net/tun.c:1200:
> /linux-2.6/arch/s390/include/asm/uaccess.h:297: warning: call to 'copy_from_user_overflow' declared with attribute warning: copy_from_user() buffer size is not provably correct

I wrote this one, and I can't think of an easy way to do fix
it without increasing the code complexity or size.

> In function 'copy_from_user',
>     inlined from 'write_file_bool' at fs/debugfs/file.c:434:
> /linux-2.6/arch/s390/include/asm/uaccess.h:297: warning: call to 'copy_from_user_overflow' declared with attribute warning: copy_from_user() buffer size is not provably correct
> In function 'copy_from_user',
>     inlined from 'packet_getsockopt' at net/packet/af_packet.c:2123:
> /linux-2.6/arch/s390/include/asm/uaccess.h:297: warning: call to 'copy_from_user_overflow' declared with attribute warning: copy_from_user() buffer size is not provably correct

These look like the compiler is not smart enough. Both make sure
that we copy at most the size of the object, or less if the user
didn't pass all of it.

> In function 'copy_from_user',
>     inlined from 'compat_sys_socketcall' at net/compat.c:783:
> /linux-2.6/arch/s390/include/asm/uaccess.h:297: warning: call to 'copy_from_user_overflow' declared with attribute warning: copy_from_user() buffer size is not provably correct

I don't think the compiler has a chance to figure this one out.
However, I don't see the warning on x86. Maybe x86-gcc has
a bug.

	Arnd

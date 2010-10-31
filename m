Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756493Ab0JaRo0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Oct 2010 13:44:26 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:61772 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756093Ab0JaRoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Oct 2010 13:44:24 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Igor Zhbanov <izh1979@gmail.com>
Subject: Re: Why get/put_unaligned are hidden behind #ifdef __KERNEL__ on PowerPC and Microblaze?
Date: Sun, 31 Oct 2010 18:45:04 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <AANLkTimtfUXN9oTQ=BaxNz+h+mgwFBPrzN_Nggbai+ZJ@mail.gmail.com> <m2bp6apelh.fsf@igel.home> <AANLkTimGUUhYgSQ6dCBtyaY5s1JQOqewU2RA78t4p8_6@mail.gmail.com>
In-Reply-To: <AANLkTimGUUhYgSQ6dCBtyaY5s1JQOqewU2RA78t4p8_6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201010311845.04560.arnd@arndb.de>
X-Provags-ID: V02:K0:M3ZL5OMnyd3O3fu5SdC3o+velc+4sUZiMfHu6TzmS6Y
 0/4qUbt9uNU/kCmDNVzo12enxkbz9YCI9dR3E4x/tKQVQSlzM3
 4biFC3ETZrmI70/qXiZ/fzhLhyr18hXXY5ZZ5ksTkjocI3xIiw
 HqEtq4nF42w9wXUyDN8rFXRvLrH1sgoWG47yzgvaifp6Or2Wn3
 k6Aa6X1DQELDxxTzagBzQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 31 October 2010, Igor Zhbanov wrote:
> 2010/10/31 Andreas Schwab <schwab@linux-m68k.org>:

> I think that unaligned memory access interface are stable, so it can
> be safely exported
> to user space. We have some other platform-related exported headers,
> e.g. <asm/byteorder.h>,
> so why not to export <asm/unaligned.h>. Let it be "official" way to
> deal with unaligned data
> in user space too.

There are libraries to deal with stuff like this. The kernel headers
are in no way a portable way to do this and any code that tries to
use them in this way would not even be portable across different
distribution that put the kernel headers in different places or
to architectures that define these functions as extern.

If you need something like get_unaligned, look in places like
http://ccan.ozlabs.org or http://www.gnu.org/software/gnulib/.

You can also use a generic gcc based implementation that uses
attribute((packed)) for unaligned access.

	Arnd

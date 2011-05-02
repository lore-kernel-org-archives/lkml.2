Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932285Ab1EBPS4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 11:18:56 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57528 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757510Ab1EBPSw convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 11:18:52 -0400
MIME-Version: 1.0
In-Reply-To: <web-516390660@zbackend1.aha.ru>
References: <web-516390660@zbackend1.aha.ru>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 2 May 2011 08:17:58 -0700
Message-ID: <BANLkTikGZ8=qZauTfMxsOcXkCEq+X1TQUw@mail.gmail.com>
Subject: Re: 2.6.39-rc5-git2 boot crashs
To: werner <w.landgraf@ru.ru>
Cc: jaxboe@fusionio.com, tj@kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 1, 2011 at 11:54 PM, werner <w.landgraf@ru.ru> wrote:
>
> Then I gone back almost to my normal / everythingyes config, but I disabled
> CONFIG_MSC_FILESYSTEMS and CONFIG-MTD , also ACPI-APEI because it needs
> PSTORE of the 1st one.

Ok, good.

> With them disabled: šThe 1st booting in grafic mode was normally. I also
> could unzip a 120 MB file (what before with the everythingyes config
> crashed). š However, if I tried to unzip an appr. 500 MB file, it crashed.

So that didn't help. Let's disable some other things too.

Start off by disabling CONFIG_IDE, because you don't need it and maybe
it does stomp on the SATA stuff somehow (on your computer, you
_should_ be using just SATA_NV, I think).

But I also notice that you have enabled the X86 "extended platform"
support, and in particular CONFIG_X86_ELAN, and that will disable all
the normal CPU logic. So please turn off CONFIG_X86_EXTENDED_PLATFORM
too, and use the "normal" x86 support.

Turn off CONFIG_EISA and CONFIG_MCA too, in order to limit things a bit.

Let's see if that makes any difference.

                      Linus

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752549Ab1GXWFE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jul 2011 18:05:04 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:36864 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752423Ab1GXWFA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jul 2011 18:05:00 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFxakA2U+oMJ1T7awTYa+p6xp9N0aCbfrUqgkF7BJ8gnQw@mail.gmail.com>
References: <CA+55aFxakA2U+oMJ1T7awTYa+p6xp9N0aCbfrUqgkF7BJ8gnQw@mail.gmail.com>
Date: Sun, 24 Jul 2011 18:04:59 -0400
Message-ID: <CACqU3MX1ovaEO-n0TLXdfuCYkSO0+DedkBKuycmrc-t1FLa91w@mail.gmail.com>
Subject: Re: Linux 3.0 release
From: Arnaud Lacombe <lacombar@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg KH <greg@kroah.com>, Yoshinori Sato <ysato@users.sourceforge.jp>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Jul 21, 2011 at 10:59 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> So there it is. Gone are the 2.6.<bignum> days, and 3.0 is out.
> [...]
For the record, if anybody cares, arch/h8300 no longer configure since 2.6.38:

% make ARCH=h8300 menuconfig
make: h8300-elf-gcc: Command not found
  HOSTCC  scripts/basic/fixdep
  HOSTCC  scripts/kconfig/conf.o
  HOSTCC  scripts/kconfig/lxdialog/checklist.o
  HOSTCC  scripts/kconfig/lxdialog/inputbox.o
  HOSTCC  scripts/kconfig/lxdialog/menubox.o
  HOSTCC  scripts/kconfig/lxdialog/textbox.o
  HOSTCC  scripts/kconfig/lxdialog/util.o
  HOSTCC  scripts/kconfig/lxdialog/yesno.o
  HOSTCC  scripts/kconfig/mconf.o
  SHIPPED scripts/kconfig/zconf.tab.c
  SHIPPED scripts/kconfig/lex.zconf.c
  SHIPPED scripts/kconfig/zconf.hash.c
  HOSTCC  scripts/kconfig/zconf.tab.o
  HOSTLD  scripts/kconfig/mconf
scripts/kconfig/mconf Kconfig
arch/h8300/Kconfig:198: can't open file "drivers/serial/Kconfig"
make[1]: *** [menuconfig] Error 1
make: *** [menuconfig] Error 2

Yes, I know I have no h8300-elf-gcc, but it does not change the fact
that the arch tries to include a non-existent file. It's been broken
by:

commit ab4382d27412e7e3e7c936e8d50d8888dfac3df8
Author: Greg Kroah-Hartman <gregkh@suse.de>
Date:   Thu Jan 13 12:10:18 2011 -0800

    tty: move drivers/serial/ to drivers/tty/serial/

    The serial drivers are really just tty drivers, so move them to
    drivers/tty/ to make things a bit neater overall.
    This is part of the tty/serial driver movement proceedure as proposed by
    Arnd Bergmann and approved by everyone involved a number of months ago.

    Cc: Arnd Bergmann <arnd@arndb.de>
    Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
    Cc: Geert Uytterhoeven <geert@linux-m68k.org>
    Cc: Rogier Wolff <R.E.Wolff@bitwizard.nl>
    Cc: Michael H. Warfield <mhw@wittsend.com>
    Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

 - Arnaud

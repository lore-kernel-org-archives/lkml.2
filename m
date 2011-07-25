Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751997Ab1GYPuu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 11:50:50 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:52766 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290Ab1GYPuq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 11:50:46 -0400
MIME-Version: 1.0
In-Reply-To: <87r55fdrs0.wl%ysato@users.sourceforge.jp>
References: <CA+55aFxakA2U+oMJ1T7awTYa+p6xp9N0aCbfrUqgkF7BJ8gnQw@mail.gmail.com>
	<CACqU3MX1ovaEO-n0TLXdfuCYkSO0+DedkBKuycmrc-t1FLa91w@mail.gmail.com>
	<87r55fdrs0.wl%ysato@users.sourceforge.jp>
Date: Mon, 25 Jul 2011 11:50:43 -0400
Message-ID: <CACqU3MWuZUG3XDxTRgBztyJa5rj-GQDcCDrLX1M-AThxtxfXRA@mail.gmail.com>
Subject: Re: Linux 3.0 release
From: Arnaud Lacombe <lacombar@gmail.com>
To: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg KH <greg@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, Jul 24, 2011 at 10:21 PM, Yoshinori Sato
<ysato@users.sourceforge.jp> wrote:
> At Sun, 24 Jul 2011 18:04:59 -0400,
> Arnaud Lacombe wrote:
>>
>> Hi,
>>
>> On Thu, Jul 21, 2011 at 10:59 PM, Linus Torvalds
>> <torvalds@linux-foundation.org> wrote:
>> >
>> > So there it is. Gone are the 2.6.<bignum> days, and 3.0 is out.
>> > [...]
>> For the record, if anybody cares, arch/h8300 no longer configure since 2.6.38:
>>
>> % make ARCH=h8300 menuconfig
>> make: h8300-elf-gcc: Command not found
>>   HOSTCC  scripts/basic/fixdep
>>   HOSTCC  scripts/kconfig/conf.o
>>   HOSTCC  scripts/kconfig/lxdialog/checklist.o
>>   HOSTCC  scripts/kconfig/lxdialog/inputbox.o
>>   HOSTCC  scripts/kconfig/lxdialog/menubox.o
>>   HOSTCC  scripts/kconfig/lxdialog/textbox.o
>>   HOSTCC  scripts/kconfig/lxdialog/util.o
>>   HOSTCC  scripts/kconfig/lxdialog/yesno.o
>>   HOSTCC  scripts/kconfig/mconf.o
>>   SHIPPED scripts/kconfig/zconf.tab.c
>>   SHIPPED scripts/kconfig/lex.zconf.c
>>   SHIPPED scripts/kconfig/zconf.hash.c
>>   HOSTCC  scripts/kconfig/zconf.tab.o
>>   HOSTLD  scripts/kconfig/mconf
>> scripts/kconfig/mconf Kconfig
>> arch/h8300/Kconfig:198: can't open file "drivers/serial/Kconfig"
>> make[1]: *** [menuconfig] Error 1
>> make: *** [menuconfig] Error 2
>>
>> Yes, I know I have no h8300-elf-gcc, but it does not change the fact
>> that the arch tries to include a non-existent file. It's been broken
>> by:
>>
>> commit ab4382d27412e7e3e7c936e8d50d8888dfac3df8
>> Author: Greg Kroah-Hartman <gregkh@suse.de>
>> Date:   Thu Jan 13 12:10:18 2011 -0800
>>
>>     tty: move drivers/serial/ to drivers/tty/serial/
>>
>>     The serial drivers are really just tty drivers, so move them to
>>     drivers/tty/ to make things a bit neater overall.
>>     This is part of the tty/serial driver movement proceedure as proposed by
>>     Arnd Bergmann and approved by everyone involved a number of months ago.
>>
>>     Cc: Arnd Bergmann <arnd@arndb.de>
>>     Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
>>     Cc: Geert Uytterhoeven <geert@linux-m68k.org>
>>     Cc: Rogier Wolff <R.E.Wolff@bitwizard.nl>
>>     Cc: Michael H. Warfield <mhw@wittsend.com>
>>     Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
>>
>>  - Arnaud
>
> Please try this fix.
> Signed-off-by: Yoshinori Sato <ysato@users.sourceforge.jp>
>
> diff --git a/arch/h8300/Kconfig b/arch/h8300/Kconfig
> index 091ed61..910e5ad 100644
> --- a/arch/h8300/Kconfig
> +++ b/arch/h8300/Kconfig
> @@ -89,125 +89,7 @@ endmenu
>
>  source "net/Kconfig"
>
> -source "drivers/base/Kconfig"
> -
> -source "drivers/mtd/Kconfig"
> -
> -source "drivers/block/Kconfig"
> -
> -source "drivers/ide/Kconfig"
> -
> -source "arch/h8300/Kconfig.ide"
> -
> -source "drivers/net/Kconfig"
> -
> -#
> -# input - input/joystick depends on it. As does USB.
> -#
> -source "drivers/input/Kconfig"
> -
> -menu "Character devices"
> -
> -config VT
> -       bool "Virtual terminal"
> -       ---help---
> -         If you say Y here, you will get support for terminal devices with
> -         display and keyboard devices. These are called "virtual" because you
> -         can run several virtual terminals (also called virtual consoles) on
> -         one physical terminal. This is rather useful, for example one
> -         virtual terminal can collect system messages and warnings, another
> -         one can be used for a text-mode user session, and a third could run
> -         an X session, all in parallel. Switching between virtual terminals
> -         is done with certain key combinations, usually Alt-<function key>.
> -
> -         The setterm command ("man setterm") can be used to change the
> -         properties (such as colors or beeping) of a virtual terminal. The
> -         man page console_codes(4) ("man console_codes") contains the special
> -         character sequences that can be used to change those properties
> -         directly. The fonts used on virtual terminals can be changed with
> -         the setfont ("man setfont") command and the key bindings are defined
> -         with the loadkeys ("man loadkeys") command.
> -
> -         You need at least one virtual terminal device in order to make use
> -         of your keyboard and monitor. Therefore, only people configuring an
> -         embedded system would want to say N here in order to save some
> -         memory; the only way to log into such a system is then via a serial
> -         or network connection.
> -
> -         If unsure, say Y, or else you won't be able to do much with your new
> -         shiny Linux system :-)
> -
> -config VT_CONSOLE
> -       bool "Support for console on virtual terminal"
> -       depends on VT
> -       ---help---
> -         The system console is the device which receives all kernel messages
> -         and warnings and which allows logins in single user mode. If you
> -         answer Y here, a virtual terminal (the device used to interact with
> -         a physical terminal) can be used as system console. This is the most
> -         common mode of operations, so you should say Y here unless you want
> -         the kernel messages be output only to a serial port (in which case
> -         you should say Y to "Console on serial port", below).
> -
> -         If you do say Y here, by default the currently visible virtual
> -         terminal (/dev/tty0) will be used as system console. You can change
> -         that with a kernel command line option such as "console=tty3" which
> -         would use the third virtual terminal as system console. (Try "man
> -         bootparam" or see the documentation of your boot loader (lilo or
> -         loadlin) about how to pass options to the kernel at boot time.)
> -
> -         If unsure, say Y.
> -
> -config HW_CONSOLE
> -       bool
> -       depends on VT && !S390 && !UM
> -       default y
> -
> -comment "Unix98 PTY support"
> -
> -config UNIX98_PTYS
> -       bool "Unix98 PTY support"
> -       ---help---
> -         A pseudo terminal (PTY) is a software device consisting of two
> -         halves: a master and a slave. The slave device behaves identical to
> -         a physical terminal; the master device is used by a process to
> -         read data from and write data to the slave, thereby emulating a
> -         terminal. Typical programs for the master side are telnet servers
> -         and xterms.
> -
> -         Linux has traditionally used the BSD-like names /dev/ptyxx for
> -         masters and /dev/ttyxx for slaves of pseudo terminals. This scheme
> -         has a number of problems. The GNU C library glibc 2.1 and later,
> -         however, supports the Unix98 naming standard: in order to acquire a
> -         pseudo terminal, a process opens /dev/ptmx; the number of the pseudo
> -         terminal is then made available to the process and the pseudo
> -         terminal slave can be accessed as /dev/pts/<number>. What was
> -         traditionally /dev/ttyp2 will then be /dev/pts/2, for example.
> -
> -         The entries in /dev/pts/ are created on the fly by a virtual
> -         file system; therefore, if you say Y here you should say Y to
> -         "/dev/pts file system for Unix98 PTYs" as well.
> -
> -         If you want to say Y here, you need to have the C library glibc 2.1
> -         or later (equal to libc-6.1, check with "ls -l /lib/libc.so.*").
> -         Read the instructions in <file:Documentation/Changes> pertaining to
> -         pseudo terminals. It's safe to say N.
> -
> -source "drivers/char/pcmcia/Kconfig"
> -
> -source "drivers/serial/Kconfig"
> -
> -source "drivers/i2c/Kconfig"
> -
> -source "drivers/hwmon/Kconfig"
> -
> -source "drivers/usb/Kconfig"
> -
> -source "drivers/uwb/Kconfig"
> -
> -endmenu
> -
> -source "drivers/staging/Kconfig"
> +source "drivers/Kconfig"
>
>  source "fs/Kconfig"
>
> diff --git a/arch/h8300/include/asm/types.h b/arch/h8300/include/asm/types.h
> index bb2c91a..b9e79bc 100644
> --- a/arch/h8300/include/asm/types.h
> +++ b/arch/h8300/include/asm/types.h
> @@ -1,29 +1 @@
> -#ifndef _H8300_TYPES_H
> -#define _H8300_TYPES_H
> -
> -#include <asm-generic/int-ll64.h>
> -
> -#if !defined(__ASSEMBLY__)
> -
> -/*
> - * This file is never included by application software unless
> - * explicitly requested (e.g., via linux/types.h) in which case the
> - * application is Linux specific so (user-) name space pollution is
> - * not a major issue.  However, for interoperability, libraries still
> - * need to be careful to avoid a name clashes.
> - */
> -
> -typedef unsigned short umode_t;
> -
> -/*
> - * These aren't exported outside the kernel to avoid name space clashes
> - */
> -#ifdef __KERNEL__
> -
> -#define BITS_PER_LONG 32
> -
> -#endif /* __KERNEL__ */
> -
> -#endif /* __ASSEMBLY__ */
> -
> -#endif /* _H8300_TYPES_H */
> +#include <asm-generic/types.h>
> diff --git a/arch/h8300/include/asm/unistd.h b/arch/h8300/include/asm/unistd.h
> index 2c3f8e6..7cdb4ea 100644
> --- a/arch/h8300/include/asm/unistd.h
> +++ b/arch/h8300/include/asm/unistd.h
> @@ -325,11 +325,37 @@
>  #define __NR_move_pages                317
>  #define __NR_getcpu            318
>  #define __NR_epoll_pwait       319
> -#define __NR_setns             320
> +#define __NR_utimensat         320
> +#define __NR_signalfd          321
> +#define __NR_timerfd_create    322
> +#define __NR_eventfd           323
> +#define __NR_fallocate         324
> +#define __NR_timerfd_settime   325
> +#define __NR_timerfd_gettime   326
> +#define __NR_signalfd4         327
> +#define __NR_eventfd2          328
> +#define __NR_epoll_create1     329
> +#define __NR_dup3              330
> +#define __NR_pipe2             331
> +#define __NR_inotify_init1     332
> +#define __NR_preadv            333
> +#define __NR_pwritev           334
> +#define __NR_rt_tgsigqueueinfo 335
> +#define __NR_perf_event_open   336
> +#define __NR_recvmmsg          337
> +#define __NR_fanotify_init     338
> +#define __NR_fanotify_mark     339
> +#define __NR_prlimit64         340
> +#define __NR_name_to_handle_at 341
> +#define __NR_open_by_handle_at  342
> +#define __NR_clock_adjtime     343
> +#define __NR_syncfs             344
> +#define __NR_sendmmsg          345
> +#define __NR_setns             346
>
>  #ifdef __KERNEL__
>
> -#define NR_syscalls 321
> +#define NR_syscalls 347
>
>  #define __ARCH_WANT_IPC_PARSE_VERSION
>  #define __ARCH_WANT_OLD_READDIR
> diff --git a/arch/h8300/kernel/syscalls.S b/arch/h8300/kernel/syscalls.S
> index f4b2e67..4cfe56c 100644
> --- a/arch/h8300/kernel/syscalls.S
> +++ b/arch/h8300/kernel/syscalls.S
> @@ -333,8 +333,34 @@ SYMBOL_NAME_LABEL(sys_call_table)
>        .long SYMBOL_NAME(sys_ni_syscall)       /* sys_move_pages */
>        .long SYMBOL_NAME(sys_getcpu)
>        .long SYMBOL_NAME(sys_ni_syscall)       /* sys_epoll_pwait */
> -       .long SYMBOL_NAME(sys_setns)            /* 320 */
> -
> +       .long SYMBOL_NAME(sys_utimensat)                /* 320 */
> +       .long SYMBOL_NAME(sys_signalfd)
> +       .long SYMBOL_NAME(sys_timerfd_create)
> +       .long SYMBOL_NAME(sys_eventfd)
> +       .long SYMBOL_NAME(sys_fallocate)
> +       .long SYMBOL_NAME(sys_timerfd_settime)  /* 325 */
> +       .long SYMBOL_NAME(sys_timerfd_gettime)
> +       .long SYMBOL_NAME(sys_signalfd4)
> +       .long SYMBOL_NAME(sys_eventfd2)
> +       .long SYMBOL_NAME(sys_epoll_create1)
> +       .long SYMBOL_NAME(sys_dup3)                     /* 330 */
> +       .long SYMBOL_NAME(sys_pipe2)
> +       .long SYMBOL_NAME(sys_inotify_init1)
> +       .long SYMBOL_NAME(sys_preadv)
> +       .long SYMBOL_NAME(sys_pwritev)
> +       .long SYMBOL_NAME(sys_rt_tgsigqueueinfo)        /* 335 */
> +       .long SYMBOL_NAME(sys_perf_event_open)
> +       .long SYMBOL_NAME(sys_recvmmsg)
> +       .long SYMBOL_NAME(sys_fanotify_init)
> +       .long SYMBOL_NAME(sys_fanotify_mark)
> +       .long SYMBOL_NAME(sys_prlimit64)                /* 340 */
> +       .long SYMBOL_NAME(sys_name_to_handle_at)
> +       .long SYMBOL_NAME(sys_open_by_handle_at)
> +       .long SYMBOL_NAME(sys_clock_adjtime)
> +       .long SYMBOL_NAME(sys_syncfs)
> +       .long SYMBOL_NAME(sys_sendmmsg)
> +       .long SYMBOL_NAME(sys_setns)
> +
>        .macro  call_sp addr
>        mov.l   #SYMBOL_NAME(\addr),er6
>        bra     SYMBOL_NAME(syscall_trampoline):8
>
With this patch, it configures, at least, but build fails with:

In file included from /src/linux/linux/include/linux/mempolicy.h:70:0,
                 from /src/linux/linux/init/main.c:49:
/src/linux/linux/include/linux/pagemap.h: In function 'fault_in_pages_readable':
/src/linux/linux/include/linux/pagemap.h:444:2: error: assignment of
read-only variable '__gu_val'
/src/linux/linux/include/linux/pagemap.h:450:5: error: assignment of
read-only variable '__gu_val'
make[2]: *** [init/main.o] Error 1
make[1]: *** [init] Error 2
make: *** [sub-make] Error 2

Cross-toolchain is baremetal binutils and gcc for their respective trunk:

$ /src/h8300/obj/destdir/bin/h8300-elf-gcc -v
Using built-in specs.
COLLECT_GCC=/src/h8300/obj/destdir/bin/h8300-elf-gcc
COLLECT_LTO_WRAPPER=/src/h8300/obj/destdir/libexec/gcc/h8300-elf/4.7.0/lto-wrapper
Target: h8300-elf
Configured with: ../gcc/configure --prefix=/src/h8300/obj/destdir
--target=h8300-elf --enable-languages=c
Thread model: single
gcc version 4.7.0 20110609 (experimental) (GCC)

 - Arnaud

> --
> Yoshinori Sato
> <ysato@users.sourceforge.jp>
>

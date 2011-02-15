Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755457Ab1BOQGJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 11:06:09 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:36384 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755157Ab1BOQGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 11:06:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=l39lFfJwUq7pRuRpVdZJec+o4yzyb+fgYcLPbaf8G8up0wVWPDHgOrzFj3qq9ZdVnO
         kv9WNe7PkywRwKoh1Qwc+Q1RutQztVbAL371iVN796umJITnHkISPxbHMLqRDYWfXRgw
         4quQKmz46AqXvuEuQF4FFT6e+ejkCWpzyd4eU=
MIME-Version: 1.0
Date: Tue, 15 Feb 2011 08:06:06 -0800
Message-ID: <AANLkTik0E+7mTWT7B0E+MmXWdEO2fBztPZT3yv69M3ig@mail.gmail.com>
Subject: Hello world from x32 glibc
From: "H.J. Lu" <hjl.tools@gmail.com>
To: GCC Development <gcc@gcc.gnu.org>,
        GNU C Library <libc-alpha@sourceware.org>,
        LKML <linux-kernel@vger.kernel.org>, x32-abi@googlegroups.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 12, 2011 at 11:41 AM, H.J. Lu <hjl.tools@gmail.com> wrote:
> Hi,
>
> We made lots of progresses on x32 pABI:
>
> https://sites.google.com/site/x32abi/
>
> 1. Kernel interface with syscall is close to be finalized.
> 2. GCC x32 branch is stabilizing.
> 3. The Bionic C library works with the syscall kernel interface.
>
> The next major milestone will be x32 glibc port.
>

[hjl@gnu-6 gcc]$ cat x.c
#include <stdio.h>

int
main ()
{
  printf ("hello world\n");
  return 0;
}
[hjl@gnu-6 gcc]$ ./xgcc -B./ -mx32 -O x.c
[hjl@gnu-6 gcc]$ ./a.out
hello world
[hjl@gnu-6 gcc]$ readelf -h a.out
ELF Header:
  Magic:   7f 45 4c 46 01 01 01 00 00 00 00 00 00 00 00 00
  Class:                             ELF32
  Data:                              2's complement, little endian
  Version:                           1 (current)
  OS/ABI:                            UNIX - System V
  ABI Version:                       0
  Type:                              EXEC (Executable file)
  Machine:                           Advanced Micro Devices X86-64
  Version:                           0x1
  Entry point address:               0x4002b0
  Start of program headers:          52 (bytes into file)
  Start of section headers:          3684 (bytes into file)
  Flags:                             0x0
  Size of this header:               52 (bytes)
  Size of program headers:           32 (bytes)
  Number of program headers:         8
  Size of section headers:           40 (bytes)
  Number of section headers:         36
  Section header string table index: 33
[hjl@gnu-6 gcc]$ /lib32/ld-linux-x32.so.2 --list ./a.out
	linux-gate.so.1 =>  (0x0012e000)
	libc.so.6 => /lib32/libc.so.6 (0xf7c74000)
	/lib32/ld-linux-x32.so.2 (0x00110000)
[hjl@gnu-6 gcc]$


-- 
H.J.

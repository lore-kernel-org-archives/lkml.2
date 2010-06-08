Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751958Ab0FHBzt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 21:55:49 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:58537 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897Ab0FHBzr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 21:55:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=X72MuQrfhfiu041bU15IMaYW3YAc72iwCC4RMnf1H1fnITCNgZmNxJN25GlwFoMrkH
         29uPgdy6W54qwGXrE/srxM5rVkoLYJ7yV3HTgQr+RG8ad1HqP8EqkO5NeTh/+ZbHRVWD
         Ztv9+msAi1J7dgfy/pgyOmmP1m4qDWTArV7f8=
MIME-Version: 1.0
In-Reply-To: <AANLkTilrmEnLrxRSYNnwr8vFaZi7R9U5vY39NmBWUEMy@mail.gmail.com>
References: <AANLkTinQatQEYahpkN3bT-S5C41HqRoH--gTrvIbGs_c@mail.gmail.com>
	<4C0D5DCD.5010201@sandeen.net>
	<AANLkTik1T2nJxsoK9UGIVy6q6pfSxniFfJXJY0InmuUh@mail.gmail.com>
	<AANLkTil4FMnGl7llR4N0PkXuNyEClQmTspNK6PT62PAi@mail.gmail.com>
	<889B6B31-A1F0-438D-B782-DBB855912854@sandeen.net>
	<AANLkTilrmEnLrxRSYNnwr8vFaZi7R9U5vY39NmBWUEMy@mail.gmail.com>
Date: Mon, 7 Jun 2010 19:55:44 -0600
Message-ID: <AANLkTil7toVuTbCExPtGMOqzqBVG3hG5JeEqzS6ZZ8T6@mail.gmail.com>
Subject: Fwd: EXT3 File System Corruption 2.6.34
From: Jeffrey Merkey <jeffmerkey@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---------- Forwarded message ----------
From: Jeffrey Merkey <jeffmerkey@gmail.com>
Date: Mon, Jun 7, 2010 at 7:55 PM
Subject: Re: EXT3 File System Corruption 2.6.34
To: Eric Sandeen <sandeen@sandeen.net>


>
> On Jun 7, 2010, at 6:55 PM, Jeffrey Merkey <jeffmerkey@gmail.com> wrote:
>
>> ---------- Forwarded message ----------
>> From: Jeffrey Merkey <jeffmerkey@gmail.com>
>> Date: Mon, Jun 7, 2010 at 5:54 PM
>> Subject: Re: EXT3 File System Corruption 2.6.34
>> To: Eric Sandeen <sandeen@sandeen.net>
>>
>>
>> REPLY TO ALL
>>
>> CONFIG_EXT3_DEFAULTS_TO_ORDERED is not set
>>
>> Whether set this way or not, should not see corruption.
>
> Here you are mistaken.  Mount with data=ordered and see.  Writeback can
> expose stale data.
>
> -Eric
>

OK.  I will set this up.  You may want to make this option the default
in the build scripts.  here is a corrupted file.  This was a .gif
image file I saved THEN AFTER SAVING THE FILE I pulled the power to
the machine and during recovery the file was FUCKED.  At any rate,
this does not happen with 2.6.28.

I dumped the file with xdump a util I use internally for my own use so
you could see the file contents as text and I could post it here.

This was an image file but look what ended up in it -- directory
blocks and such.  Take a look:

          0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F
00000000  6C 73 0A 63 64 20 2E 2E 0A 63 6C 73 0A 6C 73 0A  ls.cd ...cls.ls.
00000010  63 64 20 6C 69 6E 75 78 2D 32 2E 36 2E 33 34 2D  cd linux-2.6.34-
00000020  6D 64 62 2F 0A 63 6C 73 0A 6C 73 0A 63 64 20 2E  mdb/.cls.ls.cd .
00000030  2E 0A 63 6C 73 0A 6C 73 0A 63 64 20 6C 69 6E 75  ..cls.ls.cd linu
00000040  78 2D 32 2E 36 2E 33 34 0A 63 6C 73 0A 6C 73 0A  x-2.6.34.cls.ls.
00000050  63 64 20 2E 2E 0A 63 6C 73 0A 6C 73 0A 64 69 66  cd ...cls.ls.dif
00000060  66 20 2D 4E 61 75 72 20 6C 69 6E 75 78 2D 32 2E  f -Naur linux-2.
00000070  36 2E 33 34 20 6C 69 6E 75 78 2D 32 2E 36 2E 33  6.34 linux-2.6.3
00000080  34 2D 6D 64 62 20 3E 20 6D 64 62 2D 32 2E 36 2E  4-mdb > mdb-2.6.
00000090  33 34 2D 30 36 2D 30 35 2D 31 30 2E 70 61 74 63  34-06-05-10.patc
000000A0  68 0A 62 67 0A 6C 6C 0A 6C 6C 0A 6C 6C 0A 6C 6C  h.bg.ll.ll.ll.ll
000000B0  0A 6C 6C 0A 6C 6C 0A 6C 6C 0A 6C 6C 0A 6C 6C 0A  .ll.ll.ll.ll.ll.
000000C0  6C 6C 0A 6C 6C 0A 6C 6C 0A 6C 6C 0A 6C 6C 0A 6C  ll.ll.ll.ll.ll.l
000000D0  6C 0A 6C 6C 0A 6C 6C 0A 6C 6C 0A 6C 6C 0A 6C 6C  l.ll.ll.ll.ll.ll
000000E0  0A 6C 6C 0A 70 73 20 2D 61 78 0A 63 73 0A 63 6C  .ll.ps -ax.cs.cl
000000F0  73 0A 6C 6C 0A 6C 6C 0A 6C 6C 0A 6C 6C 0A 6C 6C  s.ll.ll.ll.ll.ll
 --- More ---

          0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F
00000100  0A 6C 6C 0A 6C 6C 0A 6C 6C 0A 6C 6C 0A 6C 6C 0A  .ll.ll.ll.ll.ll.
00000110  6C 6C 0A 6C 6C 0A 6C 6C 0A 6C 6C 0A 6C 6C 0A 6C  ll.ll.ll.ll.ll.l
00000120  6C 0A 6C 6C 0A 6C 6C 0A 6C 6C 0A 6C 6C 0A 6C 6C  l.ll.ll.ll.ll.ll
00000130  0A 6C 6C 0A 6C 6C 0A 6C 6C 0A 6C 6C 0A 6C 6C 0A  .ll.ll.ll.ll.ll.
00000140  6C 6C 0A 6C 6C 0A 6C 6C 0A 6C 6C 0A 6C 6C 0A 6C  ll.ll.ll.ll.ll.l
00000150  6C 0A 6C 6C 0A 6C 6C 0A 6C 6C 0A 63 6C 73 0A 6C  l.ll.ll.ll.cls.l
00000160  6C 0A 6C 6C 0A 6C 6C 0A 6C 6C 0A 6C 6C 0A 6C 6C  l.ll.ll.ll.ll.ll
00000170  0A 6C 6C 0A 6C 6C 0A 6C 6C 0A 6C 6C 0A 6C 6C 0A  .ll.ll.ll.ll.ll.
00000180  6C 6C 0A 6D 6F 75 6E 74 20 2F 64 65 76 2F 73 64  ll.mount /dev/sd
00000190  62 31 20 2F 63 64 72 6F 6D 0A 63 70 20 6D 64 62  b1 /cdrom.cp mdb
000001A0  2D 32 2E 36 2E 33 34 2D 30 36 2D 30 35 2D 31 30  -2.6.34-06-05-10
000001B0  2E 70 61 74 63 68 20 2F 70 72 65 64 61 74 6F 72  .patch /predator
000001C0  2F 6D 64 62 2F 0A 63 70 20 6D 64 62 2D 32 2E 36  /mdb/.cp mdb-2.6
000001D0  2E 33 34 2D 30 36 2D 30 35 2D 31 30 2E 70 61 74  .34-06-05-10.pat
000001E0  63 68 20 2F 6D 65 72 6B 65 79 64 65 62 75 67 67  ch /merkeydebugg
000001F0  65 72 2F 0A 63 70 20 6D 64 62 2D 32 2E 36 2E 33  er/.cp mdb-2.6.3
 --- More ---

          0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F
00000200  34 2D 30 36 2D 30 35 2D 31 30 2E 70 61 74 63 68  4-06-05-10.patch
00000210  20 2F 70 72 65 64 61 74 6F 72 2F 70 61 74 63 68   /predator/patch
00000220  65 73 2F 0A 63 6C 73 0A 6C 73 0A 73 79 6E 63 0A  es/.cls.ls.sync.
00000230  63 6C 73 0A 6C 73 0A 6D 6F 75 6E 74 0A 63 70 20  cls.ls.mount.cp
00000240  6D 64 62 2D 32 2E 36 2E 33 34 2D 30 36 2D 30 35  mdb-2.6.34-06-05
00000250  2D 31 30 2E 70 61 74 63 68 20 2F 63 64 72 6F 6D  -10.patch /cdrom
00000260  2F 6D 65 72 6B 65 79 64 65 62 75 67 67 65 72 2F  /merkeydebugger/
00000270  0A 63 6C 73 0A 6C 73 0A 73 79 6E 63 0A 73 79 6E  .cls.ls.sync.syn
00000280  63 0A 75 6D 6F 75 6E 74 20 2F 63 64 72 6F 6D 0A  c.umount /cdrom.
00000290  63 6C 73 0A 6C 73 0A 73 79 6E 63 0A 73 79 6E 63  cls.ls.sync.sync
000002A0  0A 63 64 20 2F 6B 65 72 6E 65 6C 2F 0A 63 6C 73  .cd /kernel/.cls
000002B0  0A 6C 73 0A 63 64 20 6C 69 6E 75 78 2D 32 2E 36  .ls.cd linux-2.6
000002C0  2E 33 34 0A 63 6C 73 0A 63 6C 73 0A 6C 73 0A 63  .34.cls.cls.ls.c
000002D0  64 20 2E 2E 0A 63 6C 73 0A 6C 73 0A 63 64 20 6C  d ...cls.ls.cd l
000002E0  69 6E 75 78 2D 32 2E 36 2E 33 34 2D 6D 64 62 2F  inux-2.6.34-mdb/
000002F0  0A 63 6C 73 0A 6C 73 0A 63 64 20 2F 0A 63 6C 73  .cls.ls.cd /.cls
 --- More ---

          0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F
00000300  0A 6C 73 0A 63 6C 73 0A 6C 73 0A 63 64 20 6D 65  .ls.cls.ls.cd me
00000310  72 6B 65 79 64 65 62 75 67 67 65 72 2F 0A 63 6C  rkeydebugger/.cl
00000320  73 0A 63 6C 73 0A 6C 73 0A 63 64 20 2F 6B 65 72  s.cls.ls.cd /ker
00000330  6E 65 6C 2F 0A 63 6C 73 0A 6C 73 0A 6C 6C 0A 76  nel/.cls.ls.ll.v
00000340  69 20 6D 64 62 2D 32 2E 36 2E 33 34 2D 30 36 2D  i mdb-2.6.34-06-
00000350  30 35 2D 31 30 2E 70 61 74 63 68 20 0A 76 69 20  05-10.patch .vi
00000360  6D 64 62 2D 32 2E 36 2E 33 34 2D 30 36 2D 30 35  mdb-2.6.34-06-05
00000370  2D 31 30 2E 70 61 74 63 68 20 0A 6C 73 0A 63 6C  -10.patch .ls.cl
00000380  73 0A 6C 73 0A 63 6C 73 0A 6C 73 0A 63 6C 73 0A  s.ls.cls.ls.cls.
00000390  6C 73 0A 76 69 20 6D 64 62 2D 32 2E 36 2E 33 34  ls.vi mdb-2.6.34
000003A0  2D 30 36 2D 30 35 2D 31 30 2E 70 61 74 63 68 20  -06-05-10.patch
000003B0  0A 76 69 20 6D 64 62 2D 32 2E 36 2E 33 34 2D 30  .vi mdb-2.6.34-0
000003C0  36 2D 30 35 2D 31 30 2E 70 61 74 63 68 20 0A 63  6-05-10.patch .c
000003D0  6C 73 0A 6C 73 0A 63 64 20 6C 69 6E 75 78 2D 32  ls.ls.cd linux-2
000003E0  2E 36 2E 33 34 2D 63 73 2F 0A 63 6C 73 0A 6C 73  .6.34-cs/.cls.ls
000003F0  0A 70 61 74 63 68 20 2D 70 31 20 3C 20 2E 2E 2F  .patch -p1 < ../
 --- More ---

          0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F
00000400  6D 64 62 2D 32 2E 36 2E 33 34 2D 30 36 2D 30 35  mdb-2.6.34-06-05
00000410  2D 31 30 2E 70 61 74 63 68 20 7C 20 6D 6F 72 65  -10.patch | more
00000420  0A 63 64 20 2E 2E 0A 63 6C 73 0A 6C 73 0A 76 69  .cd ...cls.ls.vi
00000430  20 6D 64 62 2D 32 2E 36 2E 33 34 2D 30 36 2D 30   mdb-2.6.34-06-0
00000440  35 2D 31 30 2E 70 61 74 63 68 20 0A 63 6C 73 0A  5-10.patch .cls.
00000450  6C 73 0A 76 69 20 66 66 73 2D 32 2E 36 2E 33 34  ls.vi ffs-2.6.34
00000460  2D 30 35 2D 32 36 2D 31 30 2E 70 61 74 63 68 20  -05-26-10.patch
00000470  0A 63 6C 73 0A 6C 73 0A 63 64 20 6C 69 6E 75 78  .cls.ls.cd linux
00000480  2D 32 2E 36 2E 33 34 2D 63 73 2F 0A 63 6C 73 0A  -2.6.34-cs/.cls.
00000490  6C 73 0A 6D 61 6B 65 20 6D 65 6E 75 63 6F 6E 66  ls.make menuconf
000004A0  69 67 0A 6D 61 6B 65 20 6D 65 6E 75 63 6F 6E 66  ig.make menuconf
000004B0  69 67 0A 6D 61 6B 65 20 62 7A 49 6D 61 67 65 20  ig.make bzImage
000004C0  6D 6F 64 75 6C 65 73 20 6D 6F 64 75 6C 65 73 5F  modules modules_
000004D0  69 6E 73 74 61 6C 6C 20 69 6E 73 74 61 6C 6C 0A  install install.
000004E0  76 69 20 2F 62 6F 6F 74 2F 67 72 75 62 2F 67 72  vi /boot/grub/gr
000004F0  75 62 2E 63 6F 6E 66 0A 63 6C 73 0A 6C 73 0A 73  ub.conf.cls.ls.s
 --- More ---

          0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F
00000500  79 6E 63 0A 73 79 6E 63 0A 72 65 62 6F 6F 74 0A  ync.sync.reboot.
00000510  6D 6F 64 70 72 6F 62 65 20 6D 64 62 0A 63 6C 73  modprobe mdb.cls
00000520  0A 6C 73 0A 63 64 20 2F 0A 63 6C 73 0A 6C 73 0A  .ls.cd /.cls.ls.
00000530  63 6C 73 0A 6C 73 0A 72 6D 20 2D 72 66 20 6B 64  cls.ls.rm -rf kd
00000540  62 0A 63 6C 73 0A 6C 73 0A 63 64 20 63 77 6F 72  b.cls.ls.cd cwor
00000550  74 68 79 2F 0A 63 6C 73 0A 6C 73 0A 69 66 63 6F  thy/.cls.ls.ifco
00000560  6E 0A 63 6C 0A 6C 73 0A 63 64 20 2F 0A 6C 73 0A  n.cl.ls.cd /.ls.
00000570  6C 73 0A 63 6C 73 0A 6C 73 0A 63 6C 73 0A 6C 73  ls.cls.ls.cls.ls
00000580  0A 63 64 20 6D 65 72 6B 65 79 64 65 62 75 67 67  .cd merkeydebugg
00000590  65 72 2F 0A 63 6C 73 0A 6C 73 0A 63 6C 73 0A 63  er/.cls.ls.cls.c
000005A0  6C 73 0A 6C 73 0A 65 78 69 74 0A 63 64 20 2F 70  ls.ls.exit.cd /p
000005B0  72 65 64 61 74 6F 72 2F 0A 63 6C 73 0A 6C 73 0A  redator/.cls.ls.
000005C0  6D 61 6B 65 20 63 6C 65 61 6E 0A 63 6C 73 0A 6D  make clean.cls.m
000005D0  61 6B 65 20 69 6E 73 74 61 6C 6C 0A 6D 6F 64 70  ake install.modp
000005E0  72 6F 62 65 20 63 6C 6F 75 64 73 74 72 65 61 6D  robe cloudstream
000005F0  0A 63 6C 73 0A 6C 73 0A 63 6C 73 0A 6C 73 0A 6D  .cls.ls.cls.ls.m
 --- More ---

          0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F
00000600  61 6B 65 20 64 65 70 6D 6F 64 0A 6D 6F 64 70 72  ake depmod.modpr
00000610  6F 62 65 20 63 6C 6F 75 64 73 74 72 65 61 6D 20  obe cloudstream
00000620  0A 6D 61 6B 65 20 63 6C 65 61 6E 0A 63 6C 73 0A  .make clean.cls.
00000630  6C 73 0A 6D 61 6B 65 20 69 6E 73 74 61 6C 6C 20  ls.make install
00000640  0A 6D 6F 64 70 72 6F 62 65 20 63 6C 6F 75 64 73  .modprobe clouds
00000650  74 72 65 61 6D 20 0A 6C 65 73 73 20 2F 76 61 72  tream .less /var
00000660  2F 6C 6F 67 2F 6D 65 73 73 61 67 65 73 0A 63 6C  /log/messages.cl
00000670  73 0A 6C 73 0A 63 64 20 2F 6B 65 72 6E 65 6C 2F  s.ls.cd /kernel/
00000680  6C 69 6E 75 78 2D 32 2E 36 2E 33 34 2D 63 73 2F  linux-2.6.34-cs/
00000690  0A 63 6C 73 0A 6C 73 0A 63 70 20 2E 63 6F 6E 66  .cls.ls.cp .conf
000006A0  69 67 20 2E 2E 2F 66 66 73 2D 32 2E 36 2E 33 34  ig ../ffs-2.6.34
000006B0  2E 63 6F 6E 66 69 67 0A 6D 61 6B 65 20 64 69 73  .config.make dis
000006C0  74 63 6C 65 61 6E 0A 63 6C 73 0A 63 6C 73 0A 6C  tclean.cls.cls.l
000006D0  73 0A 63 70 20 2E 2E 2F 66 66 73 2D 32 2E 36 2E  s.cp ../ffs-2.6.
000006E0  33 34 2E 63 6F 6E 66 69 67 20 2E 63 6F 6E 66 69  34.config .confi
000006F0  67 0A 63 6C 73 0A 6D 61 6B 65 20 6F 6C 64 63 6F  g.cls.make oldco
 --- More ---

          0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F
00000700  6E 66 69 67 0A 63 6C 73 0A 6C 73 0A 6D 61 6B 65  nfig.cls.ls.make
00000710  20 6D 65 6E 75 63 6F 6E 66 69 67 0A 63 6C 73 0A   menuconfig.cls.
00000720  6D 61 6B 65 20 62 7A 49 6D 61 67 65 20 6D 6F 64  make bzImage mod
00000730  75 6C 65 73 20 6D 6F 64 75 6C 65 73 5F 69 6E 73  ules modules_ins
00000740  74 61 6C 6C 20 69 6E 73 74 61 6C 6C 0A 76 69 20  tall install.vi
00000750  2F 62 6F 6F 74 2F 67 72 75 62 2F 67 72 75 62 2E  /boot/grub/grub.
00000760  63 6F 6E 66 0A 63 6C 73 0A 6C 73 0A 73 79 6E 63  conf.cls.ls.sync
00000770  0A 73 79 6E 63 0A 72 65 62 6F 6F 74 0A 63 64 20  .sync.reboot.cd
00000780  2F 0A 63 6C 73 0A 6C 73 0A 63 64 20 63 68 72 0A  /.cls.ls.cd chr.
00000790  63 6C 73 0A 6C 73 0A 6D 61 6B 65 20 63 6C 65 61  cls.ls.make clea
000007A0  6E 0A 63 6C 73 0A 6C 73 0A 63 68 6D 6F 64 20 2D  n.cls.ls.chmod -
000007B0  78 20 2A 0A 63 68 6D 6F 64 20 2D 52 20 2D 78 20  x *.chmod -R -x
000007C0  2A 0A 63 6C 73 0A 6C 73 0A 72 6D 20 2D 66 20 72  *.cls.ls.rm -f r
000007D0  65 73 65 74 5F 2A 0A 63 6C 73 0A 6C 73 0A 76 69  eset_*.cls.ls.vi
000007E0  20 74 65 6D 70 2E 63 20 0A 63 6C 73 0A 6C 73 0A   temp.c .cls.ls.
000007F0  72 6D 20 2D 66 20 74 65 6D 70 2E 63 20 0A 63 6C  rm -f temp.c .cl
 --- More ---

          0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F
00000800  73 0A 6C 73 0A 76 69 20 77 69 6B 69 74 72 61 6E  s.ls.vi wikitran
00000810  73 2E 64 61 74 20 0A 63 6C 73 0A 6C 73 0A 72 6D  s.dat .cls.ls.rm
00000820  20 2D 66 20 77 69 6B 69 74 72 61 6E 73 2E 64 61   -f wikitrans.da
00000830  74 20 0A 63 6C 73 0A 6C 73 0A 63 64 20 61 72 63  t .cls.ls.cd arc
00000840  68 69 76 65 2F 0A 63 6C 73 0A 6C 73 0A 6C 6C 0A  hive/.cls.ls.ll.
00000850  63 64 20 2E 2E 0A 63 6C 73 0A 6C 73 0A 76 69 20  cd ...cls.ls.vi
00000860  61 77 61 68 69 6C 69 2E 74 78 74 20 0A 63 6C 73  awahili.txt .cls
00000870  0A 63 6C 73 0A 6C 73 0A 72 6D 20 2D 66 20 61 77  .cls.ls.rm -f aw
00000880  61 68 69 6C 69 2E 2A 0A 63 6C 73 0A 6C 73 0A 76  ahili.*.cls.ls.v
00000890  69 20 69 6D 70 6F 72 74 5F 73 71 6C 20 0A 63 6C  i import_sql .cl
000008A0  73 0A 6C 73 0A 72 6D 20 2D 66 20 69 6D 70 6F 72  s.ls.rm -f impor
000008B0  74 5F 73 71 6C 20 0A 63 6C 73 0A 6C 73 0A 76 69  t_sql .cls.ls.vi
000008C0  20 57 69 6E 64 6F 77 73 20 0A 63 6C 73 0A 6C 73   Windows .cls.ls
000008D0  0A 63 64 20 6C 65 78 69 63 6F 6E 2F 0A 63 6C 73  .cd lexicon/.cls
000008E0  0A 6C 73 0A 6C 6C 0A 63 64 20 2E 2E 0A 63 6C 73  .ls.ll.cd ...cls
000008F0  0A 6C 73 0A 63 64 20 73 63 72 69 70 74 73 2F 0A  .ls.cd scripts/.
 --- More ---

          0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F
00000900  63 6C 73 0A 6C 73 0A 6C 6C 0A 76 69 20 63 68 65  cls.ls.ll.vi che
00000910  63 6B 69 6D 61 67 65 20 0A 63 6C 73 0A 6C 73 0A  ckimage .cls.ls.
00000920  6C 6C 0A 63 64 20 2E 2E 0A 63 6C 73 0A 6C 73 0A  ll.cd ...cls.ls.
00000930  76 69 20 77 69 6B 69 74 72 61 6E 73 2E 63 20 0A  vi wikitrans.c .
00000940  63 6C 73 0A 6C 73 0A 70 77 64 0A 63 64 20 2F 0A  cls.ls.pwd.cd /.
00000950  63 6C 73 0A 6C 73 0A 6D 6F 75 6E 74 0A 6D 6F 75  cls.ls.mount.mou
00000960  6E 74 20 2F 64 65 76 2F 73 64 62 31 20 2F 63 64  nt /dev/sdb1 /cd
00000970  72 6F 6D 0A 6D 76 20 63 68 72 20 2F 63 64 72 6F  rom.mv chr /cdro
00000980  6D 2F 63 68 72 74 72 61 6E 73 0A 63 6C 73 0A 6C  m/chrtrans.cls.l
00000990  73 0A 73 79 6E 63 0A 73 79 6E 63 0A 73 79 6E 63  s.sync.sync.sync
000009A0  0A 75 6D 6F 75 6E 74 20 2F 63 64 72 6F 6D 0A 6D  .umount /cdrom.m
000009B0  6F 75 6E 74 20 2F 64 65 76 2F 73 64 62 31 20 2F  ount /dev/sdb1 /
000009C0  63 64 72 6F 6D 0A 63 6C 73 0A 6C 73 0A 63 64 20  cdrom.cls.ls.cd
000009D0  2F 63 64 72 6F 6D 0A 63 6C 73 0A 6C 73 0A 63 64  /cdrom.cls.ls.cd
000009E0  20 63 68 72 74 72 61 6E 73 2F 0A 63 6C 73 0A 6C   chrtrans/.cls.l
000009F0  73 0A 63 64 20 2E 2E 0A 63 6C 73 0A 6C 73 0A 74  s.cd ...cls.ls.t
 --- More ---

          0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F
00000A00  61 72 20 2D 63 7A 76 66 20 63 68 72 74 72 61 6E  ar -czvf chrtran
00000A10  73 2E 74 61 72 2E 67 7A 20 63 68 72 74 72 61 6E  s.tar.gz chrtran
00000A20  73 2F 0A 7A 69 70 20 63 68 72 74 72 61 6E 73 2E  s/.zip chrtrans.
00000A30  7A 69 70 20 63 68 72 74 72 61 6E 73 2F 0A 7A 69  zip chrtrans/.zi
00000A40  70 20 2D 72 20 63 68 72 74 72 61 6E 73 2E 7A 69  p -r chrtrans.zi
00000A50  70 20 63 68 72 74 72 61 6E 73 2F 0A 63 6C 73 0A  p chrtrans/.cls.
00000A60  6C 73 0A 7A 69 70 20 2D 72 20 63 68 72 74 72 61  ls.zip -r chrtra
00000A70  6E 73 2D 30 36 2D 30 35 2D 31 30 2E 7A 69 70 20  ns-06-05-10.zip
00000A80  63 68 72 74 72 61 6E 73 2F 0A 74 61 72 20 2D 63  chrtrans/.tar -c
00000A90  7A 76 66 20 63 68 72 74 72 61 6E 73 2D 30 36 2D  zvf chrtrans-06-
00000AA0  30 35 2D 31 30 2E 74 61 72 2E 67 7A 20 63 68 72  05-10.tar.gz chr
00000AB0  74 72 61 6E 73 2F 0A 63 6C 73 0A 6C 73 0A 72 6D  trans/.cls.ls.rm
00000AC0  20 2D 66 20 63 68 72 74 72 61 6E 73 2E 7A 69 70   -f chrtrans.zip
00000AD0  20 0A 72 6D 20 2D 66 20 63 68 72 74 72 61 6E 73   .rm -f chrtrans
00000AE0  2E 74 61 72 2E 67 7A 20 0A 63 6C 73 0A 6C 73 0A  .tar.gz .cls.ls.
00000AF0  73 79 6E 63 0A 63 64 20 2F 0A 73 79 6E 63 0A 73  sync.cd /.sync.s
 --- More ---

          0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F
00000B00  79 6E 63 0A 75 6D 6F 75 6E 74 20 2F 63 64 72 6F  ync.umount /cdro
00000B10  6D 0A 73 79 6E 63 0A 73 79 6E 63 0A 63 64 20 2F  m.sync.sync.cd /
00000B20  0A 63 6C 73 0A 6C 73 0A 63 64 20 6C 69 62 2F 6D  .cls.ls.cd lib/m
00000B30  6F 64 75 6C 65 73 2F 0A 63 6C 73 0A 6C 73 0A 6C  odules/.cls.ls.l
00000B40  6C 0A 72 6D 20 2D 72 66 20 32 2E 36 2E 33 34 20  l.rm -rf 2.6.34
00000B50  26 0A 63 6C 73 0A 6C 73 0A 6C 6C 0A 63 6C 73 0A  &.cls.ls.ll.cls.
00000B60  6C 73 0A 6C 6C 0A 63 64 20 2F 0A 63 6C 73 0A 6C  ls.ll.cd /.cls.l
00000B70  73 0A 63 64 20 2F 6B 65 72 6E 65 6C 2F 0A 73 0A  s.cd /kernel/.s.
00000B80  6C 0A 6C 73 0A 6C 73 0A 63 6C 73 0A 6C 73 0A 76  l.ls.ls.cls.ls.v
00000B90  69 20 6D 64 62 2D 32 2E 36 2E 33 34 2D 30 36 2D  i mdb-2.6.34-06-
00000BA0  30 35 2D 31 30 2E 70 61 74 63 68 20 0A 63 70 20  05-10.patch .cp
00000BB0  6D 64 62 2D 32 2E 36 2E 33 34 2D 30 36 2D 30 35  mdb-2.6.34-06-05
00000BC0  2D 31 30 2E 70 61 74 63 68 20 2F 70 72 65 64 61  -10.patch /preda
00000BD0  74 6F 72 2F 70 61 74 63 68 65 73 2F 0A 63 70 20  tor/patches/.cp
00000BE0  6D 64 62 2D 32 2E 36 2E 33 34 2D 30 36 2D 30 35  mdb-2.6.34-06-05
00000BF0  2D 31 30 2E 70 61 74 63 68 20 2F 70 72 65 64 61  -10.patch /preda
 --- More ---

          0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F
00000C00  74 6F 72 2F 6D 64 62 2F 0A 63 6C 73 0A 6C 73 0A  tor/mdb/.cls.ls.
00000C10  6C 6C 0A 63 6C 73 0A 6C 73 0A 6C 6C 0A 63 64 20  ll.cls.ls.ll.cd
00000C20  6C 69 6E 75 78 2D 32 2E 36 2E 33 34 0A 70 61 74  linux-2.6.34.pat
00000C30  63 68 20 2D 70 31 20 3C 20 2E 2E 2F 6D 64 62 2D  ch -p1 < ../mdb-
00000C40  32 2E 36 2E 33 34 2D 30 36 2D 30 35 2D 31 30 2E  2.6.34-06-05-10.
00000C50  70 61 74 63 68 20 0A 70 61 74 63 68 20 2D 70 31  patch .patch -p1
00000C60  20 3C 20 2E 2E 2F 66 66 73 2D 32 2E 36 2E 33 34   < ../ffs-2.6.34
00000C70  2D 30 35 2D 32 36 2D 31 30 2E 70 61 74 63 68 20  -05-26-10.patch
00000C80  0A 63 70 20 2E 2E 2F 66 66 73 2D 32 2E 36 2E 33  .cp ../ffs-2.6.3
00000C90  34 2E 63 6F 6E 66 69 67 20 2E 63 6F 6E 66 69 67  4.config .config
00000CA0  0A 63 6C 73 0A 6D 61 6B 65 20 6F 6C 64 63 6F 6E  .cls.make oldcon
00000CB0  66 69 67 0A 6C 73 0A 63 6C 73 0A 6C 73 0A 6D 61  fig.ls.cls.ls.ma
00000CC0  6B 65 20 6D 65 6E 75 63 6F 6E 66 69 67 0A 63 6C  ke menuconfig.cl
00000CD0  73 0A 6D 61 6B 65 20 62 7A 49 6D 61 67 65 20 6D  s.make bzImage m
00000CE0  6F 64 75 6C 65 73 20 6D 6F 64 75 6C 65 73 5F 69  odules modules_i
00000CF0  6E 73 74 61 6C 6C 20 69 6E 73 74 61 6C 6C 0A 63  nstall install.c
 --- More ---

          0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F
00000D00  6C 73 0A 72 65 62 6F 6F 74 0A 63 64 20 2F 70 72  ls.reboot.cd /pr
00000D10  65 64 61 74 6F 72 2F 0A 63 6C 73 0A 6C 73 0A 6D  edator/.cls.ls.m
00000D20  61 6B 65 20 63 6C 65 61 6E 0A 63 6C 73 0A 6D 61  ake clean.cls.ma
00000D30  6B 65 20 69 6E 73 74 61 6C 6C 20 64 65 70 6D 6F  ke install depmo
00000D40  64 0A 6D 6F 64 70 72 6F 62 65 20 63 6C 6F 75 64  d.modprobe cloud
00000D50  73 74 72 65 61 6D 0A 6C 65 73 73 20 2F 76 61 72  stream.less /var
00000D60  2F 6C 6F 67 2F 6D 65 73 73 61 67 65 73 0A 63 6C  /log/messages.cl
00000D70  73 0A 6D 61 6B 65 20 63 6C 65 61 6E 0A 63 6C 73  s.make clean.cls
00000D80  0A 6C 73 0A 63 64 20 2F 6C 69 62 2F 6D 6F 64 75  .ls.cd /lib/modu
00000D90  6C 65 73 2F 0A 63 6C 73 0A 6C 73 0A 6C 6C 0A 72  les/.cls.ls.ll.r
00000DA0  6D 20 2D 72 66 20 32 2E 36 2E 33 34 4D 44 42 2F  m -rf 2.6.34MDB/
00000DB0  20 26 0A 72 6D 20 2D 72 66 20 32 2E 36 2E 33 33   &.rm -rf 2.6.33
00000DC0  20 26 0A 63 6C 73 0A 6C 73 0A 6C 6C 0A 63 64 20   &.cls.ls.ll.cd
00000DD0  2F 0A 63 6C 73 0A 6C 73 0A 63 64 20 2F 70 72 65  /.cls.ls.cd /pre
00000DE0  64 61 74 6F 72 2F 0A 63 6C 73 0A 6C 73 0A 63 61  dator/.cls.ls.ca
00000DF0  74 20 2F 70 72 6F 63 2F 76 65 72 73 69 6F 6E 20  t /proc/version
 --- More ---

          0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F
00000E00  0A 63 6C 73 0A 6C 73 0A 6D 61 6B 65 0A 63 0A 6D  .cls.ls.make.c.m
00000E10  61 6B 65 20 69 6E 73 74 61 6C 0A 6D 61 6B 65 20  ake instal.make
00000E20  69 6E 73 74 61 6C 6C 0A 63 6C 73 0A 6C 73 0A 6D  install.cls.ls.m
00000E30  6F 64 70 72 6F 62 65 20 63 6C 6F 75 64 73 74 72  odprobe cloudstr
00000E40  65 61 6D 0A 76 69 20 2F 6B 65 72 6E 65 6C 2F 6C  eam.vi /kernel/l
00000E50  69 6E 75 78 2D 32 2E 36 2E 33 34 2D 63 73 2F 4D  inux-2.6.34-cs/M
00000E60  61 6B 65 66 69 6C 65 20 0A 63 6C 73 0A 6C 73 0A  akefile .cls.ls.
00000E70  63 64 20 2F 6B 65 72 6E 65 6C 2F 6C 69 6E 75 78  cd /kernel/linux
00000E80  2D 32 2E 36 2E 33 34 2D 63 73 2F 0A 63 6C 73 0A  -2.6.34-cs/.cls.
00000E90  6C 73 0A 76 69 20 4D 61 6B 65 66 69 6C 65 20 0A  ls.vi Makefile .
00000EA0  63 6C 73 0A 6C 73 0A 6D 61 6B 65 20 62 7A 49 6D  cls.ls.make bzIm
00000EB0  61 67 65 20 6D 6F 64 75 6C 65 73 20 6D 6F 64 75  age modules modu
00000EC0  6C 65 73 5F 69 6E 73 74 61 6C 6C 20 69 6E 73 74  les_install inst
00000ED0  61 6C 6C 0A 63 6C 73 0A 63 64 20 2E 2E 0A 63 6C  all.cls.cd ...cl
00000EE0  73 0A 6C 73 0A 72 6D 20 2D 72 66 20 6C 69 6E 75  s.ls.rm -rf linu
00000EF0  78 2D 32 2E 36 2E 33 34 2D 63 73 2F 20 26 0A 72  x-2.6.34-cs/ &.r
 --- More ---

          0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F
00000F00  6D 20 2D 72 66 20 6C 69 6E 75 78 2D 32 2E 36 2E  m -rf linux-2.6.
00000F10  33 34 2D 6D 64 62 2F 20 26 0A 63 6C 73 0A 6C 73  34-mdb/ &.cls.ls
00000F20  0A 6C 6C 0A 72 6D 20 2D 72 66 20 6C 69 6E 75 78  .ll.rm -rf linux
00000F30  2D 32 2E 36 2E 33 34 20 26 0A 63 6C 73 0A 6C 73  -2.6.34 &.cls.ls
00000F40  0A 6C 6C 0A 6C 6C 0A 63 6C 73 0A 6C 73 0A 63 6C  .ll.ll.cls.ls.cl
00000F50  73 0A 6C 6C 0A 72 6D 20 2D 66 20 64 69 66 66 2E  s.ll.rm -f diff.
00000F60  74 78 74 20 0A 63 6C 73 0A 6C 6C 0A 63 70 20 66  txt .cls.ll.cp f
00000F70  66 73 2A 20 2F 70 72 65 64 61 74 6F 72 2F 70 61  fs* /predator/pa
00000F80  74 63 68 65 73 2F 0A 63 6C 73 0A 6C 73 0A 6C 6C  tches/.cls.ls.ll
00000F90  0A 63 70 20 6D 64 62 2D 32 2E 36 2E 33 34 2D 30  .cp mdb-2.6.34-0
00000FA0  36 2D 30 35 2D 31 30 2E 70 61 74 63 68 20 2F 70  6-05-10.patch /p
00000FB0  72 65 64 61 74 6F 72 2F 70 61 74 63 68 65 73 2F  redator/patches/
00000FC0  0A 63 70 20 6D 64 62 2D 32 2E 36 2E 33 34 2D 30  .cp mdb-2.6.34-0
00000FD0  36 2D 30 35 2D 31 30 2E 70 61 74 63 68 20 2F 70  6-05-10.patch /p
00000FE0  72 65 64 61 74 6F 72 2F 6D 64 62 2F 0A 63 6C 73  redator/mdb/.cls
00000FF0  0A 6C 73 0A 6C 6C 0A 63 6C 73 0A 6C 6C 0A 63 6C  .ls.ll.cls.ll.cl
 --- More ---

          0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F
00001000  73 0A 6C 73 0A 63 6C 73 0A 6C 73 0A 63 6C 73 0A  s.ls.cls.ls.cls.
00001010  6C 6C 0A 74 61 72 20 2D 78 7A 76 66 20 6C 69 6E  ll.tar -xzvf lin
00001020  75 78 2D 32 2E 36 2E 33 34 2E 74 61 72 2E 67 7A  ux-2.6.34.tar.gz
00001030  20 0A 63 6C 73 0A 6C 73 0A 63 73 6D 6F 6E 0A 63   .cls.ls.csmon.c
00001040  73 6D 6F 6E 0A 63 73 6D 6F 6E 0A 65 78 69 74 0A  smon.csmon.exit.
00001050  63 73 6D 6F 6E 0A 63 73 6D 6F 6E 0A 65 78 69 74  csmon.csmon.exit
00001060  0A 63 64 20 2F 70 72 65 64 61 74 6F 72 2F 0A 63  .cd /predator/.c
00001070  6C 73 0A 2E 2F 70 74 0A 63 6C 73 0A 2E 2F 70 74  ls../pt.cls../pt
00001080  0A 63 73 6D 6F 6E 0A 2E 2F 73 70 74 0A 72 6D 6D  .csmon../spt.rmm
00001090  6F 64 20 63 6C 6F 75 64 73 74 72 65 61 6D 0A 6D  od cloudstream.m
000010A0  6F 64 70 72 6F 62 65 20 63 6C 6F 75 64 73 74 72  odprobe cloudstr
000010B0  65 61 6D 0A 63 73 6D 6F 6E 0A 2E 2F 73 70 74 0A  eam.csmon../spt.
000010C0  63 6C 73 0A 6C 73 0A 6D 61 6B 65 20 63 6C 65 61  cls.ls.make clea
000010D0  6E 0A 63 6C 73 0A 6C 73 0A 63 64 20 2E 2E 0A 63  n.cls.ls.cd ...c
000010E0  6C 73 0A 6C 73 0A 74 61 72 20 2D 63 7A 76 66 20  ls.ls.tar -czvf
000010F0  63 6C 6F 75 64 73 74 72 65 61 6D 2E 74 61 72 2E  cloudstream.tar.
 --- More ---

          0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F
00001100  67 7A 20 2F 70 72 65 64 61 74 6F 72 2F 0A 6C 6C  gz /predator/.ll
00001110  20 2F 70 72 65 64 61 74 6F 72 2F 6D 64 62 2F 0A   /predator/mdb/.
00001120  63 6C 73 0A 6C 73 0A 63 70 20 63 6C 6F 75 64 73  cls.ls.cp clouds
00001130  74 72 65 61 6D 2E 74 61 72 2E 67 7A 20 2F 61 72  tream.tar.gz /ar
00001140  63 68 69 76 65 2F 0A 6D 6F 75 6E 74 20 2F 64 65  chive/.mount /de
00001150  76 2F 73 64 62 31 20 2F 63 64 72 6F 6D 0A 63 70  v/sdb1 /cdrom.cp
00001160  20 63 6C 6F 75 64 73 74 72 65 61 6D 2E 74 61 72   cloudstream.tar
00001170  2E 67 7A 20 2F 63 64 72 6F 6D 2F 0A 62 67 0A 63  .gz /cdrom/.bg.c
00001180  70 20 63 6C 6F 75 64 73 74 72 65 61 6D 2E 74 61  p cloudstream.ta
00001190  72 2E 67 7A 20 2F 63 64 72 6F 6D 2F 61 72 63 68  r.gz /cdrom/arch
000011A0  69 76 65 2F 0A 62 67 0A 63 6C 73 0A 6C 6C 0A 63  ive/.bg.cls.ll.c
000011B0  6C 73 0A 6C 73 0A 6D 6B 64 69 72 20 2F 63 64 72  ls.ls.mkdir /cdr
000011C0  6F 6D 2F 70 72 65 64 61 74 6F 72 0A 63 64 20 2F  om/predator.cd /
000011D0  70 72 65 64 61 74 6F 72 2F 0A 63 70 20 2D 72 76  predator/.cp -rv
000011E0  66 20 2A 20 2F 63 64 72 6F 6D 2F 70 72 65 64 61  f * /cdrom/preda
000011F0  74 6F 72 2F 0A 63 6C 73 0A 63 6C 73 0A 6C 73 0A  tor/.cls.cls.ls.
 --- More ---

          0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F
00001200  63 64 20 2F 0A 63 6C 73 0A 6C 73 0A 63 6C 73 0A  cd /.cls.ls.cls.
00001210  6C 73 0A 63 64 20 2F 70 72 65 64 61 74 6F 72 2F  ls.cd /predator/
00001220  0A 63 6C 73 0A 6D 61 6B 65 20 69 6E 73 74 61 6C  .cls.make instal
00001230  6C 20 64 65 70 6D 6F 64 0A 6D 6F 64 70 72 6F 62  l depmod.modprob
00001240  65 20 63 6C 6F 75 64 73 74 72 65 61 6D 0A 63 73  e cloudstream.cs
00001250  6D 6F 6E 0A 6C 73 0A 6C 73 0A 63 6C 73 0A 6C 73  mon.ls.ls.cls.ls
00001260  0A 76 69 20 62 69 6E 6C 72 75 2E 63 0A 67 72 65  .vi binlru.c.gre
00001270  70 20 43 41 43 48 45 5F 4C 4F 43 4B 49 4E 47 0A  p CACHE_LOCKING.
00001280  67 72 65 70 20 43 41 43 48 45 5F 4C 4F 43 4B 49  grep CACHE_LOCKI
00001290  4E 47 20 2A 2E 63 0A 76 69 20 62 69 6E 6C 72 75  NG *.c.vi binlru
000012A0  2E 63 0A 63 6C 73 0A 6C 73 0A 6D 61 6B 65 20 69  .c.cls.ls.make i
000012B0  6E 73 74 61 6C 6C 0A 72 6D 6F 64 20 63 6C 6F 75  nstall.rmod clou
000012C0  64 73 74 72 65 61 6D 0A 72 6D 6D 6F 64 20 63 6C  dstream.rmmod cl
000012D0  6F 75 64 73 74 72 65 61 6D 0A 6D 6F 64 70 72 6F  oudstream.modpro
000012E0  62 65 20 63 6C 6F 75 64 73 74 72 65 61 6D 0A 63  be cloudstream.c
000012F0  73 75 74 69 6C 20 61 63 71 75 69 72 65 20 6C 6F  sutil acquire lo
 --- More ---

          0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F
00001300  0A 63 73 6D 6F 6E 0A 72 6D 6D 6F 64 20 63 6C 6F  .csmon.rmmod clo
00001310  75 64 73 74 72 65 61 6D 0A 6D 6F 64 70 72 6F 62  udstream.modprob
00001320  65 20 63 6C 6F 75 64 73 74 72 65 61 6D 0A 63 73  e cloudstream.cs
00001330  75 74 69 6C 20 61 63 71 75 69 72 65 20 6C 6F 0A  util acquire lo.
00001340  63 73 6D 6F 6E 0A 2E 2F 70 74 0A 63 73 75 74 69  csmon../pt.csuti
00001350  6C 20 61 63 71 75 69 72 65 20 66 66 73 30 0A 2E  l acquire ffs0..
00001360  2F 73 70 74 0A 63 6C 73 0A 6C 73 0A 63 73 75 74  /spt.cls.ls.csut
00001370  69 6C 20 64 65 76 0A 63 73 75 74 69 6C 20 61 63  il dev.csutil ac
00001380  71 75 69 72 65 20 66 66 73 31 0A 63 73 75 74 69  quire ffs1.csuti
00001390  6C 20 61 63 71 75 69 72 65 20 66 66 73 32 0A 63  l acquire ffs2.c
000013A0  73 75 74 69 6C 20 61 63 71 75 69 72 65 20 66 66  sutil acquire ff
000013B0  73 33 0A 63 73 75 74 69 6C 20 64 65 76 0A 63 73  s3.csutil dev.cs
000013C0  75 74 69 6C 20 6C 6F 61 64 20 36 34 20 34 0A 2E  util load 64 4..
000013D0  2F 70 74 0A 74 61 69 6C 20 2D 66 20 2F 76 61 72  /pt.tail -f /var
000013E0  2F 6C 6F 67 2F 6D 65 73 73 61 67 65 73 0A 6C 65  /log/messages.le
000013F0  73 73 20 2F 76 61 72 2F 6C 6F 67 2F 6D 65 73 73  ss /var/log/mess
 --- More ---

          0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F
00001400  61 67 65 73 0A 67 72 65 70 20 73 63 61 6E 5F 70  ages.grep scan_p
00001410  61 72 74 69 74 69 6F 6E 73 20 2A 2E 63 0A 76 69  artitions *.c.vi
00001420  20 76 6F 6C 75 6D 65 2E 63 0A 63 6C 73 0A 6C 73   volume.c.cls.ls
00001430  0A 76 69 20 63 73 6D 6F 6E 2E 63 0A 63 6C 73 0A  .vi csmon.c.cls.
00001440  6D 61 6B 65 20 69 6E 73 74 61 6C 6C 0A 63 73 6D  make install.csm
00001450  6F 6E 0A 76 69 20 63 73 6D 6F 6E 2E 63 0A 63 6C  on.vi csmon.c.cl
00001460  73 0A 6D 61 6B 65 20 69 6E 73 74 61 6C 6C 0A 6D  s.make install.m
00001470  6F 64 70 72 6F 62 65 20 63 6C 6F 75 64 73 74 72  odprobe cloudstr
00001480  65 61 6D 0A 72 6D 6D 6F 64 20 63 6C 6F 75 64 73  eam.rmmod clouds
00001490  74 72 65 61 6D 0A 6D 6F 64 70 72 6F 62 65 20 63  tream.modprobe c
000014A0  6C 6F 75 64 73 74 72 65 61 6D 0A 63 6C 73 0A 63  loudstream.cls.c
000014B0  73 75 74 69 6C 20 61 63 71 75 69 72 65 20 6C 6F  sutil acquire lo
000014C0  0A 63 73 75 74 69 6C 20 61 63 71 75 69 72 65 20  .csutil acquire
000014D0  66 66 73 30 0A 63 73 75 74 69 6C 20 61 63 71 75  ffs0.csutil acqu
000014E0  69 72 65 20 66 66 73 31 0A 63 73 75 74 69 6C 20  ire ffs1.csutil
000014F0  61 63 71 75 69 72 65 20 66 66 73 32 0A 63 73 75  acquire ffs2.csu
 --- More ---

          0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F
00001500  74 69 6C 20 61 63 71 75 69 72 65 20 66 66 73 33  til acquire ffs3
00001510  0A 2E 2F 70 74 0A 63 73 75 74 69 6C 20 6C 6F 61  ../pt.csutil loa
00001520  64 20 36 34 20 34 0A 2E 2F 73 70 74 0A 63 6C 73  d 64 4../spt.cls
00001530  0A 63 73 75 74 69 6C 20 72 65 6C 65 61 73 65 20  .csutil release
00001540  6C 6F 0A 63 73 75 74 69 6C 20 61 63 71 75 69 72  lo.csutil acquir
00001550  65 20 6C 6F 0A 2E 2F 70 74 0A 65 78 69 74 0A 63  e lo../pt.exit.c
00001560  64 20 2F 0A 63 6C 73 0A 6C 73 0A 73 74 61 72 74  d /.cls.ls.start
00001570  78 0A 65 78 69 74 0A 63 64 20 2F 0A 63 6C 73 0A  x.exit.cd /.cls.
00001580  6C 73 0A 76 69 20 2F 62 6F 6F 74 2F 67 72 75 62  ls.vi /boot/grub
00001590  2F 67 72 75 62 2E 63 6F 6E 66 0A 63 64 20 2F 70  /grub.conf.cd /p
000015A0  72 65 64 61 74 6F 72 2F 0A 63 6C 73 0A 6C 73 0A  redator/.cls.ls.
000015B0  6D 61 6B 65 20 63 6C 65 61 6E 0A 63 6C 73 0A 6D  make clean.cls.m
000015C0  61 6B 65 20 69 6E 73 74 61 6C 6C 0A 63 6C 73 0A  ake install.cls.
000015D0  63 6C 73 0A 6C 73 0A 6D 61 6B 65 20 64 65 70 6D  cls.ls.make depm
000015E0  6F 64 0A 6D 6F 64 70 72 6F 62 65 20 63 6C 6F 75  od.modprobe clou
000015F0  64 73 74 72 65 61 6D 0A 63 73 6D 6F 6E 0A 63 73  dstream.csmon.cs
 --- More ---

          0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F
00001600  6D 6F 6E 0A 63 73 75 74 69 6C 20 61 63 71 75 69  mon.csutil acqui
00001610  72 65 20 6C 6F 0A 63 73 6D 6F 6E 0A 2E 2F 73 70  re lo.csmon../sp
00001620  74 0A 2E 2F 70 74 0A 2E 2F 73 70 74 0A 63 6C 73  t../pt../spt.cls
00001630  0A 63 6C 73 0A 6C 73 0A 63 73 6D 6F 6E 0A 76 69  .cls.ls.csmon.vi
00001640  20 63 73 6D 6F 6E 2E 63 0A 63 6C 73 0A 6D 61 6B   csmon.c.cls.mak
00001650  65 20 69 6E 73 74 61 6C 6C 0A 63 73 6D 6F 6E 0A  e install.csmon.
00001660  76 69 20 63 73 6D 6F 6E 2E 63 0A 63 6C 73 0A 63  vi csmon.c.cls.c
00001670  6C 73 0A 6C 73 0A 63 73 6D 6F 6E 0A 2E 2F 73 70  ls.ls.csmon../sp
00001680  74 0A 63 6C 73 0A 6C 73 0A 72 6D 6D 6F 64 20 63  t.cls.ls.rmmod c
00001690  6C 6F 75 64 73 74 72 65 61 6D 0A 63 6C 73 0A 76  loudstream.cls.v
000016A0  69 20 74 69 6D 65 72 2E 63 0A 63 6C 73 0A 6C 73  i timer.c.cls.ls
000016B0  0A 63 6C 73 0A 6D 6F 64 70 72 6F 62 65 20 63 6C  .cls.modprobe cl
000016C0  6F 75 64 73 74 72 65 61 6D 0A 63 6D 6F 6E 0A 63  oudstream.cmon.c
000016D0  6C 73 0A 63 73 75 74 69 6C 20 63 71 75 69 72 65  ls.csutil cquire
000016E0  20 66 66 73 30 0A 63 73 75 74 69 6C 20 61 63 71   ffs0.csutil acq
000016F0  75 69 72 65 20 66 66 73 30 0A 63 73 75 74 69 6C  uire ffs0.csutil
 --- More ---

          0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F
00001700  20 61 63 71 75 69 72 65 20 66 66 73 31 0A 63 73   acquire ffs1.cs
00001710  75 74 69 6C 20 61 63 71 75 69 72 65 20 66 66 73  util acquire ffs
00001720  32 0A 63 73 75 74 69 6C 20 61 63 71 75 69 72 65  2.csutil acquire
00001730  20 66 66 73 33 0A 63 73 75 74 69 6C 20 61 63 71   ffs3.csutil acq
00001740  75 69 72 65 20 6C 6F 0A 63 73 75 74 69 6C 20 6C  uire lo.csutil l
00001750  6F 61 64 20 36 34 20 34 0A 2E 2F 70 74 0A 2E 2F  oad 64 4../pt../
00001760  73 70 74 0A 63 73 75 74 69 6C 20 75 6C 6F 61 64  spt.csutil uload
00001770  0A 2E 2F 70 74 0A 2E 2F 70 74 0A 63 73 75 74 69  ../pt../pt.csuti
00001780  6C 20 61 63 71 75 69 72 65 20 6C 6F 0A 63 64 20  l acquire lo.cd
00001790  2F 0A 63 6C 73 0A 6C 73 0A 63 6C 73 0A 6C 73 0A  /.cls.ls.cls.ls.
000017A0  70 73 20 2D 61 78 0A 63 6C 73 0A 6C 73 0A 6D 76  ps -ax.cls.ls.mv
000017B0  20 63 6C 6F 75 64 73 74 72 65 61 6D 2E 74 61 72   cloudstream.tar
000017C0  2E 67 7A 20 2F 61 72 63 68 69 76 65 2F 0A 63 6C  .gz /archive/.cl
000017D0  73 0A 6C 73 0A 63 64 20 2F 63 64 72 6F 6D 2F 0A  s.ls.cd /cdrom/.
000017E0  63 6C 73 0A 6C 73 0A 6C 6C 0A 72 6D 20 2D 72 66  cls.ls.ll.rm -rf
000017F0  20 70 72 65 64 61 74 6F 72 2F 0A 62 67 0A 63 6C   predator/.bg.cl
 --- More ---

          0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F
00001800  73 0A 6C 73 0A 63 6C 73 0A 6C 6C 0A 63 6C 73 0A  s.ls.cls.ll.cls.
00001810  6C 73 0A 63 64 20 2F 0A 63 6C 73 0A 73 79 6E 63  ls.cd /.cls.sync
00001820  0A 63 6C 73 0A 6C 73 0A 73 79 6E 63 0A 73 79 6E  .cls.ls.sync.syn
00001830  63 0A 75 6D 6F 75 6E 74 20 2F 63 64 72 6F 6D 0A  c.umount /cdrom.
00001840  73 79 6E 63 0A 73 79 6E 63 0A 63 6C 73 0A 63 64  sync.sync.cls.cd
00001850  20 2F 70 72 65 64 61 74 6F 72 2F 0A 63 73 75 74   /predator/.csut
00001860  69 6C 20 61 63 71 75 69 72 65 20 6C 6F 0A 63 73  il acquire lo.cs
00001870  75 74 69 6C 20 64 65 76 0A 63 73 0A 63 6C 73 0A  util dev.cs.cls.
00001880  2E 2F 70 74 0A 2E 2F 73 70 74 0A 63 6C 73 0A 6C  ./pt../spt.cls.l
00001890  73 0A 2E 2F 70 74 0A 2E 2F 73 70 74 0A 63 6C 73  s../pt../spt.cls
000018A0  0A 76 69 20 62 75 67 73 2E 74 78 74 20 0A 63 6C  .vi bugs.txt .cl
000018B0  73 0A 6C 73 0A 76 69 20 62 69 6E 6C 72 75 2E 63  s.ls.vi binlru.c
000018C0  0A 63 6C 73 0A 6C 73 0A 63 6C 73 0A 6C 73 0A 6D  .cls.ls.cls.ls.m
000018D0  61 6B 65 20 63 6C 65 61 6E 0A 63 6C 73 0A 6D 61  ake clean.cls.ma
000018E0  6B 65 20 69 6E 73 74 61 6C 6C 0A 63 6C 73 0A 63  ke install.cls.c
000018F0  6C 73 0A 6C 73 0A 63 6C 73 0A 6C 73 0A 63 6C 73  ls.ls.cls.ls.cls
 --- More ---

          0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F
00001900  0A 6C 73 0A 72 6D 6D 6F 64 20 63 6C 6F 75 64 73  .ls.rmmod clouds
00001910  74 72 65 61 6D 0A 6D 6F 64 70 72 6F 62 65 20 63  tream.modprobe c
00001920  6C 6F 75 64 73 74 72 65 61 6D 0A 63 73 75 74 69  loudstream.csuti
00001930  6C 20 61 63 71 75 69 72 65 20 6C 6F 0A 63 6C 73  l acquire lo.cls
00001940  0A 63 73 6D 6F 6E 0A 2E 2F 73 70 74 0A 72 6D 6D  .csmon../spt.rmm
00001950  6F 64 20 63 6C 6F 75 64 73 74 72 65 61 6D 0A 63  od cloudstream.c
00001960  6C 73 0A 76 69 20 63 73 6D 6F 6E 2E 63 0A 63 6C  ls.vi csmon.c.cl
00001970  73 0A 6C 73 0A 76 69 20 69 6F 63 74 6C 2E 68 0A  s.ls.vi ioctl.h.
00001980  63 6C 73 0A 6C 73 0A 76 69 20 74 69 6D 65 72 2E  cls.ls.vi timer.
00001990  63 0A 76 69 20 69 6F 63 74 6C 2E 68 0A 76 69 20  c.vi ioctl.h.vi
000019A0  73 74 72 75 63 74 2E 68 0A 76 69 20 74 69 6D 65  struct.h.vi time
000019B0  72 2E 63 0A 63 6C 73 0A 6C 73 0A 76 69 20 63 73  r.c.cls.ls.vi cs
000019C0  6D 6F 6E 2E 63 0A 63 6C 73 0A 6C 73 0A 6D 61 6B  mon.c.cls.ls.mak
000019D0  65 20 69 6E 73 74 61 6C 6C 0A 6D 61 6B 65 20 63  e install.make c
000019E0  6C 65 61 6E 0A 63 6C 73 0A 6D 61 6B 65 20 69 6E  lean.cls.make in
000019F0  73 74 61 6C 6C 0A 76 69 20 63 73 6D 6F 6E 2E 63  stall.vi csmon.c
 --- More ---

          0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F
00001A00  0A 6C 73 0A 63 6C 73 0A 76 69 20 74 69 6D 65 72  .ls.cls.vi timer
00001A10  2E 63 0A 63 6C 73 0A 6D 61 6B 65 20 69 6E 73 74  .c.cls.make inst
00001A20  61 6C 6C 0A 76 69 20 74 69 6D 65 72 2E 63 0A 63  all.vi timer.c.c
00001A30  6C 73 0A 6D 61 6B 65 20 69 6E 73 74 61 6C 6C 0A  ls.make install.
00001A40  6D 6F 64 70 72 6F 62 65 20 63 6C 6F 75 64 73 74  modprobe cloudst
00001A50  72 65 61 6D 0A 63 73 0A 6C 73 0A 63 6C 73 0A 72  ream.cs.ls.cls.r
00001A60  6D 6D 6F 64 20 63 6C 6F 75 64 73 74 72 65 61 6D  mmod cloudstream
00001A70  0A 69 6E 73 6D 6F 64 20 63 6C 6F 75 64 73 74 72  .insmod cloudstr
00001A80  65 61 6D 2E 6B 6F 20 72 65 70 61 69 72 5F 6C 65  eam.ko repair_le
00001A90  76 65 6C 3D 33 0A 72 6D 6D 6F 64 20 63 6C 6F 75  vel=3.rmmod clou
00001AA0  64 73 74 72 65 61 6D 0A 6D 6F 64 70 72 6F 62 65  dstream.modprobe
00001AB0  20 63 6C 6F 75 64 73 74 72 65 61 6D 0A 63 73 75   cloudstream.csu
00001AC0  74 69 6C 20 61 63 71 75 69 72 65 20 66 66 73 30  til acquire ffs0
00001AD0  0A 63 73 75 74 69 6C 20 61 63 71 75 69 72 65 20  .csutil acquire
00001AE0  66 66 73 31 0A 63 73 75 74 69 6C 20 61 63 71 75  ffs1.csutil acqu
00001AF0  69 72 65 20 66 66 73 32 0A 63 73 75 74 69 6C 20  ire ffs2.csutil
 --- More ---

          0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F
00001B00  61 63 71 75 69 72 65 20 66 66 73 33 0A 63 73 75  acquire ffs3.csu
00001B10  74 69 6C 20 61 63 71 75 69 72 65 20 6C 6F 0A 63  til acquire lo.c
00001B20  6C 73 0A 6C 73 0A 63 6C 73 0A 63 73 6D 6F 6E 0A  ls.ls.cls.csmon.
00001B30  63 73 6D 6F 6E 0A 6D 61 6B 65 20 63 6C 65 61 6E  csmon.make clean
00001B40  0A 2E 2F 73 70 74 0A 6C 73 0A 63 6C 73 0A 63 6C  ../spt.ls.cls.cl
00001B50  73 0A 6C 73 0A 63 64 20 2F 0A 63 6C 73 0A 6C 73  s.ls.cd /.cls.ls
00001B60  0A 63 73 75 74 69 6C 20 75 6C 6F 61 64 0A 72 6D  .csutil uload.rm
00001B70  6D 6F 64 20 63 6C 6F 75 64 73 74 72 65 61 2C 0A  mod cloudstrea,.
00001B80  72 6D 6D 6F 64 20 63 6C 6F 75 64 73 74 72 65 61  rmmod cloudstrea
00001B90  6D 0A 63 6C 73 0A 6C 73 0A 63 6C 73 0A 63 6C 73  m.cls.ls.cls.cls
00001BA0  0A 6C 73 0A 63 6C 73 0A 6C 73 0A 63 6C 73 0A 6C  .ls.cls.ls.cls.l
00001BB0  73 0A 74 61 72 20 2D 63 7A 76 66 20 63 6C 6F 75  s.tar -czvf clou
00001BC0  64 73 74 72 65 61 6D 2E 74 61 72 2E 67 7A 20 2F  dstream.tar.gz /
00001BD0  70 72 65 64 61 74 6F 72 2F 0A 63 73 6D 6F 6E 0A  predator/.csmon.
00001BE0  63 6C 73 0A 6C 73 0A 65 78 69 74 0A 63 64 20 2F  cls.ls.exit.cd /
00001BF0  70 72 65 64 61 74 6F 72 2F 0A 63 6C 73 0A 6C 73  predator/.cls.ls
 --- More ---

          0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F
00001C00  0A 76 69 20 6C 6F 67 69 63 61 6C 2E 63 0A 63 6C  .vi logical.c.cl
00001C10  73 0A 6C 73 0A 6D 61 6B 65 20 69 6E 73 74 61 6C  s.ls.make instal
00001C20  6C 0A 63 6C 73 0A 6D 61 6B 65 20 63 6C 65 61 6E  l.cls.make clean
00001C30  0A 63 6C 73 0A 6D 61 6B 65 20 69 6E 73 74 61 6C  .cls.make instal
00001C40  6C 0A 6D 6F 64 70 72 6F 62 65 20 63 6C 6F 75 64  l.modprobe cloud
00001C50  73 74 72 65 61 6D 0A 63 73 75 74 69 6C 20 61 63  stream.csutil ac
00001C60  71 75 69 72 65 20 66 66 73 30 0A 63 73 75 74 69  quire ffs0.csuti
00001C70  6C 20 61 63 71 75 69 72 65 20 66 66 73 31 0A 63  l acquire ffs1.c
00001C80  73 75 74 69 6C 20 61 63 71 75 69 72 65 20 66 66  sutil acquire ff
00001C90  73 32 0A 63 73 75 74 69 6C 20 61 63 71 75 69 72  s2.csutil acquir
00001CA0  65 20 66 66 73 33 0A 63 73 75 74 69 6C 20 61 63  e ffs3.csutil ac
00001CB0  71 75 69 72 65 20 6C 6F 0A 63 73 6D 6F 6E 0A 63  quire lo.csmon.c
00001CC0  73 75 74 69 6C 20 75 6C 6F 61 64 0A 2E 2F 73 70  sutil uload../sp
00001CD0  74 0A 63 6C 73 0A 6C 73 0A 63 6C 0A 63 6C 73 0A  t.cls.ls.cl.cls.
00001CE0  6C 73 0A 63 73 6D 6F 6E 0A 74 61 69 6C 20 2D 66  ls.csmon.tail -f
00001CF0  20 2F 76 61 72 2F 6C 6F 67 2F 6D 65 73 73 61 67   /var/log/messag
 --- More ---

          0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F
00001D00  65 73 0A 63 64 20 2F 0A 63 6C 73 0A 6C 73 0A 63  es.cd /.cls.ls.c
00001D10  73 6D 6F 6E 0A 63 64 20 2F 70 72 65 64 61 74 6F  smon.cd /predato
00001D20  72 2F 0A 2E 2F 70 74 0A 2E 2F 73 70 74 0A 70 73  r/../pt../spt.ps
00001D30  20 2D 61 78 0A 6B 69 6C 6C 20 34 35 37 32 0A 73   -ax.kill 4572.s
00001D40  74 61 72 74 78 0A 63 64 20 2F 0A 63 6C 73 0A 6C  tartx.cd /.cls.l
00001D50  73 0A 63 64 20 2F 70 72 65 64 61 74 6F 72 2F 0A  s.cd /predator/.
00001D60  63 6C 73 0A 6C 73 0A 63 6C 73 0A 63 73 75 74 69  cls.ls.cls.csuti
00001D70  6C 20 6C 6F 61 64 20 31 35 30 30 20 34 0A 2E 2F  l load 1500 4../
00001D80  70 74 0A 2E 2F 73 70 74 0A 63 73 75 74 69 6C 20  pt../spt.csutil
00001D90  75 6C 6F 61 64 0A 63 73 75 74 69 6C 20 6C 6F 61  uload.csutil loa
00001DA0  64 20 31 35 30 30 20 34 0A 2E 2F 70 74 0A 2E 2F  d 1500 4../pt../
00001DB0  72 65 61 64 65 72 20 30 0A 2E 2F 73 70 74 0A 70  reader 0../spt.p
00001DC0  73 20 2D 61 78 0A 67 64 62 0A 70 73 20 2D 61 78  s -ax.gdb.ps -ax
00001DD0  0A 6B 69 6C 6C 20 34 33 34 36 0A 70 73 20 2D 61  .kill 4346.ps -a
00001DE0  78 0A 63 64 20 2F 0A 63 6C 73 0A 6C 73 0A 6B 69  x.cd /.cls.ls.ki
00001DF0  6C 6C 20 2D 73 20 39 20 34 33 34 36 0A 6B 69 6C  ll -s 9 4346.kil
 --- More ---

          0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F
00001E00  6C 20 2D 73 20 31 31 20 34 33 34 36 0A 63 64 20  l -s 11 4346.cd
00001E10  2F 70 72 65 64 61 74 6F 72 2F 0A 63 6C 73 0A 6C  /predator/.cls.l
00001E20  73 0A 76 69 20 62 75 67 73 2E 74 78 74 20 0A 63  s.vi bugs.txt .c
00001E30  6C 73 0A 6C 73 0A 70 73 20 2D 61 78 0A 72 65 62  ls.ls.ps -ax.reb
00001E40  6F 6F 74 0A 63 64 20 2E 0A 63 64 20 2E 0A 63 6B  oot.cd ..cd ..ck
00001E50  73 0A 6B 73 0A 63 6C 73 0A 63 64 20 2F 0A 63 6C  s.ks.cls.cd /.cl
00001E60  73 0A 6C 73 0A 6D 6F 64 70 72 6F 62 65 20 6D 64  s.ls.modprobe md
00001E70  62 0A 65 63 68 6F 20 61 20 3E 20 2F 70 72 6F 63  b.echo a > /proc
00001E80  2F 73 79 73 72 71 2D 74 72 69 67 67 65 72 20 0A  /sysrq-trigger .
00001E90  65 63 68 6F 20 6A 20 3E 20 2F 70 72 6F 63 2F 73  echo j > /proc/s
00001EA0  79 73 72 71 2D 74 72 69 67 67 65 72 20 0A 65 63  ysrq-trigger .ec
00001EB0  68 6F 20 31 20 3E 20 2F 70 72 6F 63 2F 73 79 73  ho 1 > /proc/sys
00001EC0  72 71 2D 74 72 69 67 67 65 72 20 0A 65 63 68 6F  rq-trigger .echo
00001ED0  20 31 20 3E 20 2F 70 72 6F 63 2F 73 79 73 72 71   1 > /proc/sysrq
00001EE0  2D 74 72 69 67 67 65 72 20 0A 65 63 68 6F 20 6A  -trigger .echo j
00001EF0  20 3E 20 2F 70 72 6F 63 2F 73 79 73 72 71 2D 74   > /proc/sysrq-t
 --- More ---

          0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F
00001F00  72 69 67 67 65 72 20 0A 65 63 68 6F 20 6A 20 3E  rigger .echo j >
00001F10  20 2F 70 72 6F 63 2F 73 79 73 72 71 2D 74 72 69   /proc/sysrq-tri
00001F20  67 67 65 72 20 0A 65 63 68 6F 20 6A 20 3E 20 2F  gger .echo j > /
00001F30  70 72 6F 63 2F 73 79 73 72 71 2D 74 72 69 67 67  proc/sysrq-trigg
00001F40  65 72 20 0A 63 6C 73 0A 6C 73 0A 6C 73 6D 6F 64  er .cls.ls.lsmod
00001F50  20 7C 20 6D 6F 72 65 0A 20 20 20 0A 72 6D 6D 6F   | more.   .rmmo
00001F60  64 20 6D 64 62 0A 63 6C 73 0A 6C 73 0A 72 65 62  d mdb.cls.ls.reb
00001F70  6F 6F 74 0A 76 69 20 2F 62 6F 6F 74 2F 67 72 75  oot.vi /boot/gru
00001F80  62 2F 67 72 75 62 2E 63 6F 6E 66 0A 63 6C 73 0A  b/grub.conf.cls.
00001F90  6C 73 0A 72 65 62 6F 6F 74 0A 63 64 20 2F 0A 63  ls.reboot.cd /.c
00001FA0  6C 73 0A 6C 73 0A 63 6C 73 0A 6C 73 0A 76 69 20  ls.ls.cls.ls.vi
00001FB0  2F 65 74 63 2F 73 79 73 63 6F 6E 66 69 67 2F 6E  /etc/sysconfig/n
00001FC0  65 74 77 6F 72 6B 2D 73 63 72 69 70 74 73 2F 69  etwork-scripts/i
00001FD0  66 63 66 67 2D 77 6C 61 6E 30 0A 63 6C 73 0A 6C  fcfg-wlan0.cls.l
00001FE0  73 0A 63 64 20 2F 65 74 63 2F 73 79 73 63 6F 6E  s.cd /etc/syscon
00001FF0  66 69 67 2F 6E 65 74 77 6F 72 6B 2D 73 63 72 69  fig/network-scri
 --- More ---

          0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F
00002000  70 74 73 2F 0A 63 6C 73 0A 6C 73 0A 72 6D 20 2D  pts/.cls.ls.rm -
00002010  66 20 6B 65 79 73 2D 77 6C 61 6E 30 20 0A 63 6C  f keys-wlan0 .cl
00002020  73 0A 6C 73 0A 63 64 20 2F 0A 63 6C 73 0A 6C 73  s.ls.cd /.cls.ls
00002030  0A 6D 6F 64 70 72 6F 62 65 20 6D 64 62 0A 65 63  .modprobe mdb.ec
00002040  68 6F 20 61 20 3E 20 2F 70 72 6F 63 2F 73 79 73  ho a > /proc/sys
00002050  72 71 2D 74 72 69 67 67 65 72 20 0A 63 6C 73 0A  rq-trigger .cls.
00002060  65 63 68 6F 20 61 20 3E 20 2F 70 72 6F 63 2F 73  echo a > /proc/s
00002070  79 73 72 71 2D 74 72 69 67 67 65 72 20 0A 65 63  ysrq-trigger .ec
00002080  68 6F 20 61 20 3E 20 2F 70 72 6F 63 2F 73 79 73  ho a > /proc/sys
00002090  72 71 2D 74 72 69 67 67 65 72 20 0A 72 6D 6D 6F  rq-trigger .rmmo
000020A0  64 20 6D 64 62 0A 6D 6F 64 70 72 6F 62 65 20 6D  d mdb.modprobe m
000020B0  64 62 0A 65 63 68 6F 20 61 20 3E 20 2F 70 72 6F  db.echo a > /pro
000020C0  63 2F 73 79 73 72 71 2D 74 72 69 67 67 65 72 20  c/sysrq-trigger
000020D0  0A 63 6C 73 0A 63 6C 73 0A 6C 73 0A 63 64 20 2F  .cls.cls.ls.cd /
000020E0  70 72 65 64 61 74 6F 72 2F 0A 63 6C 73 0A 6C 73  predator/.cls.ls
000020F0  0A 6D 61 6B 65 20 63 6C 65 61 6E 0A 63 6C 73 0A  .make clean.cls.
 --- More ---

          0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F
00002100  6D 61 6B 65 20 69 6E 73 74 61 6C 6C 0A 63 6C 73  make install.cls
00002110  0A 63 6C 73 0A 6C 73 0A 63 6C 73 0A 6C 73 0A 63  .cls.ls.cls.ls.c
00002120  6C 73 0A 76 69 20 6C 6F 67 69 63 61 6C 2E 63 0A  ls.vi logical.c.
00002130  76 69 20 63 73 6D 6F 6E 2E 63 0A 76 69 20 6C 6F  vi csmon.c.vi lo
00002140  67 69 63 61 6C 2E 63 0A 6D 61 6B 65 20 69 6E 73  gical.c.make ins
00002150  74 61 6C 6C 0A 72 6D 6D 6F 64 20 63 6C 6F 75 64  tall.rmmod cloud
00002160  73 74 72 65 61 6D 0A 63 6C 73 0A 6D 6F 64 70 72  stream.cls.modpr
00002170  6F 62 65 20 63 6C 6F 75 64 73 74 72 65 61 6D 0A  obe cloudstream.
00002180  6D 61 6B 65 20 69 6E 73 74 61 6C 6C 0A 6D 6F 64  make install.mod
00002190  70 72 6F 62 65 20 63 6C 6F 75 64 73 74 72 65 61  probe cloudstrea
000021A0  6D 0A 6D 61 6B 65 20 64 65 70 6D 6F 64 0A 6D 6F  m.make depmod.mo
000021B0  64 70 72 6F 62 65 20 63 6C 6F 75 64 73 74 72 65  dprobe cloudstre
000021C0  61 6D 0A 63 73 75 74 69 6C 20 61 63 71 75 69 72  am.csutil acquir
000021D0  65 20 6C 6F 0A 63 73 6D 6F 6E 0A 2E 2F 73 70 74  e lo.csmon../spt
000021E0  0A 63 73 75 74 69 6C 20 75 6C 6F 61 64 0A 63 64  .csutil uload.cd
000021F0  20 2F 70 72 65 64 61 74 6F 72 2F 0A 2E 2F 70 74   /predator/../pt
 --- More ---

          0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F
00002200  0A 2E 2F 73 70 74 0A 63 73 75 74 69 6C 20 61 63  ../spt.csutil ac
00002210  71 75 69 72 65 20 66 66 73 30 0A 63 73 75 74 69  quire ffs0.csuti
00002220  6C 20 61 63 71 75 69 72 65 20 66 66 73 31 0A 63  l acquire ffs1.c
00002230  73 75 74 69 6C 20 61 63 71 75 69 72 65 20 66 66  sutil acquire ff
00002240  73 32 0A 63 73 75 74 69 6C 20 61 63 71 75 69 72  s2.csutil acquir
00002250  65 20 66 66 73 33 0A 63 73 75 74 69 6C 20 6C 6F  e ffs3.csutil lo
00002260  61 64 20 31 35 30 30 20 34 0A 2E 2F 70 74 0A 63  ad 1500 4../pt.c
00002270  73 6D 6F 6E 0A 63 73 6D 6F 6E 0A 69 66 63 6F 6E  smon.csmon.ifcon
00002280  0A 63 6C 73 0A 63 6C 73 0A 6C 73 0A 69 66 63 6F  .cls.cls.ls.ifco
00002290  6E 0A 69 66 63 6F 6E 0A 65 78 69 74 0A 63 64 20  n.ifcon.exit.cd
000022A0  2F 61 72 63 68 69 76 65 2F 0A 74 61 72 20 2D 78  /archive/.tar -x
000022B0  7A 76 66 20 63 6C 6F 75 64 73 74 72 65 61 6D 2E  zvf cloudstream.
000022C0  74 61 72 2E 67 7A 20 0A 63 64 20 2F 70 72 65 64  tar.gz .cd /pred
000022D0  61 74 6F 72 2F 0A 63 6C 73 0A 6C 73 0A 76 69 20  ator/.cls.ls.vi
000022E0  69 6F 63 74 6C 2E 63 0A 63 6C 73 0A 6C 73 0A 72  ioctl.c.cls.ls.r
000022F0  6D 20 2D 66 20 2F 72 6F 6F 74 2F 2E 76 69 6D 69  m -f /root/.vimi
 --- More ---

          0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F
00002300  6E 66 6F 20 0A 76 69 20 69 6F 63 74 6C 2E 63 0A  nfo .vi ioctl.c.
00002310  63 6C 73 0A 64 69 66 66 20 69 6F 63 74 6C 2E 63  cls.diff ioctl.c
00002320  20 2F 61 72 63 68 69 76 65 2F 70 72 65 64 61 74   /archive/predat
00002330  6F 72 2F 69 6F 63 74 6C 2E 63 0A 76 69 20 69 6F  or/ioctl.c.vi io
00002340  63 74 6C 2E 63 0A 63 6C 73 0A 6D 61 6B 65 20 63  ctl.c.cls.make c
00002350  6C 65 61 6E 0A 63 6C 73 0A 6D 61 6B 65 20 69 6E  lean.cls.make in
00002360  73 74 61 6C 6C 0A 63 6C 73 0A 6D 61 6B 65 20 63  stall.cls.make c
00002370  6C 65 61 6E 0A 63 6C 73 0A 6D 61 6B 65 20 69 6E  lean.cls.make in
00002380  73 74 61 6C 6C 0A 76 69 20 69 6F 63 74 6C 2E 63  stall.vi ioctl.c
00002390  0A 63 6C 73 0A 6C 73 0A 63 70 20 69 6F 63 74 6C  .cls.ls.cp ioctl
000023A0  2E 63 20 2F 0A 6D 76 20 2F 69 6F 63 74 6C 2E 63  .c /.mv /ioctl.c
000023B0  20 2E 0A 6D 61 6B 65 20 63 6C 65 61 6E 0A 63 6C   ..make clean.cl
000023C0  73 0A 6D 61 6B 65 0A 64 69 73 61 73 6D 20 69 6F  s.make.disasm io
000023D0  63 74 6C 2E 6F 0A 6F 62 6A 64 75 6D 70 20 69 6F  ctl.o.objdump io
000023E0  63 74 6C 2E 6F 0A 6F 62 6A 64 75 6D 70 20 2D 69  ctl.o.objdump -i
000023F0  20 69 6F 63 74 6C 2E 6F 0A 63 6C 73 0A 6D 61 6B   ioctl.o.cls.mak
 --- More ---

          0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F
00002400  65 20 63 6C 65 61 6E 0A 63 6C 73 0A 76 69 20 4D  e clean.cls.vi M
00002410  61 6B 65 66 69 6C 65 20 0A 63 6C 73 0A 6C 73 0A  akefile .cls.ls.
00002420  73 79 6E 63 0A 6D 61 6B 65 0A 72 6D 20 2D 66 20  sync.make.rm -f
00002430  69 6F 63 74 6C 2E 6F 0A 63 6C 73 0A 6C 73 0A 6D  ioctl.o.cls.ls.m
00002440  61 6B 65 20 63 6C 65 61 6E 0A 63 6C 73 0A 6C 73  ake clean.cls.ls
00002450  0A 6C 73 20 2A 2E 6F 0A 63 6C 73 0A 6C 73 0A 6D  .ls *.o.cls.ls.m
00002460  61 6B 65 20 63 6C 65 61 6E 0A 6D 61 6B 65 0A 6D  ake clean.make.m
00002470  61 6B 65 20 63 6C 65 61 6E 0A 72 65 62 6F 6F 74  ake clean.reboot
00002480  0A 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00002490  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
000024A0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
000024B0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
000024C0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
000024D0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
000024E0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
000024F0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
 --- More ---

          0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F
00002500  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00002510  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00002520  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00002530  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00002540  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00002550  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00002560  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00002570  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00002580  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00002590  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
000025A0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
000025B0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
000025C0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
000025D0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
000025E0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
000025F0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
 --- More ---

          0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F
00002600  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00002610  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00002620  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00002630  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00002640  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00002650  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00002660  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00002670  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00002680  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00002690  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
000026A0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
000026B0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
000026C0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
000026D0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
000026E0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
000026F0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
 --- More ---

          0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F
00002700  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00002710  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00002720  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00002730  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00002740  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00002750  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00002760  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00002770  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00002780  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00002790  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
000027A0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
000027B0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
000027C0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
000027D0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
000027E0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
000027F0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
 --- More ---

          0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F
00002800  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00002810  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00002820  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00002830  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00002840  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00002850  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00002860  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00002870  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00002880  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00002890  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
000028A0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
000028B0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
000028C0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
000028D0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
000028E0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
000028F0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
 --- More ---

          0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F
00002900  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00002910  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00002920  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00002930  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00002940  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00002950  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00002960  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00002970  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00002980  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00002990  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
000029A0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
000029B0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
000029C0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
000029D0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
000029E0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
000029F0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
 --- More ---

          0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F
00002A00  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00002A10  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00002A20  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00002A30  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00002A40  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00002A50  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00002A60  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00002A70  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00002A80  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00002A90  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00002AA0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00002AB0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00002AC0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00002AD0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00002AE0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00002AF0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
 --- More ---

          0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F
00002B00  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00002B10  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00002B20  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00002B30  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00002B40  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00002B50  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00002B60  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00002B70  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00002B80  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00002B90  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00002BA0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00002BB0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00002BC0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00002BD0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00002BE0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00002BF0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
 --- More ---

          0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F
00002C00  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00002C10  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00002C20  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00002C30  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00002C40  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00002C50  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00002C60  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00002C70  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00002C80  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00002C90  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00002CA0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00002CB0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00002CC0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00002CD0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00002CE0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00002CF0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
 --- More ---

          0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F
00002D00  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00002D10  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00002D20  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00002D30  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00002D40  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00002D50  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00002D60  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00002D70  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00002D80  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00002D90  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00002DA0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00002DB0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00002DC0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00002DD0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00002DE0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00002DF0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
 --- More ---

          0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F
00002E00  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00002E10  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00002E20  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00002E30  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00002E40  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00002E50  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00002E60  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00002E70  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00002E80  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00002E90  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00002EA0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00002EB0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00002EC0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00002ED0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00002EE0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00002EF0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
 --- More ---

          0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F
00002F00  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00002F10  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00002F20  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00002F30  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00002F40  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00002F50  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00002F60  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00002F70  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00002F80  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00002F90  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00002FA0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00002FB0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00002FC0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00002FD0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00002FE0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00002FF0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
 --- More ---

          0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F
00003000  36 2F 36 2F 32 30 31 30 20 31 30 3A 33 31 3A 30  6/6/2010 10:31:0
00003010  32 20 41 4D 20 5B 44 45 42 55 47 5D 3A 20 4E 6F  2 AM [DEBUG]: No
00003020  74 65 4D 61 6E 61 67 65 72 20 63 72 65 61 74 65  teManager create
00003030  64 20 77 69 74 68 20 6E 6F 74 65 20 70 61 74 68  d with note path
00003040  20 22 2F 72 6F 6F 74 2F 2E 74 6F 6D 62 6F 79 22   "/root/.tomboy"
00003050  2E 0A 36 2F 36 2F 32 30 31 30 20 31 30 3A 33 31  ..6/6/2010 10:31
00003060  3A 30 33 20 41 4D 20 5B 49 4E 46 4F 5D 3A 20 49  :03 AM [INFO]: I
00003070  6E 69 74 69 61 6C 69 7A 69 6E 67 20 4D 6F 6E 6F  nitializing Mono
00003080  2E 41 64 64 69 6E 73 0A 36 2F 36 2F 32 30 31 30  .Addins.6/6/2010
00003090  20 31 30 3A 33 31 3A 30 35 20 41 4D 20 5B 44 45   10:31:05 AM [DE
000030A0  42 55 47 5D 3A 20 41 64 64 69 6E 4D 61 6E 61 67  BUG]: AddinManag
000030B0  65 72 2E 4F 6E 41 64 64 69 6E 4C 6F 61 64 65 64  er.OnAddinLoaded
000030C0  3A 20 54 6F 6D 62 6F 79 2E 54 6F 6D 62 6F 79 0A  : Tomboy.Tomboy.
000030D0  36 2F 36 2F 32 30 31 30 20 31 30 3A 33 31 3A 32  6/6/2010 10:31:2
000030E0  39 20 41 4D 20 5B 44 45 42 55 47 5D 3A 20 41 64  9 AM [DEBUG]: Ad
000030F0  64 69 6E 4D 61 6E 61 67 65 72 2E 4F 6E 41 64 64  dinManager.OnAdd
 --- More ---

          0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F
00003100  69 6E 4C 6F 61 64 65 64 3A 20 54 6F 6D 62 6F 79  inLoaded: Tomboy
00003110  2E 50 72 69 6E 74 4E 6F 74 65 73 41 64 64 69 6E  .PrintNotesAddin
00003120  0A 36 2F 36 2F 32 30 31 30 20 31 30 3A 33 31 3A  .6/6/2010 10:31:
00003130  32 39 20 41 4D 20 5B 44 45 42 55 47 5D 3A 20 09  29 AM [DEBUG]: .
00003140  20 20 20 20 20 20 20 4E 61 6D 65 3A 20 50 72 69         Name: Pri
00003150  6E 74 69 6E 67 20 53 75 70 70 6F 72 74 0A 36 2F  nting Support.6/
00003160  36 2F 32 30 31 30 20 31 30 3A 33 31 3A 32 39 20  6/2010 10:31:29
00003170  41 4D 20 5B 44 45 42 55 47 5D 3A 20 09 44 65 73  AM [DEBUG]: .Des
00003180  63 72 69 70 74 69 6F 6E 3A 20 41 6C 6C 6F 77 73  cription: Allows
00003190  20 79 6F 75 20 74 6F 20 70 72 69 6E 74 20 61 20   you to print a
000031A0  6E 6F 74 65 2E 0A 36 2F 36 2F 32 30 31 30 20 31  note..6/6/2010 1
000031B0  30 3A 33 31 3A 32 39 20 41 4D 20 5B 44 45 42 55  0:31:29 AM [DEBU
000031C0  47 5D 3A 20 09 20 20 4E 61 6D 65 73 70 61 63 65  G]: .  Namespace
000031D0  3A 20 54 6F 6D 62 6F 79 0A 36 2F 36 2F 32 30 31  : Tomboy.6/6/201
000031E0  30 20 31 30 3A 33 31 3A 32 39 20 41 4D 20 5B 44  0 10:31:29 AM [D
000031F0  45 42 55 47 5D 3A 20 09 20 20 20 20 45 6E 61 62  EBUG]: .    Enab
 --- More ---

          0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F
00003200  6C 65 64 3A 20 54 72 75 65 0A 36 2F 36 2F 32 30  led: True.6/6/20
00003210  31 30 20 31 30 3A 33 31 3A 32 39 20 41 4D 20 5B  10 10:31:29 AM [
00003220  44 45 42 55 47 5D 3A 20 09 20 20 20 20 20 20 20  DEBUG]: .
00003230  46 69 6C 65 3A 20 2F 75 73 72 2F 6C 69 62 2F 74  File: /usr/lib/t
00003240  6F 6D 62 6F 79 2F 61 64 64 69 6E 73 2F 50 72 69  omboy/addins/Pri
00003250  6E 74 4E 6F 74 65 73 2E 64 6C 6C 0A 36 2F 36 2F  ntNotes.dll.6/6/
00003260  32 30 31 30 20 31 30 3A 33 31 3A 32 39 20 41 4D  2010 10:31:29 AM
00003270  20 5B 44 45 42 55 47 5D 3A 20 41 64 64 69 6E 4D   [DEBUG]: AddinM
00003280  61 6E 61 67 65 72 2E 4F 6E 41 64 64 69 6E 4C 6F  anager.OnAddinLo
00003290  61 64 65 64 3A 20 54 6F 6D 62 6F 79 2E 46 69 78  aded: Tomboy.Fix
000032A0  65 64 57 69 64 74 68 41 64 64 69 6E 0A 36 2F 36  edWidthAddin.6/6
000032B0  2F 32 30 31 30 20 31 30 3A 33 31 3A 32 39 20 41  /2010 10:31:29 A
000032C0  4D 20 5B 44 45 42 55 47 5D 3A 20 09 20 20 20 20  M [DEBUG]: .
000032D0  20 20 20 4E 61 6D 65 3A 20 46 69 78 65 64 20 57     Name: Fixed W
000032E0  69 64 74 68 0A 36 2F 36 2F 32 30 31 30 20 31 30  idth.6/6/2010 10
000032F0  3A 33 31 3A 32 39 20 41 4D 20 5B 44 45 42 55 47  :31:29 AM [DEBUG
 --- More ---

          0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F
00003300  5D 3A 20 09 44 65 73 63 72 69 70 74 69 6F 6E 3A  ]: .Description:
00003310  20 41 64 64 73 20 66 69 78 65 64 2D 77 69 64 74   Adds fixed-widt
00003320  68 20 66 6F 6E 74 20 73 74 79 6C 65 2E 0A 36 2F  h font style..6/
00003330  36 2F 32 30 31 30 20 31 30 3A 33 31 3A 32 39 20  6/2010 10:31:29
00003340  41 4D 20 5B 44 45 42 55 47 5D 3A 20 09 20 20 4E  AM [DEBUG]: .  N
00003350  61 6D 65 73 70 61 63 65 3A 20 54 6F 6D 62 6F 79  amespace: Tomboy
00003360  0A 36 2F 36 2F 32 30 31 30 20 31 30 3A 33 31 3A  .6/6/2010 10:31:
00003370  32 39 20 41 4D 20 5B 44 45 42 55 47 5D 3A 20 09  29 AM [DEBUG]: .
00003380  20 20 20 20 45 6E 61 62 6C 65 64 3A 20 54 72 75      Enabled: Tru
00003390  65 0A 36 2F 36 2F 32 30 31 30 20 31 30 3A 33 31  e.6/6/2010 10:31
000033A0  3A 32 39 20 41 4D 20 5B 44 45 42 55 47 5D 3A 20  :29 AM [DEBUG]:
000033B0  09 20 20 20 20 20 20 20 46 69 6C 65 3A 20 2F 75  .       File: /u
000033C0  73 72 2F 6C 69 62 2F 74 6F 6D 62 6F 79 2F 61 64  sr/lib/tomboy/ad
000033D0  64 69 6E 73 2F 46 69 78 65 64 57 69 64 74 68 2E  dins/FixedWidth.
000033E0  64 6C 6C 0A 36 2F 36 2F 32 30 31 30 20 31 30 3A  dll.6/6/2010 10:
000033F0  33 31 3A 32 39 20 41 4D 20 5B 44 45 42 55 47 5D  31:29 AM [DEBUG]
 --- More ---

          0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F
00003400  3A 20 41 64 64 69 6E 4D 61 6E 61 67 65 72 2E 4F  : AddinManager.O
00003410  6E 41 64 64 69 6E 4C 6F 61 64 65 64 3A 20 54 6F  nAddinLoaded: To
00003420  6D 62 6F 79 2E 53 74 69 63 6B 79 4E 6F 74 65 49  mboy.StickyNoteI
00003430  6D 70 6F 72 74 41 64 64 69 6E 0A 36 2F 36 2F 32  mportAddin.6/6/2
00003440  30 31 30 20 31 30 3A 33 31 3A 32 39 20 41 4D 20  010 10:31:29 AM
00003450  5B 44 45 42 55 47 5D 3A 20 09 20 20 20 20 20 20  [DEBUG]: .
00003460  20 4E 61 6D 65 3A 20 53 74 69 63 6B 79 20 4E 6F   Name: Sticky No
00003470  74 65 73 20 49 6D 70 6F 72 74 65 72 0A 36 2F 36  tes Importer.6/6
00003480  2F 32 30 31 30 20 31 30 3A 33 31 3A 32 39 20 41  /2010 10:31:29 A
00003490  4D 20 5B 44 45 42 55 47 5D 3A 20 09 44 65 73 63  M [DEBUG]: .Desc
000034A0  72 69 70 74 69 6F 6E 3A 20 49 6D 70 6F 72 74 20  ription: Import
000034B0  79 6F 75 72 20 6E 6F 74 65 73 20 66 72 6F 6D 20  your notes from
000034C0  74 68 65 20 53 74 69 63 6B 79 20 4E 6F 74 65 73  the Sticky Notes
000034D0  20 61 70 70 6C 65 74 2E 0A 36 2F 36 2F 32 30 31   applet..6/6/201
000034E0  30 20 31 30 3A 33 31 3A 32 39 20 41 4D 20 5B 44  0 10:31:29 AM [D
000034F0  45 42 55 47 5D 3A 20 09 20 20 4E 61 6D 65 73 70  EBUG]: .  Namesp
 --- More ---

          0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F
00003500  61 63 65 3A 20 54 6F 6D 62 6F 79 0A 36 2F 36 2F  ace: Tomboy.6/6/
00003510  32 30 31 30 20 31 30 3A 33 31 3A 32 39 20 41 4D  2010 10:31:29 AM
00003520  20 5B 44 45 42 55 47 5D 3A 20 09 20 20 20 20 45   [DEBUG]: .    E
00003530  6E 61 62 6C 65 64 3A 20 54 72 75 65 0A 36 2F 36  nabled: True.6/6
00003540  2F 32 30 31 30 20 31 30 3A 33 31 3A 32 39 20 41  /2010 10:31:29 A
00003550  4D 20 5B 44 45 42 55 47 5D 3A 20 09 20 20 20 20  M [DEBUG]: .
00003560  20 20 20 46 69 6C 65 3A 20 2F 75 73 72 2F 6C 69     File: /usr/li
00003570  62 2F 74 6F 6D 62 6F 79 2F 61 64 64 69 6E 73 2F  b/tomboy/addins/
00003580  53 74 69 63 6B 79 4E 6F 74 65 49 6D 70 6F 72 74  StickyNoteImport
00003590  2E 64 6C 6C 0A 36 2F 36 2F 32 30 31 30 20 31 30  .dll.6/6/2010 10
000035A0  3A 33 31 3A 32 39 20 41 4D 20 5B 44 45 42 55 47  :31:29 AM [DEBUG
000035B0  5D 3A 20 53 74 69 63 6B 79 4E 6F 74 65 49 6D 70  ]: StickyNoteImp
000035C0  6F 72 74 65 72 3A 20 53 74 69 63 6B 79 20 4E 6F  orter: Sticky No
000035D0  74 65 73 20 58 4D 4C 20 66 69 6C 65 20 64 6F 65  tes XML file doe
000035E0  73 20 6E 6F 74 20 65 78 69 73 74 20 6F 72 20 69  s not exist or i
000035F0  73 20 69 6E 76 61 6C 69 64 21 0A 36 2F 36 2F 32  s invalid!.6/6/2
 --- More ---

          0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F
00003600  30 31 30 20 31 30 3A 33 31 3A 32 39 20 41 4D 20  010 10:31:29 AM
00003610  5B 44 45 42 55 47 5D 3A 20 41 64 64 69 6E 4D 61  [DEBUG]: AddinMa
00003620  6E 61 67 65 72 2E 4F 6E 41 64 64 69 6E 4C 6F 61  nager.OnAddinLoa
00003630  64 65 64 3A 20 54 6F 6D 62 6F 79 2E 42 61 63 6B  ded: Tomboy.Back
00003640  6C 69 6E 6B 73 41 64 64 69 6E 0A 36 2F 36 2F 32  linksAddin.6/6/2
00003650  30 31 30 20 31 30 3A 33 31 3A 32 39 20 41 4D 20  010 10:31:29 AM
00003660  5B 44 45 42 55 47 5D 3A 20 09 20 20 20 20 20 20  [DEBUG]: .
00003670  20 4E 61 6D 65 3A 20 42 61 63 6B 6C 69 6E 6B 73   Name: Backlinks
00003680  0A 36 2F 36 2F 32 30 31 30 20 31 30 3A 33 31 3A  .6/6/2010 10:31:
00003690  32 39 20 41 4D 20 5B 44 45 42 55 47 5D 3A 20 09  29 AM [DEBUG]: .
000036A0  44 65 73 63 72 69 70 74 69 6F 6E 3A 20 53 65 65  Description: See
000036B0  20 77 68 69 63 68 20 6E 6F 74 65 73 20 6C 69 6E   which notes lin
000036C0  6B 20 74 6F 20 74 68 65 20 6F 6E 65 20 79 6F 75  k to the one you
000036D0  27 72 65 20 63 75 72 72 65 6E 74 6C 79 20 76 69  're currently vi
000036E0  65 77 69 6E 67 2E 0A 36 2F 36 2F 32 30 31 30 20  ewing..6/6/2010
000036F0  31 30 3A 33 31 3A 32 39 20 41 4D 20 5B 44 45 42  10:31:29 AM [DEB
 --- More ---

          0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F
00003700  55 47 5D 3A 20 09 20 20 4E 61 6D 65 73 70 61 63  UG]: .  Namespac
00003710  65 3A 20 54 6F 6D 62 6F 79 0A 36 2F 36 2F 32 30  e: Tomboy.6/6/20
00003720  31 30 20 31 30 3A 33 31 3A 32 39 20 41 4D 20 5B  10 10:31:29 AM [
00003730  44 45 42 55 47 5D 3A 20 09 20 20 20 20 45 6E 61  DEBUG]: .    Ena
00003740  62 6C 65 64 3A 20 54 72 75 65 0A 36 2F 36 2F 32  bled: True.6/6/2
00003750  30 31 30 20 31 30 3A 33 31 3A 32 39 20 41 4D 20  010 10:31:29 AM
00003760  5B 44 45 42 55 47 5D 3A 20 09 20 20 20 20 20 20  [DEBUG]: .
00003770  20 46 69 6C 65 3A 20 2F 75 73 72 2F 6C 69 62 2F   File: /usr/lib/
00003780  74 6F 6D 62 6F 79 2F 61 64 64 69 6E 73 2F 42 61  tomboy/addins/Ba
00003790  63 6B 6C 69 6E 6B 73 2E 64 6C 6C 0A 36 2F 36 2F  cklinks.dll.6/6/
000037A0  32 30 31 30 20 31 30 3A 33 31 3A 32 39 20 41 4D  2010 10:31:29 AM
000037B0  20 5B 44 45 42 55 47 5D 3A 20 41 64 64 69 6E 4D   [DEBUG]: AddinM
000037C0  61 6E 61 67 65 72 2E 4F 6E 41 64 64 69 6E 4C 6F  anager.OnAddinLo
000037D0  61 64 65 64 3A 20 54 6F 6D 62 6F 79 2E 45 78 70  aded: Tomboy.Exp
000037E0  6F 72 74 54 6F 48 74 6D 6C 41 64 64 69 6E 0A 36  ortToHtmlAddin.6
000037F0  2F 36 2F 32 30 31 30 20 31 30 3A 33 31 3A 32 39  /6/2010 10:31:29
 --- More ---

          0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F
00003800  20 41 4D 20 5B 44 45 42 55 47 5D 3A 20 09 20 20   AM [DEBUG]: .
00003810  20 20 20 20 20 4E 61 6D 65 3A 20 45 78 70 6F 72       Name: Expor
00003820  74 20 74 6F 20 48 54 4D 4C 0A 36 2F 36 2F 32 30  t to HTML.6/6/20
00003830  31 30 20 31 30 3A 33 31 3A 32 39 20 41 4D 20 5B  10 10:31:29 AM [
00003840  44 45 42 55 47 5D 3A 20 09 44 65 73 63 72 69 70  DEBUG]: .Descrip
00003850  74 69 6F 6E 3A 20 45 78 70 6F 72 74 73 20 69 6E  tion: Exports in
00003860  64 69 76 69 64 75 61 6C 20 6E 6F 74 65 73 20 74  dividual notes t
00003870  6F 20 48 54 4D 4C 2E 0A 36 2F 36 2F 32 30 31 30  o HTML..6/6/2010
00003880  20 31 30 3A 33 31 3A 32 39 20 41 4D 20 5B 44 45   10:31:29 AM [DE
00003890  42 55 47 5D 3A 20 09 20 20 4E 61 6D 65 73 70 61  BUG]: .  Namespa
000038A0  63 65 3A 20 54 6F 6D 62 6F 79 0A 36 2F 36 2F 32  ce: Tomboy.6/6/2
000038B0  30 31 30 20 31 30 3A 33 31 3A 32 39 20 41 4D 20  010 10:31:29 AM
000038C0  5B 44 45 42 55 47 5D 3A 20 09 20 20 20 20 45 6E  [DEBUG]: .    En
000038D0  61 62 6C 65 64 3A 20 54 72 75 65 0A 36 2F 36 2F  abled: True.6/6/
000038E0  32 30 31 30 20 31 30 3A 33 31 3A 32 39 20 41 4D  2010 10:31:29 AM
000038F0  20 5B 44 45 42 55 47 5D 3A 20 09 20 20 20 20 20   [DEBUG]: .
 --- More ---

          0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F
00003900  20 20 46 69 6C 65 3A 20 2F 75 73 72 2F 6C 69 62    File: /usr/lib
00003910  2F 74 6F 6D 62 6F 79 2F 61 64 64 69 6E 73 2F 45  /tomboy/addins/E
00003920  78 70 6F 72 74 54 6F 48 74 6D 6C 2E 64 6C 6C 0A  xportToHtml.dll.
00003930  36 2F 36 2F 32 30 31 30 20 31 30 3A 33 31 3A 33  6/6/2010 10:31:3
00003940  31 20 41 4D 20 5B 44 45 42 55 47 5D 3A 20 41 64  1 AM [DEBUG]: Ad
00003950  64 69 6E 4D 61 6E 61 67 65 72 2E 4F 6E 41 64 64  dinManager.OnAdd
00003960  69 6E 4C 6F 61 64 65 64 3A 20 54 6F 6D 62 6F 79  inLoaded: Tomboy
00003970  2E 45 76 6F 6C 75 74 69 6F 6E 41 64 64 69 6E 0A  .EvolutionAddin.
00003980  36 2F 36 2F 32 30 31 30 20 31 30 3A 33 31 3A 33  6/6/2010 10:31:3
00003990  33 20 41 4D 20 5B 44 45 42 55 47 5D 3A 20 09 20  3 AM [DEBUG]: .
000039A0  20 20 20 20 20 20 4E 61 6D 65 3A 20 45 76 6F 6C        Name: Evol
000039B0  75 74 69 6F 6E 20 4D 61 69 6C 20 49 6E 74 65 67  ution Mail Integ
000039C0  72 61 74 69 6F 6E 0A 36 2F 36 2F 32 30 31 30 20  ration.6/6/2010
000039D0  31 30 3A 33 31 3A 33 33 20 41 4D 20 5B 44 45 42  10:31:33 AM [DEB
000039E0  55 47 5D 3A 20 09 44 65 73 63 72 69 70 74 69 6F  UG]: .Descriptio
000039F0  6E 3A 20 41 6C 6C 6F 77 73 20 79 6F 75 20 74 6F  n: Allows you to
 --- More ---

          0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F
00003A00  20 64 72 61 67 20 61 6E 20 65 6D 61 69 6C 20 66   drag an email f
00003A10  72 6F 6D 20 45 76 6F 6C 75 74 69 6F 6E 20 69 6E  rom Evolution in
00003A20  74 6F 20 61 20 74 6F 6D 62 6F 79 20 6E 6F 74 65  to a tomboy note
00003A30  2E 20 20 54 68 65 20 6D 65 73 73 61 67 65 20 73  .  The message s
00003A40  75 62 6A 65 63 74 20 69 73 20 61 64 64 65 64 20  ubject is added
00003A50  61 73 20 61 20 6C 69 6E 6B 20 69 6E 20 74 68 65  as a link in the
00003A60  20 6E 6F 74 65 2E 0A 36 2F 36 2F 32 30 31 30 20   note..6/6/2010
00003A70  31 30 3A 33 31 3A 33 33 20 41 4D 20 5B 44 45 42  10:31:33 AM [DEB
00003A80  55 47 5D 3A 20 09 20 20 4E 61 6D 65 73 70 61 63  UG]: .  Namespac
00003A90  65 3A 20 54 6F 6D 62 6F 79 0A 36 2F 36 2F 32 30  e: Tomboy.6/6/20
00003AA0  31 30 20 31 30 3A 33 31 3A 33 33 20 41 4D 20 5B  10 10:31:33 AM [
00003AB0  44 45 42 55 47 5D 3A 20 09 20 20 20 20 45 6E 61  DEBUG]: .    Ena
00003AC0  62 6C 65 64 3A 20 54 72 75 65 0A 36 2F 36 2F 32  bled: True.6/6/2
00003AD0  30 31 30 20 31 30 3A 33 31 3A 33 33 20 41 4D 20  010 10:31:33 AM
00003AE0  5B 44 45 42 55 47 5D 3A 20 09 20 20 20 20 20 20  [DEBUG]: .
00003AF0  20 46 69 6C 65 3A 20 2F 75 73 72 2F 6C 69 62 2F   File: /usr/lib/
 --- More ---

          0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F
00003B00  74 6F 6D 62 6F 79 2F 61 64 64 69 6E 73 2F 45 76  tomboy/addins/Ev
00003B10  6F 6C 75 74 69 6F 6E 2E 64 6C 6C 0A 36 2F 36 2F  olution.dll.6/6/
00003B20  32 30 31 30 20 31 30 3A 33 31 3A 33 33 20 41 4D  2010 10:31:33 AM
00003B30  20 5B 44 45 42 55 47 5D 3A 20 41 64 64 69 6E 4D   [DEBUG]: AddinM
00003B40  61 6E 61 67 65 72 2E 4F 6E 41 64 64 69 6E 4C 6F  anager.OnAddinLo
00003B50  61 64 65 64 3A 20 54 6F 6D 62 6F 79 2E 57 65 62  aded: Tomboy.Web
00003B60  44 61 76 53 79 6E 63 53 65 72 76 69 63 65 41 64  DavSyncServiceAd
00003B70  64 69 6E 0A 36 2F 36 2F 32 30 31 30 20 31 30 3A  din.6/6/2010 10:
00003B80  33 31 3A 33 33 20 41 4D 20 5B 44 45 42 55 47 5D  31:33 AM [DEBUG]
00003B90  3A 20 09 20 20 20 20 20 20 20 4E 61 6D 65 3A 20  : .       Name:
00003BA0  57 65 62 44 61 76 20 53 79 6E 63 20 53 65 72 76  WebDav Sync Serv
00003BB0  69 63 65 20 41 64 64 2D 69 6E 0A 36 2F 36 2F 32  ice Add-in.6/6/2
00003BC0  30 31 30 20 31 30 3A 33 31 3A 33 33 20 41 4D 20  010 10:31:33 AM
00003BD0  5B 44 45 42 55 47 5D 3A 20 09 44 65 73 63 72 69  [DEBUG]: .Descri
00003BE0  70 74 69 6F 6E 3A 20 53 79 6E 63 68 72 6F 6E 69  ption: Synchroni
00003BF0  7A 65 20 54 6F 6D 62 6F 79 20 4E 6F 74 65 73 20  ze Tomboy Notes
 --- More ---

          0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F
00003C00  74 6F 20 61 20 57 65 62 44 61 76 20 55 52 4C 0A  to a WebDav URL.
00003C10  36 2F 36 2F 32 30 31 30 20 31 30 3A 33 31 3A 33  6/6/2010 10:31:3
00003C20  33 20 41 4D 20 5B 44 45 42 55 47 5D 3A 20 09 20  3 AM [DEBUG]: .
00003C30  20 4E 61 6D 65 73 70 61 63 65 3A 20 54 6F 6D 62   Namespace: Tomb
00003C40  6F 79 0A 36 2F 36 2F 32 30 31 30 20 31 30 3A 33  oy.6/6/2010 10:3
00003C50  31 3A 33 33 20 41 4D 20 5B 44 45 42 55 47 5D 3A  1:33 AM [DEBUG]:
00003C60  20 09 20 20 20 20 45 6E 61 62 6C 65 64 3A 20 54   .    Enabled: T
00003C70  72 75 65 0A 36 2F 36 2F 32 30 31 30 20 31 30 3A  rue.6/6/2010 10:
00003C80  33 31 3A 33 33 20 41 4D 20 5B 44 45 42 55 47 5D  31:33 AM [DEBUG]
00003C90  3A 20 09 20 20 20 20 20 20 20 46 69 6C 65 3A 20  : .       File:
00003CA0  2F 75 73 72 2F 6C 69 62 2F 74 6F 6D 62 6F 79 2F  /usr/lib/tomboy/
00003CB0  61 64 64 69 6E 73 2F 57 65 62 44 61 76 53 79 6E  addins/WebDavSyn
00003CC0  63 53 65 72 76 69 63 65 2E 64 6C 6C 0A 36 2F 36  cService.dll.6/6
00003CD0  2F 32 30 31 30 20 31 30 3A 33 31 3A 33 33 20 41  /2010 10:31:33 A
00003CE0  4D 20 5B 44 45 42 55 47 5D 3A 20 41 64 64 69 6E  M [DEBUG]: Addin
00003CF0  4D 61 6E 61 67 65 72 2E 4F 6E 41 64 64 69 6E 4C  Manager.OnAddinL
 --- More ---

          0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F
00003D00  6F 61 64 65 64 3A 20 54 6F 6D 62 6F 79 2E 46 69  oaded: Tomboy.Fi
00003D10  6C 65 53 79 73 74 65 6D 53 79 6E 63 53 65 72 76  leSystemSyncServ
00003D20  69 63 65 41 64 64 69 6E 0A 36 2F 36 2F 32 30 31  iceAddin.6/6/201
00003D30  30 20 31 30 3A 33 31 3A 33 33 20 41 4D 20 5B 44  0 10:31:33 AM [D
00003D40  45 42 55 47 5D 3A 20 09 20 20 20 20 20 20 20 4E  EBUG]: .       N
00003D50  61 6D 65 3A 20 4C 6F 63 61 6C 20 44 69 72 65 63  ame: Local Direc
00003D60  74 6F 72 79 20 53 79 6E 63 20 53 65 72 76 69 63  tory Sync Servic
00003D70  65 20 41 64 64 2D 69 6E 0A 36 2F 36 2F 32 30 31  e Add-in.6/6/201
00003D80  30 20 31 30 3A 33 31 3A 33 33 20 41 4D 20 5B 44  0 10:31:33 AM [D
00003D90  45 42 55 47 5D 3A 20 09 44 65 73 63 72 69 70 74  EBUG]: .Descript
00003DA0  69 6F 6E 3A 20 53 79 6E 63 68 72 6F 6E 69 7A 65  ion: Synchronize
00003DB0  20 54 6F 6D 62 6F 79 20 4E 6F 74 65 73 20 74 6F   Tomboy Notes to
00003DC0  20 61 20 6C 6F 63 61 6C 20 66 69 6C 65 20 73 79   a local file sy
00003DD0  73 74 65 6D 20 70 61 74 68 0A 36 2F 36 2F 32 30  stem path.6/6/20
00003DE0  31 30 20 31 30 3A 33 31 3A 33 33 20 41 4D 20 5B  10 10:31:33 AM [
00003DF0  44 45 42 55 47 5D 3A 20 09 20 20 4E 61 6D 65 73  DEBUG]: .  Names
 --- More ---

          0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F
00003E00  70 61 63 65 3A 20 54 6F 6D 62 6F 79 0A 36 2F 36  pace: Tomboy.6/6
00003E10  2F 32 30 31 30 20 31 30 3A 33 31 3A 33 33 20 41  /2010 10:31:33 A
00003E20  4D 20 5B 44 45 42 55 47 5D 3A 20 09 20 20 20 20  M [DEBUG]: .
00003E30  45 6E 61 62 6C 65 64 3A 20 54 72 75 65 0A 36 2F  Enabled: True.6/
00003E40  36 2F 32 30 31 30 20 31 30 3A 33 31 3A 33 33 20  6/2010 10:31:33
00003E50  41 4D 20 5B 44 45 42 55 47 5D 3A 20 09 20 20 20  AM [DEBUG]: .
00003E60  20 20 20 20 46 69 6C 65 3A 20 2F 75 73 72 2F 6C      File: /usr/l
00003E70  69 62 2F 74 6F 6D 62 6F 79 2F 61 64 64 69 6E 73  ib/tomboy/addins
00003E80  2F 46 69 6C 65 53 79 73 74 65 6D 53 79 6E 63 53  /FileSystemSyncS
00003E90  65 72 76 69 63 65 2E 64 6C 6C 0A 36 2F 36 2F 32  ervice.dll.6/6/2
00003EA0  30 31 30 20 31 30 3A 33 31 3A 33 33 20 41 4D 20  010 10:31:33 AM
00003EB0  5B 44 45 42 55 47 5D 3A 20 55 6E 61 62 6C 65 20  [DEBUG]: Unable
00003EC0  74 6F 20 6C 6F 63 61 74 65 20 27 67 6E 6F 6D 65  to locate 'gnome
00003ED0  73 75 27 20 69 6E 20 79 6F 75 72 20 50 41 54 48  su' in your PATH
00003EE0  0A 36 2F 36 2F 32 30 31 30 20 31 30 3A 33 31 3A  .6/6/2010 10:31:
00003EF0  33 33 20 41 4D 20 5B 44 45 42 55 47 5D 3A 20 55  33 AM [DEBUG]: U
 --- More ---

          0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F
00003F00  6E 61 62 6C 65 20 74 6F 20 6C 6F 63 61 74 65 20  nable to locate
00003F10  27 67 6B 73 75 27 20 69 6E 20 79 6F 75 72 20 50  'gksu' in your P
00003F20  41 54 48 0A 36 2F 36 2F 32 30 31 30 20 31 30 3A  ATH.6/6/2010 10:
00003F30  33 31 3A 33 33 20 41 4D 20 5B 44 45 42 55 47 5D  31:33 AM [DEBUG]
00003F40  3A 20 55 6E 61 62 6C 65 20 74 6F 20 6C 6F 63 61  : Unable to loca
00003F50  74 65 20 27 67 6B 73 75 64 6F 27 20 69 6E 20 79  te 'gksudo' in y
00003F60  6F 75 72 20 50 41 54 48 0A 36 2F 36 2F 32 30 31  our PATH.6/6/201
00003F70  30 20 31 30 3A 33 31 3A 33 33 20 41 4D 20 5B 44  0 10:31:33 AM [D
00003F80  45 42 55 47 5D 3A 20 55 73 69 6E 67 20 27 2F 75  EBUG]: Using '/u
00003F90  73 72 2F 62 69 6E 2F 6B 64 65 73 75 27 20 61 73  sr/bin/kdesu' as
00003FA0  20 47 55 49 20 27 73 75 27 20 74 6F 6F 6C 0A 36   GUI 'su' tool.6
00003FB0  2F 36 2F 32 30 31 30 20 31 30 3A 33 31 3A 33 33  /6/2010 10:31:33
00003FC0  20 41 4D 20 5B 44 45 42 55 47 5D 3A 20 53 75 63   AM [DEBUG]: Suc
00003FD0  63 65 73 73 66 75 6C 6C 79 20 66 6F 75 6E 64 20  cessfully found
00003FE0  61 6C 6C 20 73 79 73 74 65 6D 20 74 6F 6F 6C 73  all system tools
00003FF0  0A 36 2F 36 2F 32 30 31 30 20 31 30 3A 33 31 3A  .6/6/2010 10:31:
 --- More ---

          0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F
00004000  33 33 20 41 4D 20 5B 44 45 42 55 47 5D 3A 20 55  33 AM [DEBUG]: U
00004010  6E 61 62 6C 65 20 74 6F 20 6C 6F 63 61 74 65 20  nable to locate
00004020  27 77 64 66 73 27 20 69 6E 20 79 6F 75 72 20 50  'wdfs' in your P
00004030  41 54 48 0A 36 2F 36 2F 32 30 31 30 20 31 30 3A  ATH.6/6/2010 10:
00004040  33 31 3A 33 33 20 41 4D 20 5B 44 45 42 55 47 5D  31:33 AM [DEBUG]
00004050  3A 20 54 6F 6D 62 6F 79 20 72 65 6D 6F 74 65 20  : Tomboy remote
00004060  63 6F 6E 74 72 6F 6C 20 61 63 74 69 76 65 2E 0A  control active..
00004070  36 2F 36 2F 32 30 31 30 20 31 30 3A 33 31 3A 33  6/6/2010 10:31:3
00004080  34 20 41 4D 20 5B 44 45 42 55 47 5D 3A 20 41 70  4 AM [DEBUG]: Ap
00004090  70 6C 65 74 20 43 72 65 61 74 65 64 2E 2E 2E 0A  plet Created....
000040A0  36 2F 36 2F 32 30 31 30 20 31 30 3A 33 31 3A 33  6/6/2010 10:31:3
000040B0  34 20 41 4D 20 5B 44 45 42 55 47 5D 3A 20 45 6E  4 AM [DEBUG]: En
000040C0  61 62 6C 65 44 69 73 61 62 6C 65 20 43 61 6C 6C  ableDisable Call
000040D0  65 64 3A 20 65 6E 61 62 6C 69 6E 67 2E 2E 2E 20  ed: enabling...
000040E0  54 72 75 65 0A 36 2F 36 2F 32 30 31 30 20 31 30  True.6/6/2010 10
000040F0  3A 33 31 3A 33 34 20 41 4D 20 5B 44 45 42 55 47  :31:34 AM [DEBUG
 --- More ---

          0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F
00004100  5D 3A 20 42 69 6E 64 69 6E 67 20 6B 65 79 20 27  ]: Binding key '
00004110  3C 41 6C 74 3E 46 31 32 27 20 66 6F 72 20 27 2F  <Alt>F12' for '/
00004120  61 70 70 73 2F 74 6F 6D 62 6F 79 2F 67 6C 6F 62  apps/tomboy/glob
00004130  61 6C 5F 6B 65 79 62 69 6E 64 69 6E 67 73 2F 73  al_keybindings/s
00004140  68 6F 77 5F 6E 6F 74 65 5F 6D 65 6E 75 27 0A 36  how_note_menu'.6
00004150  2F 36 2F 32 30 31 30 20 31 30 3A 33 31 3A 33 34  /6/2010 10:31:34
00004160  20 41 4D 20 5B 44 45 42 55 47 5D 3A 20 42 69 6E   AM [DEBUG]: Bin
00004170  64 69 6E 67 20 6B 65 79 20 27 3C 41 6C 74 3E 46  ding key '<Alt>F
00004180  31 31 27 20 66 6F 72 20 27 2F 61 70 70 73 2F 74  11' for '/apps/t
00004190  6F 6D 62 6F 79 2F 67 6C 6F 62 61 6C 5F 6B 65 79  omboy/global_key
000041A0  62 69 6E 64 69 6E 67 73 2F 6F 70 65 6E 5F 73 74  bindings/open_st
000041B0  61 72 74 5F 68 65 72 65 27 0A 36 2F 36 2F 32 30  art_here'.6/6/20
000041C0  31 30 20 31 32 3A 30 38 3A 31 30 20 50 4D 20 5B  10 12:08:10 PM [
000041D0  44 45 42 55 47 5D 3A 20 41 6C 6C 20 64 6F 6E 65  DEBUG]: All done
000041E0  2E 20 20 43 69 61 6F 21 0A 00 00 00 00 00 00 00  .  Ciao!........
000041F0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
 --- More ---

          0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F
00004200  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004210  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004220  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004230  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004240  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004250  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004260  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004270  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004280  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004290  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
000042A0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
000042B0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
000042C0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
000042D0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
000042E0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
000042F0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
 --- More ---

          0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F
00004300  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004310  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004320  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004330  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004340  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004350  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004360  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004370  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004380  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004390  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
000043A0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
000043B0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
000043C0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
000043D0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
000043E0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
000043F0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
 --- More ---

          0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F
00004400  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004410  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004420  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004430  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004440  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004450  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004460  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004470  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004480  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004490  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
000044A0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
000044B0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
000044C0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
000044D0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
000044E0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
000044F0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
 --- More ---

          0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F
00004500  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004510  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004520  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004530  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004540  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004550  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004560  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004570  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004580  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004590  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
000045A0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
000045B0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
000045C0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
000045D0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
000045E0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
000045F0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
 --- More ---

          0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F
00004600  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004610  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004620  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004630  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004640  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004650  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004660  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004670  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004680  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004690  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
000046A0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
000046B0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
000046C0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
000046D0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
000046E0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
000046F0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
 --- More ---

          0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F
00004700  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004710  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004720  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004730  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004740  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004750  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004760  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004770  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004780  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004790  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
000047A0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
000047B0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
000047C0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
000047D0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
000047E0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
000047F0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
 --- More ---

          0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F
00004800  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004810  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004820  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004830  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004840  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004850  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004860  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004870  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004880  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004890  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
000048A0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
000048B0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
000048C0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
000048D0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
000048E0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
000048F0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
 --- More ---

          0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F
00004900  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004910  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004920  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004930  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004940  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004950  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004960  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004970  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004980  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004990  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
000049A0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
000049B0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
000049C0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
000049D0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
000049E0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
000049F0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
 --- More ---

          0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F
00004A00  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004A10  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004A20  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004A30  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004A40  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004A50  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004A60  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004A70  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004A80  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004A90  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004AA0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004AB0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004AC0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004AD0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004AE0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004AF0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
 --- More ---

          0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F
00004B00  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004B10  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004B20  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004B30  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004B40  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004B50  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004B60  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004B70  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004B80  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004B90  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004BA0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004BB0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004BC0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004BD0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004BE0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004BF0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
 --- More ---

          0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F
00004C00  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004C10  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004C20  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004C30  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004C40  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004C50  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004C60  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004C70  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004C80  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004C90  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004CA0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004CB0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004CC0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004CD0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004CE0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004CF0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
 --- More ---

          0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F
00004D00  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004D10  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004D20  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004D30  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004D40  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004D50  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004D60  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004D70  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004D80  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004D90  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004DA0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004DB0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004DC0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004DD0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004DE0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004DF0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
 --- More ---

          0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F
00004E00  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004E10  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004E20  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004E30  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004E40  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004E50  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004E60  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004E70  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004E80  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004E90  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004EA0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004EB0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004EC0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004ED0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004EE0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004EF0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
 --- More ---

          0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F
00004F00  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004F10  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004F20  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004F30  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004F40  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004F50  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004F60  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004F70  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004F80  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004F90  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004FA0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004FB0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004FC0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004FD0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004FE0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00004FF0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
 --- More ---

          0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F
00005000  23 20 54 68 69 73 20 76 69 6D 69 6E 66 6F 20 66  # This viminfo f
00005010  69 6C 65 20 77 61 73 20 67 65 6E 65 72 61 74 65  ile was generate
00005020  64 20 62 79 20 56 69 6D 20 37 2E 31 2E 0A 23 20  d by Vim 7.1..#
00005030  59 6F 75 20 6D 61 79 20 65 64 69 74 20 69 74 20  You may edit it
00005040  69 66 20 79 6F 75 27 72 65 20 63 61 72 65 66 75  if you're carefu
00005050  6C 21 0A 0A 23 20 56 61 6C 75 65 20 6F 66 20 27  l!..# Value of '
00005060  65 6E 63 6F 64 69 6E 67 27 20 77 68 65 6E 20 74  encoding' when t
00005070  68 69 73 20 66 69 6C 65 20 77 61 73 20 77 72 69  his file was wri
00005080  74 74 65 6E 0A 2A 65 6E 63 6F 64 69 6E 67 3D 75  tten.*encoding=u
00005090  74 66 2D 38 0A 0A 0A 23 20 68 6C 73 65 61 72 63  tf-8...# hlsearc
000050A0  68 20 6F 6E 20 28 48 29 20 6F 72 20 6F 66 66 20  h on (H) or off
000050B0  28 68 29 3A 0A 7E 48 0A 23 20 4C 61 73 74 20 53  (h):.~H.# Last S
000050C0  65 61 72 63 68 20 50 61 74 74 65 72 6E 3A 0A 7E  earch Pattern:.~
000050D0  4D 53 6C 65 30 7E 2F 61 6C 6C 6F 63 61 74 65 5F  MSle0~/allocate_
000050E0  6D 61 70 0A 0A 23 20 43 6F 6D 6D 61 6E 64 20 4C  map..# Command L
000050F0  69 6E 65 20 48 69 73 74 6F 72 79 20 28 6E 65 77  ine History (new
 --- More ---

          0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F
00005100  65 73 74 20 74 6F 20 6F 6C 64 65 73 74 29 3A 0A  est to oldest):.
00005110  3A 71 0A 3A 77 0A 3A 65 20 62 75 67 73 2E 74 78  :q.:w.:e bugs.tx
00005120  74 0A 3A 65 20 69 6F 63 74 6C 2E 68 0A 3A 65 23  t.:e ioctl.h.:e#
00005130  0A 3A 65 20 73 74 72 75 63 74 2E 68 0A 3A 71 21  .:e struct.h.:q!
00005140  0A 3A 65 20 6B 65 72 6E 65 6C 2F 68 77 5F 62 72  .:e kernel/hw_br
00005150  65 61 6B 70 6F 69 6E 74 2E 63 0A 3A 65 20 64 65  eakpoint.c.:e de
00005160  62 75 67 2F 6D 64 62 2F 6D 64 62 2D 6D 61 69 6E  bug/mdb/mdb-main
00005170  2E 63 0A 3A 65 20 61 72 63 68 2F 78 38 36 2F 6B  .c.:e arch/x86/k
00005180  65 72 6E 65 6C 2F 74 72 61 70 73 2E 63 0A 3A 65  ernel/traps.c.:e
00005190  20 61 72 63 68 2F 78 38 36 2F 6B 65 72 6E 65 6C   arch/x86/kernel
000051A0  2F 68 77 5F 62 72 65 61 6B 70 6F 69 6E 74 2E 63  /hw_breakpoint.c
000051B0  0A 3A 65 20 6B 61 6C 6C 73 79 6D 73 2E 63 0A 3A  .:e kallsyms.c.:
000051C0  65 20 74 72 61 70 73 2E 63 0A 0A 23 20 53 65 61  e traps.c..# Sea
000051D0  72 63 68 20 53 74 72 69 6E 67 20 48 69 73 74 6F  rch String Histo
000051E0  72 79 20 28 6E 65 77 65 73 74 20 74 6F 20 6F 6C  ry (newest to ol
000051F0  64 65 73 74 29 3A 0A 3F 2F 61 6C 6C 6F 63 61 74  dest):.?/allocat
 --- More ---

          0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F
00005200  65 5F 6D 61 70 0A 3F 2F 73 63 61 6E 5F 70 61 72  e_map.?/scan_par
00005210  74 69 74 69 6F 6E 73 0A 3F 2F 6C 6F 63 6B 5F 76  titions.?/lock_v
00005220  6F 6C 75 6D 65 0A 3F 2F 63 61 63 68 65 0A 3F 2F  olume.?/cache.?/
00005230  69 66 6E 61 6D 65 0A 3F 2F 4D 61 6B 65 66 69 6C  ifname.?/Makefil
00005240  65 0A 3F 2F 65 78 74 61 62 6C 65 0A 3F 2F 4D 44  e.?/extable.?/MD
00005250  42 0A 3F 2F 69 6E 69 74 5F 68 77 5F 62 72 65 61  B.?/init_hw_brea
00005260  6B 70 6F 69 6E 74 0A 3F 2F 6E 6F 74 69 66 79 0A  kpoint.?/notify.
00005270  3F 2F 64 72 36 0A 0A 23 20 45 78 70 72 65 73 73  ?/dr6..# Express
00005280  69 6F 6E 20 48 69 73 74 6F 72 79 20 28 6E 65 77  ion History (new
00005290  65 73 74 20 74 6F 20 6F 6C 64 65 73 74 29 3A 0A  est to oldest):.
000052A0  0A 23 20 49 6E 70 75 74 20 4C 69 6E 65 20 48 69  .# Input Line Hi
000052B0  73 74 6F 72 79 20 28 6E 65 77 65 73 74 20 74 6F  story (newest to
000052C0  20 6F 6C 64 65 73 74 29 3A 0A 0A 23 20 49 6E 70   oldest):..# Inp
000052D0  75 74 20 4C 69 6E 65 20 48 69 73 74 6F 72 79 20  ut Line History
000052E0  28 6E 65 77 65 73 74 20 74 6F 20 6F 6C 64 65 73  (newest to oldes
000052F0  74 29 3A 0A 0A 23 20 52 65 67 69 73 74 65 72 73  t):..# Registers
 --- More ---

          0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F
00005300  3A 0A 22 30 09 4C 49 4E 45 09 30 0A 09 20 20 20  :."0.LINE.0..
00005310  20 20 20 20 20 20 20 20 20 20 20 20 20 20 20 20
00005320  20 20 20 20 22 25 30 38 58 20 69 66 3A 25 30 34      "%08X if:%04
00005330  6C 6C 75 20 5B 25 31 36 73 5D 20 25 30 34 58 20  llu [%16s] %04X
00005340  25 73 22 2C 0A 22 22 31 09 4C 49 4E 45 09 30 0A  %s",.""1.LINE.0.
00005350  09 20 20 20 20 7D 0A 22 32 09 4C 49 4E 45 09 30  .    }."2.LINE.0
00005360  0A 09 20 20 20 20 7B 0A 22 33 09 4C 49 4E 45 09  ..    {."3.LINE.
00005370  30 0A 09 2F 2F 73 74 61 74 69 63 20 69 6E 6C 69  0..//static inli
00005380  6E 65 20 75 6E 73 69 67 6E 65 64 20 6C 6F 6E 67  ne unsigned long
00005390  20 72 65 63 79 63 6C 65 5F 69 64 28 76 6F 69 64   recycle_id(void
000053A0  29 0A 22 34 09 4C 49 4E 45 09 30 0A 09 0A 22 35  )."4.LINE.0..."5
000053B0  09 4C 49 4E 45 09 30 0A 09 23 65 6E 64 69 66 0A  .LINE.0..#endif.
000053C0  22 36 09 4C 49 4E 45 09 30 0A 09 2F 2F 20 20 20  "6.LINE.0..//
000053D0  20 20 20 20 72 65 74 75 72 6E 20 2D 31 3B 0A 22      return -1;."
000053E0  37 09 4C 49 4E 45 09 30 0A 09 2F 2F 20 20 20 20  7.LINE.0..//
000053F0  69 66 20 28 76 65 72 69 66 79 5F 64 65 76 28 64  if (verify_dev(d
 --- More ---

          0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F
00005400  65 76 29 20 7C 7C 20 69 6E 73 65 72 74 5F 65 72  ev) || insert_er
00005410  72 6F 72 28 64 65 76 2C 20 69 29 29 20 0A 22 38  ror(dev, i)) ."8
00005420  09 4C 49 4E 45 09 30 0A 09 23 69 66 20 41 53 53  .LINE.0..#if ASS
00005430  45 52 54 0A 22 39 09 4C 49 4E 45 09 30 0A 09 0A  ERT."9.LINE.0...
00005440  22 2D 09 43 48 41 52 09 30 0A 09 20 0A 0A 23 20  "-.CHAR.0.. ..#
00005450  46 69 6C 65 20 6D 61 72 6B 73 3A 0A 27 30 20 20  File marks:.'0
00005460  38 20 20 37 35 20 20 2F 70 72 65 64 61 74 6F 72  8  75  /predator
00005470  2F 62 75 67 73 2E 74 78 74 0A 27 31 20 20 31 30  /bugs.txt.'1  10
00005480  32 20 20 30 20 20 2F 70 72 65 64 61 74 6F 72 2F  2  0  /predator/
00005490  6C 6F 67 69 63 61 6C 2E 63 0A 27 32 20 20 31 30  logical.c.'2  10
000054A0  35 34 20 20 30 20 20 2F 70 72 65 64 61 74 6F 72  54  0  /predator
000054B0  2F 63 73 6D 6F 6E 2E 63 0A 27 33 20 20 31 30 30  /csmon.c.'3  100
000054C0  34 20 20 34 31 20 20 2F 70 72 65 64 61 74 6F 72  4  41  /predator
000054D0

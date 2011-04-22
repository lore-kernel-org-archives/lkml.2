Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756029Ab1DVSod (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 14:44:33 -0400
Received: from outpost1.zedat.fu-berlin.de ([130.133.4.66]:50859 "EHLO
	outpost1.zedat.fu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755554Ab1DVSoc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 14:44:32 -0400
Subject: End of FAT directories
From: Michael Karcher <kernel@mkarcher.dialup.fu-berlin.de>
To: linux kernel FAT <hirofumi@mail.parknet.co.jp>,
        dosfstools <daniel@debian.org>, mtools <Alain@linux.lu>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 22 Apr 2011 20:48:56 +0200
Message-ID: <1303498136.8485.128.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
X-Originating-IP: 87.123.66.109
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Linux FAT developers and developers of related tools,

there seem to be different interpretations around how to read a FAT
directory that contains an entry starting with a NUL byte before further
entries *NOT* starting with NUL bytes. I uploaded an example image of
this type to [1]. It contains three zero-byte files "WINDOWS", "IS",
"GREAT", an empty directory slot and a file with contents named "NOT".

Listing a floppy with this directory contents in Windows gives the
output "WINDOWS", "IS" and "GREAT". Mounting the image in Linux results
in four visible files. Running dosfsck on that image outputs four files,
everything OK, while Windows CHKDSK will found one lost cluster in one
chain. mdir only lists the three files Windows will find too, but when
you copy a file that needs a long name to the image using mcopy, the
file will be appended where there are enough free slots in succession,
i.e. it will not fill the single empty slot. That means mcopy allocates
space for the file, writes a directory entry for it, but mdir does not
see it afterwards. On the other hand, as soon as you add a file that
does not need a long name entry that fills the hole, mdir shows all the
files it previously didn't show.

I'm afraid this is not a pure academic post, but I write it because I
spent hours on trying to find out why I had problem to make some USB
flash drive bootable with syslinux (which follows the MS model on
loading files while booting) after copying files with the linux kernel
(which follows the Linux model, obviously), additionally dosfsck on that
stick showed quite strange results (it dived into a directory that does
no longer exist). Another incarnation is mentioned in
https://wiki.physik.fu-berlin.de/linux-minidisc/doku.php?id=himddiskformat
in the section "Filesystem Issues with some Models on Linux". Some of
the Sony devices clear only the first half of the cluster containing
that subdirectory to zeroes, which works fine if software aborts on the
first entry being zero, but obviously makes problem if the second half
of the cluster is accessed.

I would really appreciate it if all FOSS working on FAT would agree to
one behaviour, and I think we have no choice except being MS compatible
(i.e. implement the behaviour as it has always been in DOS and Windows)

Please comment.

Regards,
  Michael Karcher


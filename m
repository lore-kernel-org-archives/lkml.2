Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752319Ab3AAOhN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2013 09:37:13 -0500
Received: from mondschein.lichtvoll.de ([194.150.191.11]:41222 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752245Ab3AAOhK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2013 09:37:10 -0500
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-kernel@vger.kernel.org
Subject: Re: Tux3 report: New news for the new year
Date: Tue, 1 Jan 2013 15:37:08 +0100
User-Agent: KMail/1.13.7 (Linux/3.7.0-f2fs-tp520+; KDE/4.8.4; x86_64; ; )
Cc: Daniel Phillips <lkml@phunq.net>
References: <2597526.usDRg4h3X1@mars> <201301011406.19983.Martin@lichtvoll.de> <1492866.3ugQ2fqrP0@mars> (sfid-20130101_150635_182498_1B81CD52)
In-Reply-To: <1492866.3ugQ2fqrP0@mars>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201301011537.08466.Martin@lichtvoll.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 1. Januar 2013 schrieb Daniel Phillips:
> On Tuesday, January 01, 2013 02:06:19 PM Martin Steigerwald wrote:
> > Sounds all good and nice and interesting to test, but where to grab the
> > source?
> > 
> > I found no obvious URL.
> 
> Hi Martin,
> 
> Sorry about that, I knew I forgot something:
> 
>     git://github.com/OGAWAHirofumi/tux3.git
> 
> Warning: the recent work is on branch temp-atomic-commit and tends to get
> refactored changeset-wise on a regular basis. This will be merged to
> master pretty soon, and settle down there.

Thanks.

I can compile and mkfs it with:

dd if=/dev/zero of=tux3.img bs=1M count=100

./tux3 mkfs tux3.img 


Writing a file with

./tux3 write tux3.img /etc/fstab

also seemed to work, but I gave up holding down the enter key at:

delta_get: delta 448, refcount 2
tuxio: write 1 bytes at 4484, isize = 0x1184
delta_put: delta 448, refcount 1


/etc/fstab is 1714 bytes long.



No tux3fuse, but then, I lacked libfuse-dev, after installing, compiling
worked:

martin@merkaba:~[…]> make tux3fuse
gcc -MF ./.deps/tux3fuse.d -MP -MMD -m64 -std=gnu99 -Wall -g -rdynamic -D_GNU_SOURCE -D_FILE_OFFSET_BITS=64 -
I/home/martin/Linux/Dateisysteme/tux3/tux3/user -Wall -Wextra -Werror -Wundef -Wstrict-prototypes -Werror-implicit-
function-declaration -Wno-unused-parameter -Wno-sign-compare -Wno-missing-field-initializers -D_FORTIFY_SOURCE=2 -
DLOCK_DEBUG=1 -DROLLUP_DEBUG=1 -DDISABLE_ASYNC_BACKEND=1   $(pkg-config --cflags fuse) tux3fuse.c -lfuse -o 
tux3fuse libtux3.a libklib/libklib.a


Then I could use it:

martin@merkaba:~[…]> ./tux3 mkfs tux3.img                       
__setup_sb: blocksize 4096, blockbits 12, blockmask 00000fff
__setup_sb: volblocks 25600, freeblocks 25600, freeinodes 281474976710656, nextalloc 0
__setup_sb: atom_dictsize 0, freeatom 0, atomgen 1
__setup_sb: logchain 0, logcount 0
make tux3 filesystem on tux3.img (0x6400000 bytes)
[…]

martin@merkaba:~[…]> sudo ./tux3fuse tux3.img /mnt/zeit
[sudo] password for martin: 

martin@merkaba:~[…]> mount | grep fuse
fusectl on /sys/fs/fuse/connections type fusectl (rw,relatime)
tux3.img on /mnt/zeit type fuse.tux3.img (rw,nosuid,nodev,relatime,user_id=0,group_id=0)



But I am stuck with accessing it:

martin@merkaba:~[…]> LANG=C ls -l /mnt/zeit            
ls: cannot access /mnt/zeit: Permission denied

martin@merkaba:~[…]> LANG=C sudo chown martin:martin /mnt/zeit
chown: cannot access '/mnt/zeit': Transport endpoint is not connected
martin@merkaba:~[…]> LANG=C sudo ls -l /mnt/zeit
ls: cannot access /mnt/zeit: Transport endpoint is not connected
martin@merkaba:~[…]>


Unmounting it again worked nicely.


I keep it at that for now until I may take time to take a closer look.

I think its better to continue this on tux3 mailing list, which I have
subscribed to. But I thought I post this here, to give others some starting
point for own experiments as I did not any documentation about this
in the git repo.

Thanks,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752553Ab3AAVtj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2013 16:49:39 -0500
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:36005 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752448Ab3AAVth convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2013 16:49:37 -0500
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.1 cv=7/EMZfWbaVtDMdTqnk9efwidrOfQb3DZMdpNhNw5Oc4= c=1 sm=1
 a=z4rSCaSvssEA:10 a=TPbdJ-YLJ1kA:10 a=FGLzUi7B6sIA:10 a=BLceEmwcHowA:10
 a=IkcTkHD0fZMA:10 a=eeMGdU6VVFt2UVJcxx6VzA==:17 a=Ct3E01xRAAAA:8
 a=6WXkX7kQAAAA:8 a=YL6Xjd1eAAAA:8 a=HxcpZutCpreehIb2OSEA:9
 a=QEXdDO2ut3YA:10 a=lIfXHRvV9fAA:10 a=4zbRpb9PoSwA:10 a=Q0GbjdkhIAgA:10
 a=joHjtyyeX6UA:10 a=GGPREIEW7d8A:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
From: Daniel Phillips <lkml@phunq.net>
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Tux3 report: New news for the new year
Date: Tue, 01 Jan 2013 13:49:37 -0800
Message-ID: <18617468.vkbTvjxc0P@mars>
Organization: tux3.org
User-Agent: KMail/4.8.5 (Linux/3.2.0-35-generic-pae; KDE/4.8.5; i686; ; )
In-Reply-To: <201301011537.08466.Martin@lichtvoll.de>
References: <2597526.usDRg4h3X1@mars> <1492866.3ugQ2fqrP0@mars> <201301011537.08466.Martin@lichtvoll.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Martin,

Thanks for the "tux3 howto". Obviously tux3.org needs refresh, but you hit the 
main points.

On Tuesday, January 01, 2013 03:37:08 PM you wrote:
> Writing a file with
> 
> ./tux3 write tux3.img /etc/fstab
> 
> also seemed to work, but I gave up holding down the enter key at:
> 
> delta_get: delta 448, refcount 2
> tuxio: write 1 bytes at 4484, isize = 0x1184
> delta_put: delta 448, refcount 1
> 
> /etc/fstab is 1714 bytes long.

Indeed, the trace output is too chatty, but it's nice that it wrote a file. The 
tux3 command is cool, it can access and update an unmounted tux3 volume, even 
make diagrams of it. This will form the basis of our maintenance suite. A 
basic "tux3 fsck" is under construction:

    http://phunq.net/pipermail/tux3/2012-December/000012.html
    "Towards basic filesystem checking"

    http://phunq.net/pipermail/tux3/2012-December/000013.html
    "Towards basic filesystem checking (simplified)"

> No tux3fuse, but then, I lacked libfuse-dev, after installing, compiling
> worked:
> 
> martin@merkaba:~[…]> make tux3fuse
> gcc -MF ./.deps/tux3fuse.d -MP -MMD -m64 -std=gnu99 -Wall -g -rdynamic
> -D_GNU_SOURCE -D_FILE_OFFSET_BITS=64 -
> I/home/martin/Linux/Dateisysteme/tux3/tux3/user -Wall -Wextra -Werror
> -Wundef -Wstrict-prototypes -Werror-implicit- function-declaration
> -Wno-unused-parameter -Wno-sign-compare -Wno-missing-field-initializers
> -D_FORTIFY_SOURCE=2 - DLOCK_DEBUG=1 -DROLLUP_DEBUG=1
> -DDISABLE_ASYNC_BACKEND=1   $(pkg-config --cflags fuse) tux3fuse.c -lfuse
> -o tux3fuse libtux3.a libklib/libklib.a
> 
> Then I could use it:
> 
> martin@merkaba:~[…]> ./tux3 mkfs tux3.img
> __setup_sb: blocksize 4096, blockbits 12, blockmask 00000fff
> __setup_sb: volblocks 25600, freeblocks 25600, freeinodes 281474976710656,
> nextalloc 0 __setup_sb: atom_dictsize 0, freeatom 0, atomgen 1
> __setup_sb: logchain 0, logcount 0
> make tux3 filesystem on tux3.img (0x6400000 bytes)
> […]
> 
> martin@merkaba:~[…]> sudo ./tux3fuse tux3.img /mnt/zeit
> [sudo] password for martin:
> 
> martin@merkaba:~[…]> mount | grep fuse
> fusectl on /sys/fs/fuse/connections type fusectl (rw,relatime)
> tux3.img on /mnt/zeit type fuse.tux3.img
> (rw,nosuid,nodev,relatime,user_id=0,group_id=0)
> 
> But I am stuck with accessing it:
> 
> martin@merkaba:~[…]> LANG=C ls -l /mnt/zeit
> ls: cannot access /mnt/zeit: Permission denied
> 
> martin@merkaba:~[…]> LANG=C sudo chown martin:martin /mnt/zeit
> chown: cannot access '/mnt/zeit': Transport endpoint is not connected
> martin@merkaba:~[…]> LANG=C sudo ls -l /mnt/zeit
> ls: cannot access /mnt/zeit: Transport endpoint is not connected
> martin@merkaba:~[…]>
> 
> Unmounting it again worked nicely.

That would be a bug, most probably in the fuse glue. Nearly all the testing 
recently has been on the kernel port (mostly under kvm) so its nice to hear 
that tux3 write still works and tux3fuse almost works. Probably, the fuse glue 
hit an assert and bailed out, causing the "endpoint is not connected" state. A 
good example of why it would be nice to beef up our team a little. Anybody who 
wants to take charge of the fuse glue is welcome.

> I keep it at that for now until I may take time to take a closer look.
>
> I think its better to continue this on tux3 mailing list, which I have
> subscribed to. But I thought I post this here, to give others some starting
> point for own experiments as I did not any documentation about this
> in the git repo.

Thanks, that was great, and quick. We look forward to seeing you on the Tux3 
mailing list.

Another thing I forgot to post is a link to the tux3 mailing list:

     http://phunq.net/mailman/listinfo/tux3

Also, we are on oftc.net, #tux3 channel.

We will do our best to improve the howto documentation. A wiki would be nice. 
We may start one on github, then set one up on tux3.org later. Currently, the 
main focus is on filling in the last few big pieces needed to scale well, and 
of course, debugging. A few more helping hands on things like wikis and 
documentation refresh would be most appreciated. For now, design documentation 
and howtos get posted to the Tux3 mailing list. You are more than welcome to 
post your recipes above.

Thanks again,

Daniel


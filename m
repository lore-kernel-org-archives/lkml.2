Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754126Ab0JVJYl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 05:24:41 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:60741 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751750Ab0JVJYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 05:24:40 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: sedat.dilek@gmail.com
Subject: Re: linux-next: next-20101022 broken with unset CONFIG_BKL
Date: Fri, 22 Oct 2010 11:24:32 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-next-20101021+; KDE/4.5.1; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, sfr@canb.auug.org.au,
        Jan Harkes <jaharkes@cs.cmu.edu>
References: <AANLkTi=vUA-u20egbpH1Wu4ek-craz7aZUxWmobL8OhD@mail.gmail.com>
In-Reply-To: <AANLkTi=vUA-u20egbpH1Wu4ek-craz7aZUxWmobL8OhD@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <201010221124.32842.arnd@arndb.de>
X-Provags-ID: V02:K0:mLfoh1hxxvemhrvs6LhUlEL6pS4ICd/OBPWBOuA1tju
 Z+UxaV2ea0Jdz2sjyp/90EuN8C9Zz2wMDgCmFCIywfhYObVvhd
 Go1b+BPQm/AQSjdLDaqDCAq0cjn0req7gWs6MKMEh+LnpCKD2h
 9pFR6pGO0jbwPH9m+UNnhWUPMl1/yKXm7Wj1oGILDMQ2pMZCcy
 ZehsidOR+y6PkKAnqPgGg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 22 October 2010 11:13:23 Sedat Dilek wrote:
> Hi,
> 
> I am trying to compile latest linux-next with unset CONFIG_BKL.
> Yes, one patch is missing from [1] to be able to compile a BKL-free kernel.
> (BTW, the patch needs a trivial fix, see v2 attached to this email.)
> 
> With next-20101022 the build breaks (sorry for the output in German):
> 
> [ build.log ]
> ...
>   LD [M]  fs/ceph/ceph.o
>   LD      fs/coda/built-in.o
>   CC [M]  fs/coda/psdev.o
>   CC [M]  fs/cifs/misc.o
> /home/sd/src/linux-2.6/linux-2.6.36/debian/build/source_i386_none/fs/coda/psdev.c:
> In function ‘coda_psdev_write’:
> /home/sd/src/linux-2.6/linux-2.6.36/debian/build/source_i386_none/fs/coda/psdev.c:140:
> error: implicit declaration of function ‘lock_kernel’
> /home/sd/src/linux-2.6/linux-2.6.36/debian/build/source_i386_none/fs/coda/psdev.c:142:
> error: implicit declaration of function ‘unlock_kernel’
>   CC      block/blk-settings.o
> make[6]: *** [fs/coda/psdev.o] Fehler 1
> make[5]: *** [fs/coda] Fehler 2
> make[5]: *** Warte auf noch nicht beendete Prozesse...
> ...
> 
> Just FYI.
> 

Ok, thanks for the report. There is a patch for coda to remove the BKL.
We discussed it yesterday and I subsequently removed the switch that
disables it on non-BKL configs.

We then agreed to not have the patch included in my series, and Jan's
tree is not part of linux-next.

There are more of these in mainline once Linus pulls my tree, but that
just means that we need to get all the other trees into -rc1 that
remove the BKL from other subsystems, before applying the patch that
lets you build with CONFIG_FILE_LOCKING=y and CONFIG_BKL=n.

Right now, both allyesconfig (with BKL) and allnoconfig (without coda)
work fine, we only get a few really obscure randconfigs breaking.

	Arnd

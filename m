Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752902Ab0LFMgn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 07:36:43 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:55263 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751200Ab0LFMgm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 07:36:42 -0500
To: Michael Leun <lkml20101129@newton.leun.net>
CC: miklos@szeredi.hu, hughd@google.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-reply-to: <20101203085350.55f94057@xenia.leun.net> (message from Michael
	Leun on Fri, 3 Dec 2010 08:53:50 +0100)
Subject: Re: kernel BUG at mm/truncate.c:475!
References: <20101130194945.58962c44@xenia.leun.net>
	<alpine.LSU.2.00.1011301453090.12516@tigran.mtv.corp.google.com>
	<E1PNjsI-0005Bk-NB@pomaz-ex.szeredi.hu>
	<20101201124528.6809c539@xenia.leun.net>
	<E1PNqO1-0005px-9h@pomaz-ex.szeredi.hu>
	<20101202084159.6bff7355@xenia.leun.net>
	<20101202091552.4a63f717@xenia.leun.net>
	<E1PO5gh-00079U-Ma@pomaz-ex.szeredi.hu>
	<20101202115722.1c00afd5@xenia.leun.net> <20101203085350.55f94057@xenia.leun.net>
Message-Id: <E1PPaIw-0004pW-Mk@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 06 Dec 2010 13:36:30 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Dec 2010, Michael Leun wrote:
> On Thu, 2 Dec 2010 11:57:22 +0100
> Michael Leun <lkml20101129@newton.leun.net> wrote:
> 
> > > Can you please describe in detail the workload that's causing this
> > > to happen?
> > 
> > Thats rather complicated, but I'll try. Basically it boils down to:
> > 
> > unshare -n -m /bin/bash
> > unionfs -o
> > cow,suid,allow_other,max_files=65536 /home/netenv/user1-union=RW:/=RO /home/netenv/user1
> > mount -n -t proc none /home/netenv/user1/proc mount -n -t sysfs
> > none /home/netenv/user1/sys mount -n -t devtmpfs
> > devtmpfs /home/netenv/user1/dev mount -n -t devpts
> > devpts /home/netenv/user1/dev/pts chroot /home/netenv/user1 /bin/su -
> > user1
> [...]
> > In some of this setups two or more environments share the same
> > writable branch, so the files in this environments changed against
> > real root of the machine are the same, e.g.:
> > 
> > [...]
> > unionfs -o
> > cow,suid,allow_other,max_files=65536 /home/netenv/commondir=RW:/=RO /home/netenv/user1
> > [...]
> > 
> > and another one
> > 
> > [...]
> > unionfs -o
> > cow,suid,allow_other,max_files=65536 /home/netenv/commondir=RW:/=RO /home/netenv/user2
> > [...]
> 
> Additional note: Happens also WITHOUT that "two unionfs mounts use the
> same branch dir" stuff.

Thanks.

For you the workaround would be to use the "kernel_cache" option which
disables cache invalidation on open.

I'll try to reproduce the BUG on my machine, and if I don't succeed
I'll need som more help from you.

Also could you please send me your kernel .config

> 
> Really seems to happen much more often in 2.6.36.1 than in 2.6.36.

Probably just coincidence.  Sometimes the frequency a bug shows up
depends on code layout (and hence cache layout) differences, which can
vary from compile to compile and even from one boot to the next.

Thanks,
Miklos

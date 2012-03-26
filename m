Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757594Ab2CZWhk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 18:37:40 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36020 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751431Ab2CZWhj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 18:37:39 -0400
Date: Mon, 26 Mar 2012 15:37:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Valdis.Kletnieks@vt.edu
Cc: Vasiliy Kulikov <segoon@openwall.com>,
        Arkadiusz =?UTF-8?Q?Mi=C5=9Bkie?= =?ISO-8859-1?Q?wicz?= 
	<a.miskiewicz@gmail.com>,
        linux-kernel@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH] proc: fix mount -t proc -o AAA
Message-Id: <20120326153738.aa728115.akpm@linux-foundation.org>
In-Reply-To: <97428.1332714196@turing-police.cc.vt.edu>
References: <201203220903.15360.a.miskiewicz@gmail.com>
	<20120323171058.GA3279@albatros>
	<20120323161504.dced28b9.akpm@linux-foundation.org>
	<201203250924.06908.a.miskiewicz@gmail.com>
	<20120325153612.GC4391@albatros>
	<97428.1332714196@turing-police.cc.vt.edu>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 25 Mar 2012 18:23:16 -0400
Valdis.Kletnieks@vt.edu wrote:

> On Sun, 25 Mar 2012 19:36:12 +0400, Vasiliy Kulikov said:
> > On Sun, Mar 25, 2012 at 09:24 +0200, Arkadiusz MiEkiewicz wrote:
> > > but there is another problem - unmounting it and mounting without options
> > > causes old option to persist:
> > >
> > > # mount none /proc -t proc -o hidepid=2
> > > # umount /proc
> > > # mount none /proc -t proc
> > > # grep "/proc" /proc/mounts
> > > none /proc proc rw,relatime,hidepid=2 0 0
> > >
> > > There should be no hidepid=2 now.
> >
> > No, that's an expected behaviour.
> 
> "You keep using that word. I do not think it means what you think it means". ;)
> 
> > Procfs is a special filesystem.
> 
> And the fact it's "special" makes this *unexpected* behavior.  Are there
> any other filesystems where -o values will persist across an unmount
> and then take effect *even if no -o is given* on a subsequent mount?
> 
> Yes, it may be what the code actually *does*, but it certainly violates
> the Principle of Least Surprise...

It surprises me ;)  I never noticed that before.

It does seem pretty insane.  I wonder how much downstream damage would
result from fixing it.

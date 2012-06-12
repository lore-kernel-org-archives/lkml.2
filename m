Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754429Ab2FLVR7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 17:17:59 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33551 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754402Ab2FLVR5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 17:17:57 -0400
Date: Tue, 12 Jun 2012 23:09:47 +0200
From: Jan Kara <jack@suse.cz>
To: Wallak <wallak@free.fr>
Cc: Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: File copy is very slow on linux-3.4.2 (or linux-3.3x) on a
 specific hardware: AMD FX-8150 + 990FX
Message-ID: <20120612210947.GB20007@quack.suse.cz>
References: <1108815600.134531433.1339443818361.JavaMail.root@zimbra44-e7.priv.proxad.net>
 <437497008.134549481.1339444456294.JavaMail.root@zimbra44-e7.priv.proxad.net>
 <20120612165357.GI6021@quack.suse.cz>
 <4FD78CE4.4000209@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FD78CE4.4000209@free.fr>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 12-06-12 20:39:32, Wallak wrote:
> Jan Kara wrote:
> >On Mon 11-06-12 21:54:16, wallak@free.fr wrote:
> >>I've a very annoying issue on recent kernel (linux-3.4.2-SMP) with my main motherboard (AMD FX-8150 + 990FX - 8 cores 4.1GHz), file copy is very slow (see below). The same kernel works flawlessly on an AMD E450 2 cores motherboard.
> >>
> >>Linux-3.2.20 works properly on this hardware.
> >>hdparm -t gives good results on both kernels.
> >>
> >>I've no idea where this bug come from. Do you have this issue on your hardware ? A patch is available ?
> >>
> >>
> >>*linux-3.4.2
> >>dd if=../in/file_8gb.tmp of=tmp.tmp bs=1024k count=100
> >>100+0 records in
> >>100+0 records out
> >>104857600 bytes (105 MB) copied, 132.884 s, 789 kB/s
> >>
> >>
> >>*linux-3.2.20
> >>dd if=../in/file_8gb.tmp of=tmp.tmp bs=1024k count=100
> >>100+0 records in
> >>100+0 records out
> >>104857600 bytes (105 MB) copied, 3.30793 s, 31.7 MB/s
> >   So let's separate reading and writing part first. What is the speed of
> >dd if=../in/file_8gb.tmp of=/dev/null bs=1M count=100
> >   on both kernels?
> >And what is the speed of:
> >dd if=/dev/zero of=tmp.tm bs=1M count=100
> 
> You're right, the issue is only while writing. The results are below:
> 
> #linux-3.4.2
> dd if=/dev/zero of=tmp.tm bs=1M count=100
> 100+0 records in
> 100+0 records out
> 104857600 bytes (105 MB) copied, 151.347 s, 693 kB/s
> dd if=../in/file_8gb.tmp of=/dev/null bs=1M count=100
> 100+0 records in
> 100+0 records out
> 104857600 bytes (105 MB) copied, 1.26228 s, 83.1 MB/s
> 
> #linux-3.2.20
> dd if=/dev/zero of=tmp.tm bs=1M count=100
> 100+0 records in
> 100+0 records out
> 104857600 bytes (105 MB) copied, 1.00838 s, 104 MB/s
> dd if=../in/file_8gb.tmp of=/dev/null bs=1M count=100
> 100+0 records in
> 100+0 records out
> 104857600 bytes (105 MB) copied, 1.26947 s, 82.6 MB/s
> 
> 
> >
> >   Also what filesystems are you using?
> 
> This is an ext2 file system:
> 
> /dev/sda6      ext2    464463364 323380956 141082408  70% /backup
  OK, I'm surprised by one thing - how come the writes do no end up cached
in memory (thus you should get much higher throughput). Is the filesystem
mounted with -o sync option by any chance?

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

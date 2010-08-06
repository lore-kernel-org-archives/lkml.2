Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934128Ab0HFIPn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 04:15:43 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:42963 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759216Ab0HFIPg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 04:15:36 -0400
To: Valerie Aurora <vaurora@redhat.com>
CC: miklos@szeredi.hu, viro@zeniv.linux.org.uk, jblunck@suse.de,
        hch@infradead.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, tytso@mit.edu,
        linux-ext4@vger.kernel.org
In-reply-to: <20100805233019.GA30761@shell> (message from Valerie Aurora on
	Thu, 5 Aug 2010 19:30:19 -0400)
Subject: Re: [PATCH 14/38] fallthru: ext2 fallthru support
References: <1276627208-17242-1-git-send-email-vaurora@redhat.com> <1276627208-17242-15-git-send-email-vaurora@redhat.com> <E1OgfCU-0000ko-Lu@pomaz-ex.szeredi.hu> <20100804224831.GB29353@shell> <E1Ogxol-0002xs-De@pomaz-ex.szeredi.hu> <20100805233019.GA30761@shell>
Message-Id: <E1OhI5C-0005PG-3G@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 06 Aug 2010 10:15:14 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Aug 2010, Valerie Aurora wrote:
> On Thu, Aug 05, 2010 at 12:36:55PM +0200, Miklos Szeredi wrote:
> > On Wed, 4 Aug 2010, Valerie Aurora wrote:
> > > --zYM0uCDKw75PZbzx
> > > Content-Type: text/plain; charset=us-ascii
> > > Content-Disposition: inline
> > > 
> > > On Wed, Aug 04, 2010 at 04:44:10PM +0200, Miklos Szeredi wrote:
> > > > On Tue, 15 Jun 2010, Valerie Aurora wrote:
> > > > > Add support for fallthru directory entries to ext2.
> > > > 
> > > > If a previously used ext2 filesystem with is mounted again then
> > > > fallthroughs don't appear to work as expected.  Stat returns ENOENT
> > > > for these entries.
> > > > 
> > > > Can't see anything obviously wrong with the code.
> > > 
> > > Hm, I wrote one test case for this that worked (attached).  Can you
> > > give me more details on your test case?  Thanks,
> 
> Cool, thanks.  Yes, I suppose the fallthrus should be ignored if they
> don't fall through to anything.

That's not the case here.  They _should_ fall through to ext3.img, yet
apparently after ovl.img being mounted again they don't seem to work.

Note, ovl.img starts out as a completely empty filesystem.

The difference between your test case and mine mitght be that yours
not only reads the directory but stats the files as well, while mine
does not.

Thanks,
Miklos


> 
> > uml:~# mount -oloop -r ext3-2.img /mnt/img/
> > uml:~# mount -oloop -r ext3.img /mnt/img/
> > uml:~# losetup -f ovl.img 
> > uml:~# mmount -b 8 -t ext2 /dev/loop2 /mnt/img/
> > uml:~# "ls" /mnt/img
> > bunion  lost+found  union
> > uml:~# "ls" /mnt/img/union
> > 1  2  3
> > uml:~# "ls" /mnt/img/union/1
> > a  x
> > uml:~# umount /mnt/img/
> > uml:~# mmount -b 8 -t ext2 /dev/loop2 /mnt/img/
> > uml:~# ls -l /mnt/img/  
> > total 14
> > drwxr-xr-x 2 root root  1024 Aug  5 09:56 bunion
> > drwx------ 2 root root 12288 Aug  5 09:41 lost+found
> > drwxr-xr-x 3 root root  1024 Aug  5 09:56 union
> > uml:~# ls -l /mnt/img/union/
> > ls: cannot access /mnt/img/union/3: No such file or directory
> > ls: cannot access /mnt/img/union/2: No such file or directory
> > total 1
> > drwxr-xr-x 2 root root 1024 Aug  5 09:56 1
> > ?????????? ? ?    ?       ?            ? 2
> > ?????????? ? ?    ?       ?            ? 3
> > uml:~# ls -l /mnt/img/union/1
> > ls: cannot access /mnt/img/union/1/a: No such file or directory
> > ls: cannot access /mnt/img/union/1/x: No such file or directory
> > total 0
> > ?????????? ? ? ? ?            ? a
> > ?????????? ? ? ? ?            ? x
> > uml:~# 
> > 
> > Thanks,
> > Miklos
> 

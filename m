Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752749Ab1KIGxT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 01:53:19 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:51859 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751234Ab1KIGxR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 01:53:17 -0500
MIME-Version: 1.0
In-Reply-To: <20111108201753.GA4149@shiny>
References: <20111106183851.GA4339@shiny>
	<CAPL5yKcDKnB+BaTdARSp80pGVr_W36cy9gNz=M-S8E3NyNDTQg@mail.gmail.com>
	<20111108182728.GR4954@shiny>
	<20111108201753.GA4149@shiny>
Date: Wed, 9 Nov 2011 01:53:15 -0500
Message-ID: <CAPL5yKfHjzeP_8gV9WMwY=SrA23wMWGJNnPH5cYNeZsoNQ3zpA@mail.gmail.com>
Subject: Re: [GIT PULL] Btrfs pull request
From: Dan Merillat <dan.merillat@gmail.com>
To: Chris Mason <chris.mason@oracle.com>,
        Dan Merillat <dan.merillat@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 8, 2011 at 3:17 PM, Chris Mason <chris.mason@oracle.com> wrote:
> On Tue, Nov 08, 2011 at 01:27:28PM -0500, Chris Mason wrote:
>> On Tue, Nov 08, 2011 at 12:55:40PM -0500, Dan Merillat wrote:
>> > On Sun, Nov 6, 2011 at 1:38 PM, Chris Mason <chris.mason@oracle.com> wrote:
>> > > Hi everyone,
>> > >
>> > > This pull request is pretty beefy, it ended up merging a number of long
>> > > running projects and cleanup queues.  I've got btrfs patches in the new
>> > > kernel.org btrfs repo.  There are two different branches with the same
>> > > changes.  for-linus is against 3.1 and has also been tested against
>> > > Linus' tree as of yesterday.
>> >
>> > [91795.123286] device label ROOT devid 1 transid 3331 /dev/sdi2
>> > [91795.123538] btrfs: open_ctree failed
>> >
>> > FS created on 3.1 (x64), mounted once on 3.2-rc1 (i386), got that
>> > whenI tried to mount on 3.1 (x64) again.  Format change in 3.2 or
>> > 32/64 bit compatibility issues?
>>
>> I'm trying to reproduce right now but I did many bounces between 3.2 and
>> 3.1 code before releasing.  I didn't try jumping between 32 and 64 bit.
>>
>> Are there any other messages in dmesg?  Could you please see what
>> btrfs-debug-tree says?
>
> Ok, so I spun the wheel going between 32 and 64 and 3.1 and 3.2.  I'm
> not having trouble with basic tests.
>
> So, we'll have to dig in and see why the open is failing.  btrfsck or
> btrfs-debug-tree will help.

This is on a USB device, however I had used the filesystem quite a bit
on the 64bit machine before moving it to the 32bit 3.2 box.   It's
still mountable on the 32bit box even when I get the open_ctree failed
on 3.1

[140865.425067] device label ROOT devid 1 transid 3436 /dev/sdi2
[140865.426291] btrfs: open_ctree failed
harik@fileserver:~/src/3.0/3.2-rc1$ sudo btrfsck /dev/sdi2
[sudo] password for harik:
found 3105894400 bytes used err is 0
total csum bytes: 2916272
total tree bytes: 119631872
total fs tree bytes: 109928448
btree space waste bytes: 33045213
file data blocks allocated: 5391962112
 referenced 2984988672
Btrfs Btrfs v0.19

http://dl.dropbox.com/u/1071112/btrfs-debug-tree.sdi2.bz2

Exact kernel that won't mount is linus 3.1 +
Author: David Sterba <dsterba@suse.cz>
Date:   Wed Aug 3 11:08:02 2011 -0700
    btrfs: allow cross-subvolume file clone

Author: Li Zefan <lizf@cn.fujitsu.com>
Date:   Fri Sep 2 15:56:25 2011 +0800

    Btrfs: fix defragmentation regression

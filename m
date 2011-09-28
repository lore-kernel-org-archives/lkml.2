Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753039Ab1I1Fe4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 01:34:56 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:43125 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752160Ab1I1Fey (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 01:34:54 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFxp8bNhLs+v69gp7XxBGq6wkmLkZKjB2_09H3qsZC_pzw@mail.gmail.com>
References: <CA+55aFwdm3n+xehYc1cronkcwLE79ZYtr96LiVWD2WjKkaZ5DA@mail.gmail.com>
	<CACqU3MXzUbQS9fy0Etgt2GcgwRoXfihhmw-aWjrCFbzvmDM7yg@mail.gmail.com>
	<CA+55aFwKyd5fuyxu2tGDbQ8gKiEj=z7uYdBRg9O46WN0sTeNTQ@mail.gmail.com>
	<CACqU3MU8jkysNxFasdfy9ksqSo2ojiZ5LUwfcfX13MMRgVx2Xw@mail.gmail.com>
	<CACqU3MWyCknNH3xmVmbJJu+w9ugNc3e4K3e3_6cY1RAy4ynJCQ@mail.gmail.com>
	<CA+55aFxp8bNhLs+v69gp7XxBGq6wkmLkZKjB2_09H3qsZC_pzw@mail.gmail.com>
Date: Wed, 28 Sep 2011 01:34:53 -0400
Message-ID: <CACqU3MUbiQW3E8GeSbzkikMqvV1VKAnF2Ro-P2BWwih=s6vABA@mail.gmail.com>
Subject: Re: Linux 3.1-rc7
From: Arnaud Lacombe <lacombar@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Sep 27, 2011 at 7:31 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Tue, Sep 27, 2011 at 4:25 PM, Arnaud Lacombe <lacombar@gmail.com> wrote:
>>
>> What is strange is that I moved from -rc7 to -rc8 with:
>>
>> % git reset --hard v3.1-rc8
>
> Git optimizes all the filesystem operations heavily. That means that
> files that have not changed between two releases and are clean (and
> match) in the index are not re-written by a git reset.
>
> You can obviously always force a re-write by removing all files and
> then doing the reset, but it should never be necessary under normal
> circumstances.
>
>> which should have reset the corrupted file. FYI, the machine is
>> running 2.6.35.13-91.fc14.x86_64. Something's smelly with that kernel
>> :-/
>
> More likely something is smelly with your filesystem or memory. A few
> bits flipped on disk or in the page cache would do it, and git has
> caught corruption like that before.
>
> Do you still have the bad tree around? Because it migth be interesting
> to see what the corruption pattern is if you do.
>
No, unfortunately I checked the file out and overwrote it several
time. I'll be more careful next time.

<off-topic>
Speaking of corruption, I'm encountering another set on an external
hard-drive, connected through USB. The partition ended up being
corrupted after transferring a few dozen GB, and being unmount'ed, ie.
I unmounted the device and tried to mount it back, no spin-down or
whatever; and the superblock was corrupted. fsck corrected a lots of
issue, wrong group checksum, wrong group block usage count (mainly was
always 32768)... but now, some files have wrong checksums
(expectable). These files only seems to belong to files previously
transferred. Luckily, some of these are text file, so I can easily do
a diff. The same corruption pop up (at least in those text file): a
sequence of 4 bytes is replaced by 0x000000E0 at offset 0x1E4 of the
start of the file for some of them, 0x3E4 for two other (same
corruption though). Locating the corruption will be more tricky in
binary files.

I may not trust the drive, but the fact that only known offset are
corrupted (in text files), the exact same way, sounds too much of a
coincidence. Anyway, I started a long SMART self test to see if it
catches anything, as there was no DMA transfer error[0].
</off-topic>

my 2c,
 - Arnaud

[0]: there used to be, but this was because of a bad SATA cable.

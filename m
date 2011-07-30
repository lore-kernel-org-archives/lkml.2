Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753389Ab1G3Crg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 22:47:36 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:49244 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753349Ab1G3Crf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 22:47:35 -0400
MIME-Version: 1.0
In-Reply-To: <4E33397F.4010908@draigBrady.com>
References: <CAPweEDzv+vByC1s2bWRjVQdVLqw4Xf2sUf_CQgVync_YcxtdvQ@mail.gmail.com>
 <20110725134533.GA23781@citd.de> <CAPweEDybuOpPVidJWg+rfs8rU8y=xo4d3H=P7XQJh_DiKrF4DQ@mail.gmail.com>
 <20110729195904.GC1720@ucw.cz> <20110729213156.GA32685@citd.de> <4E33397F.4010908@draigBrady.com>
From: Kyle Moffett <kyle@moffetthome.net>
Date: Fri, 29 Jul 2011 22:47:14 -0400
Message-ID: <CAGZ=bq+xewnb9UKEe-LxQgFs-L7uYm-349OKcn9Qq_1kXtL9Ag@mail.gmail.com>
Subject: Re: ext3 hacked filesystem (by debian exim4 exploit) available for
 analysis and bugreporting
To: =?UTF-8?Q?P=C3=A1draig_Brady?= <P@draigbrady.com>
Cc: Matthias Schniedermeyer <ms@citd.de>, Pavel Machek <pavel@ucw.cz>,
        Luke Kenneth Casson Leighton <lkcl@lkcl.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Coreutils <coreutils@gnu.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/7/29 Pádraig Brady <P@draigbrady.com>:
>>> Should ls -l be moddified to show something when file has immutable
>>> (and friends) set?
>>
>> AFAICT lsattr, in e2fsprogs, only does a 'stat'(lib/e2p/fgetflags.c) and
>> checks st_flags, which i can't see in the "man 2 stat"-man-page i have
>> installed, but nonetheless that is what it appears to do.
>>
>> So assuming there are no incompatibilites between filesystems, the
>> information appears to come "free" with the stat(s) that ls has to do
>> anyway. (In the sense that there doesn't appear to any excessive
>> overhead involved, especially no additional I/O).
>>
>> So i would say: definitly.
>
> `strace lsattr ...` shows it calls ioctl (...FS_IOC_GETFLAGS...)
> So there would be overhead.
> The output of ls is fairly constrained too for compat reasons.
>
> However these flags are not specific to ext2 so it would fit
> quite well from that perspective.
> It might be something we could add to the stat command at least?

Well, "ls" already displays information about POSIX ACLs by putting
a "+" after the UNIX permission bits.  Some other UNIXen (such as
Mac OS X) seem to use an "@" character to indicate xattrs or other
forks of a file, so perhaps it would not be too inappropriate to throw
an "@" symbol on a file for ext3 immutable bits and such.

The question is what to do if something has both ACLs and
ext3 attributes; should it get both characters?  Just one?
Perhaps a unique character?

I dunno...  Just food for thought...

Cheers,
Kyle Moffett

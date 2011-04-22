Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754006Ab1DVUkx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 16:40:53 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:51386 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751984Ab1DVUkt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 16:40:49 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Michael Karcher <kernel@mkarcher.dialup.fu-berlin.de>
Cc: dosfstools <daniel@debian.org>, mtools <Alain@linux.lu>,
        linux-kernel@vger.kernel.org
Subject: Re: End of FAT directories
References: <1303498136.8485.128.camel@localhost>
Date: Sat, 23 Apr 2011 05:40:43 +0900
In-Reply-To: <1303498136.8485.128.camel@localhost> (Michael Karcher's message
	of "Fri, 22 Apr 2011 20:48:56 +0200")
Message-ID: <87hb9qnho4.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Karcher <kernel@mkarcher.dialup.fu-berlin.de> writes:

> I'm afraid this is not a pure academic post, but I write it because I
> spent hours on trying to find out why I had problem to make some USB
> flash drive bootable with syslinux (which follows the MS model on
> loading files while booting) after copying files with the linux kernel
> (which follows the Linux model, obviously), additionally dosfsck on that
> stick showed quite strange results (it dived into a directory that does
> no longer exist). Another incarnation is mentioned in
> https://wiki.physik.fu-berlin.de/linux-minidisc/doku.php?id=himddiskformat
> in the section "Filesystem Issues with some Models on Linux". Some of
> the Sony devices clear only the first half of the cluster containing
> that subdirectory to zeroes, which works fine if software aborts on the
> first entry being zero, but obviously makes problem if the second half
> of the cluster is accessed.
>
> I would really appreciate it if all FOSS working on FAT would agree to
> one behaviour, and I think we have no choice except being MS compatible
> (i.e. implement the behaviour as it has always been in DOS and Windows)

It is simply the bug of Sony devices, and can't work on it for both of
Windows and Linux (it have to be fixed by fsck). Yeah, I know Linux can
stop on first zeroed directory entry (I will not complain about it), but
it doesn't fix the problem at all.

Assume 0-3 directory entires fine, 4 is zeroed entry, and 5- is crappy data.

1| ENT1        valid
2| ENT2        valid
3| ENT3        valid
4|             zeroed
5| djafdjoi    crappy data
...

Windows will stop at 4, but if windows write new entry as 4, 5- will
show those up as crap like linux. I.e. never adds new zeroed entry as
end of directory. In short, in spec, directory must be initialized by
zero (it is same assumption on linux and windows).

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

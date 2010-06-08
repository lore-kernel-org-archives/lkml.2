Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752053Ab0FHCFr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 22:05:47 -0400
Received: from 64-131-60-146.usfamily.net ([64.131.60.146]:39415 "EHLO
	mail.sandeen.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897Ab0FHCFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 22:05:46 -0400
Message-ID: <4C0DA578.9010709@sandeen.net>
Date: Mon, 07 Jun 2010 21:05:44 -0500
From: Eric Sandeen <sandeen@sandeen.net>
User-Agent: Thunderbird 2.0.0.24 (Macintosh/20100228)
MIME-Version: 1.0
To: Jeffrey Merkey <jeffmerkey@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Fwd: EXT3 File System Corruption 2.6.34
References: <AANLkTinQatQEYahpkN3bT-S5C41HqRoH--gTrvIbGs_c@mail.gmail.com>	<4C0D5DCD.5010201@sandeen.net>	<AANLkTik1T2nJxsoK9UGIVy6q6pfSxniFfJXJY0InmuUh@mail.gmail.com>	<AANLkTil4FMnGl7llR4N0PkXuNyEClQmTspNK6PT62PAi@mail.gmail.com>	<889B6B31-A1F0-438D-B782-DBB855912854@sandeen.net>	<AANLkTilrmEnLrxRSYNnwr8vFaZi7R9U5vY39NmBWUEMy@mail.gmail.com> <AANLkTil7toVuTbCExPtGMOqzqBVG3hG5JeEqzS6ZZ8T6@mail.gmail.com>
In-Reply-To: <AANLkTil7toVuTbCExPtGMOqzqBVG3hG5JeEqzS6ZZ8T6@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeffrey Merkey wrote:

> OK.  I will set this up.  You may want to make this option the default
> in the build scripts.  here is a corrupted file.  

It was default, but Linus changed it a while back.

> This was a .gif
> image file I saved THEN AFTER SAVING THE FILE I pulled the power to
> the machine and during recovery the file was FUCKED.  

I assume your application did not sync the data, and buffered data
loss is expected on a power loss.

> At any rate,
> this does not happen with 2.6.28.

that I can't explain for sure.... different timing perhaps.

> I dumped the file with xdump a util I use internally for my own use so
> you could see the file contents as text and I could post it here.
> This was an image file but look what ended up in it -- directory
> blocks and such.  Take a look:

As I said, stale blocks exposed due to data=writeback.  Known behavior,
unfortunately the default for ext3.  If you find similar problems
when mounted data=ordered, it's a more interesting report.

-Eric

>           0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F
> 00000000  6C 73 0A 63 64 20 2E 2E 0A 63 6C 73 0A 6C 73 0A  ls.cd ...cls.ls.
> 00000010  63 64 20 6C 69 6E 75 78 2D 32 2E 36 2E 33 34 2D  cd linux-2.6.34-
> 00000020  6D 64 62 2F 0A 63 6C 73 0A 6C 73 0A 63 64 20 2E  mdb/.cls.ls.cd .
> 00000030  2E 0A 63 6C 73 0A 6C 73 0A 63 64 20 6C 69 6E 75  ..cls.ls.cd linu

<giant snip>

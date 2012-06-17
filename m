Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758277Ab2FQVGv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 17:06:51 -0400
Received: from elasmtp-banded.atl.sa.earthlink.net ([209.86.89.70]:43473 "EHLO
	elasmtp-banded.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757928Ab2FQVGt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 17:06:49 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=dk20050327; d=earthlink.net;
  b=P/gQnoTtCv7MHx27SlmvBnaHGl3KxODpoLQ/XfP8pv+cDQiOJJN09cv0W16Tfahf;
  h=Received:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding:X-ELNK-Trace:X-Originating-IP;
Message-ID: <4FDE46E4.7020009@earthlink.net>
Date: Sun, 17 Jun 2012 14:06:44 -0700
From: jdow <jdow@earthlink.net>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Martin Steigerwald <Martin@lichtvoll.de>, linux-kernel@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, linux-m68k@vger.kernel.org
Subject: Re: Partitions: Amiga RDB partition on 2 TB disk way too big, while
 OK in AmigaOS 4.1
References: <201206170841.20222.Martin@lichtvoll.de> <4FDDB667.4020609@earthlink.net> <201206171458.58462.Martin@lichtvoll.de> <CAMuHMdWY7=2nJDUjQFGPhdOAFGYeUsnvgPcaEvB2Gxf7P=E+Ug@mail.gmail.com>
In-Reply-To: <CAMuHMdWY7=2nJDUjQFGPhdOAFGYeUsnvgPcaEvB2Gxf7P=E+Ug@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-ELNK-Trace: bb89ecdb26a8f9f24d2b10475b571120841c09a80b8d9eb6bd61576e7b21260c10da127345fe7d85350badd9bab72f9c350badd9bab72f9c350badd9bab72f9c
X-Originating-IP: 208.127.11.14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012/06/17 09:36, Geert Uytterhoeven wrote:
> On Sun, Jun 17, 2012 at 2:58 PM, Martin Steigerwald <Martin@lichtvoll.de> wrote:
>> Am Sonntag, 17. Juni 2012 schrieb jdow:
>> | JXFS 64 bit file system
>> |
>> | With AmigaOS 4.x a new file system has been introduced called JXFS. It is
>> | a totally new 64 bit file system that supports partitions up to 16 TB in
>> | size. It is a modern journalling file system, which means that it reduces
>> | data loss if data writes to the disk are interrupted. It is the fastest
>> | and most reliable file system ever created for AmigaOS.
>>
>> http://www.amigaos.net/content/1/features
>>
>> Well I asked AmigaOS 4 developers about this issue as well. Lets see what
>> they say about 2 TB limits.
>
> 16 TB = 2 TB * 8. Perhaps they increased the block size from 512 to 4096?
>
> block/partitions/amiga.c reads the block size from
> RigidDiskBlock.rdb_BlockBytes,
> but after conversion to 512-byte blocks, all further calculations are done on
> "int", so it will overflow for disks larger than 2 TiB.
>
> Note that in your profile-binary.img, the field is 0x200, i.e. 512
> bytes per block,
> so I'll have to get a deeper look into your RDB first...
>
> Gr{oetje,eeting}s,
>
>                          Geert

Note that the work I did on the Linux RDB code eons ago took full
cognizance of the physical and virtual block sizes.

I still have, I believe, a working Fuji Magneto Optical drive with 2k
sectors. I used that for ages for moving data from systems at two
different houses as I moved back and forth. I worked on the Linux RDB
code because I wanted to be able to read those disks. I've been vaguely
wondering what happened to the code in the latest builds. Now I guess I
will find out.

If RDBs are going to remain backwards compatible and AmigaOS disk usage
is to remain sensible larger logical blocks, at the very least, are needed.
Since both values (should) exist within the RDBs the partitions that are
described in the RDBs can be managed by reading the logical block size and
multiplying it by the ending block number storing as 64 bits. It sounds
like this is not being done correctly. I may need some guidance to see
about where to put the 64 bit byte position of the starting and ending
blocks.

I've asked Martin for a digital copy of his RDBs and what he thinks the
partition(s) should look like. I should also be told whether the disk
is supposed to be solely Amiga OSs or not. I gather it's not.

(And for God's sake do NOT implement the two virus storage tools within
the RDBs, the RDB encapsulated filesystems and the RDB encapsulated
driver code. I worried about that potential since RDBs were first
introduced. Oddly I never heard of them being used. So I kept quiet
about it. These days those facilities could be extended to use signing
and validation certificates, I suppose.)

{^_^}

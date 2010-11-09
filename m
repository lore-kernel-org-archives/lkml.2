Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755141Ab0KIU4v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 15:56:51 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:43665 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754617Ab0KIU4s convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 15:56:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Sd7VmpVCCWYJzKgQ4Fwr4IHoi0RIPiZSf9t6EOii8eKhy6VQWxZlQeACPjBTv/ZWuC
         HXV1tmjeKuJpkQBehnXMOcdi9TC9H2Taxrg9C6LRrtZQaZ83++NCvEcCRF3sv3aDfscU
         ZlfUgDLAkcykzLjgosBa20qZuee1Ie6sbJh/k=
MIME-Version: 1.0
In-Reply-To: <4CD9B09F.5090707@bluewatersys.com>
References: <4CD518C5.6000509@gmail.com>
	<4CD7076D.80507@bluewatersys.com>
	<AANLkTinJJG0K=BPS0CPzDWcgpRn_yPxZ819N408SwD6d@mail.gmail.com>
	<4CD85489.8000503@bluewatersys.com>
	<AANLkTim8rAQnVYpZdykd2VuL1N9CvkGj88Kf5qpSuJsC@mail.gmail.com>
	<4CD9B09F.5090707@bluewatersys.com>
Date: Tue, 9 Nov 2010 21:56:46 +0100
X-Google-Sender-Auth: -4XTx4YvQWQt8hS1iszjQbxe2_s
Message-ID: <AANLkTiky0LLnipJN3tCwcW6F2LEK-REEd=Ovo0ewMubR@mail.gmail.com>
Subject: Re: [PATCH 08/16 v2] pramfs: headers
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Ryan Mallon <ryan@bluewatersys.com>
Cc: Marco Stornelli <marco.stornelli@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Embedded <linux-embedded@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Tim Bird <tim.bird@am.sony.com>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 9, 2010 at 21:35, Ryan Mallon <ryan@bluewatersys.com> wrote:
> On 11/09/2010 09:19 PM, Marco Stornelli wrote:
>> 2010/11/8 Ryan Mallon <ryan@bluewatersys.com>:
>>> On 11/08/2010 08:49 PM, Marco Stornelli wrote:
>>>> 2010/11/7 Ryan Mallon <ryan@bluewatersys.com>:
>>>>> On 11/06/2010 09:58 PM, Marco Stornelli wrote:
>>>>>> From: Marco Stornelli <marco.stornelli@gmail.com>
>>>>>>
>>>>>> Definitions for the PRAMFS filesystem.
>>>>>>
>>>>>> Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
>>>>>> ---
>>>>>> diff -Nurp linux-2.6.36-orig/fs/pramfs/pram.h linux-2.6.36/fs/pramfs/pram.h
>>>>>> --- linux-2.6.36-orig/fs/pramfs/pram.h        1970-01-01 01:00:00.000000000 +0100
>>>>>> +++ linux-2.6.36/fs/pramfs/pram.h     2010-10-30 12:02:45.000000000 +0200
>>>>>> @@ -0,0 +1,317 @@
>>>>>
>>>>>> +/*
>>>>>> + * Structure of the super block in PRAMFS
>>>>>> + */
>>>>>> +struct pram_super_block {
>>>>>> +     __be16  s_sum;          /* checksum of this sb, including padding */
>>>>>> +     __be64  s_size;         /* total size of fs in bytes */
>>>>>> +     __be32  s_blocksize;    /* blocksize in bytes */
>>>>>> +     __be32  s_inodes_count; /* total inodes count (used or free) */
>>>>>> +     __be32  s_free_inodes_count;/* free inodes count */
>>>>>> +     __be32  s_free_inode_hint;  /* start hint for locating free inodes */
>>>>>> +     __be32  s_blocks_count; /* total data blocks count (used or free) */
>>>>>> +     __be32  s_free_blocks_count;/* free data blocks count */
>>>>>> +     __be32  s_free_blocknr_hint;/* free data blocks count */
>>>>>> +     __be64  s_bitmap_start; /* data block in-use bitmap location */
>>>>>> +     __be32  s_bitmap_blocks;/* size of bitmap in number of blocks */
>>>>>> +     __be32  s_mtime;        /* Mount time */
>>>>>> +     __be32  s_wtime;        /* Write time */
>>>>>> +     __be16  s_magic;        /* Magic signature */
>>>>>> +     char    s_volume_name[16]; /* volume name */
>>>>>> +};
>>>>>
>>>>> Is there a particular reason to use big endian types for the data
>>>>> structures? On a little endian machine you will end up converting values
>>>>> everywhere. I assume that you don't expect the machine to change
>>>>> endianess between reboots :-). If this is for generating/reading
>>>>> filesystems from userspace, wouldn't it be better to have the userspace
>>>>> tools specify the target endianess and do the conversions there?
>>>>>
>>>>> ~Ryan
>>>>
>>>> Yes, there is a reason. In the first review a comment was: the fs must
>>>> have a fix endianess layout. This fs is designed for the embedded
>>>> world mainly. Since most of cpus used in this case are big-endian, it
>>>> means that for typical use case, there is no cost for endianess
>>>> conversion.
>>>
>>> ARM, which is a large portion of the embedded space, is typically little
>>> endian.
>>
>> Not always. Indeed, I didn't say *all* cpu used are big-endian.
>
> My point is that little endian embedded machines make up a large portion
> of the devices that this filesystem will be useful on. On those devices
> it will also have an (unnecessary) conversion overhead.
>
>>> Why does a filesystem need to have a specific endianess layout?
>>> Especially for a highly specialised filesystem like this.
>>
>> I didn't agree with it, but in the first review there was more than
>> one developer that said this thing. The main reason was to read the
>> format (for example with JTAG) or to create an image with a fix
>> format. I remember that someone said that there was a similar problem
>> with jffs2 and the experience tell to us that a fix endianess is
>> important. At that point I decided to use big-endian. You can see all
>> the discussion in lkml. The review has been done at June 2009.
>
> You can still do all of those things without having a fixed endianess.
> You just have to have one extra step of telling the external tools what
> the endianess is. IMHO, it is better to have the overhead of the endian
> conversion in the tools since it is less costly there than an the
> embedded system.
>
> I'm just trying to understand why the fixed endianess rule cannot be
> bent for such a specialised filesystem.

When it was decided that filesystems should be fixed-endian and support for
big-endian ext2 was dropped, the overhead of doing the fixed conversions was
deetermined negligible due to compiler optimization.
That was ages ago, and current embedded systems run circles around the
machines of those days.

Note that this is about metadata only. Actual file contents are always just
byte streams.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds

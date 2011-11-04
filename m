Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751403Ab1KDXQ1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 19:16:27 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:37568 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750975Ab1KDXQ0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 19:16:26 -0400
MIME-Version: 1.0
In-Reply-To: <4EB413FE.8090705@lougher.demon.co.uk>
References: <4EB3F094.30307@lougher.demon.co.uk>
	<CAKYAXd87eNQqDs2Ks5pFkA8dxsb49Ub2UmmWfsQVC8n6F3sfKA@mail.gmail.com>
	<4EB411FB.8050803@lougher.demon.co.uk>
	<4EB413FE.8090705@lougher.demon.co.uk>
Date: Sat, 5 Nov 2011 08:16:24 +0900
Message-ID: <CAKYAXd_g78x9NtM1xPVuiY7JrUcA+Ko_m68epz-CrLYB2y=03g@mail.gmail.com>
Subject: Re: [GIT PULL] Squashfs updates for 3.2
From: NamJae Jeon <linkinjeon@gmail.com>
To: Phillip Lougher <phillip@lougher.demon.co.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/11/5 Phillip Lougher <phillip@lougher.demon.co.uk>:
> Phillip Lougher wrote:
>>
>> NamJae Jeon wrote:
>>
>>>
>>> I already posted this patch before ([PATCH] squashfs : devblksize set
>>> to 4KB intead of BLOCK_SIZE(1KB).).
>>
>> No you didn't.  You posted a patch that simply unconditionally changed
>> the block size from  1K -> 4K.
>>
>> https://lkml.org/lkml/2011/9/18/66
>>
>> This is an unacceptable change, Squashfs is used on many devices not only
>> NAND, and the default value of 1K is optimal for these other devices, and
>> should not be changed.
I suggested this change two time. RFC and a Patch. I didn't reply from
you although you read my post.
you have usually ignored a patch without the reply or the opinion
whenever you get a patch.
and contribute a patch with your name after changing a little more.
>>
>> Second, if you are going to change long-term existing behaviour you should
>> always allow users to "buy-in" to the change, rather than surprising them
>> with new unexpected behaviour.
>>
>>> It is similar with my patch except option.
>>
>> The option *is* the patch.
You may add config option on my patch. I think that 1k-4k is core. if
you think option is core of patch, no more to say.
I also am considering to make config option or mount option  1,4K dev
blk size before. So I am waiting after I send RFC mail to know your
opinion first.

>>
>>> Have you ever seen this patch ? I didn't response about this patch from
>>> you.
>>
>> Since 2008 (and probably before) I have had reports that a 1K block size
>> was
>> causing performance issues on NAND
>>
>> http://old.nabble.com/Default-FS-block-size-td15423970.html
>>
>> However, I chose to do nothing at that time because the results were
>> inconclusive.
>>
>> The impetus for moving to a 1K block on NAND was due to the development
>> of the UBIBLK driver for NAND earlier this year
>>
>> http://lists.infradead.org/pipermail/linux-mtd/2011-June/036595.html
>>
>> where the 1K dev block behaviour of Squashfs was discovered to be the
>> reason (in the early V1 driver referenced above) why Squashfs filesystems
>> worked, but ext2/3 and vfat filesystems did not.
>>
>> Your patch was merely the 3rd or 4th unacceptable patch I have
>> received changing the block size unconditionally.
>>
>> The month before your patch I received this truly horrible patch, which
>> though it is extremely long, does nothing more than change the max dev
>> block size to 4K.  I dropped that patch too.
>>
>
> Missing link
>
> https://lkml.org/lkml/2011/8/15/350
>
> oh and the patch was truly horrible because it was
> broken, they added a new set of I/O access routines
> for the LZO decompressor, but didn't bother with
> any of the others (compile error if you were so
> audacious as to want to use GZIP, or XZ).
>
> Way to go.
>
>> Phillip
>>
>
>

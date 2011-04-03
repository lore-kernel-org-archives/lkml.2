Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753003Ab1DCWiJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Apr 2011 18:38:09 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:45623 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752494Ab1DCWiG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Apr 2011 18:38:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type;
        b=AL9CYhUW0Cb7xo8yA8zNm6jCiLYAypL/8CVoqNd2NZ5fOdUfgbpY1zZbdpam7OLTJF
         PpHT/uIEZi8wgpWoX3esSA9W/E2xySaKDwD5ELdTgNTfZlo8yb5TIzFxk3fevRBkVe09
         UsHqRG6tJKGvqGzCnW1Lt9T3zvR1jM7n3o8u0=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <4D98F66D.9040808@fusionio.com>
References: <AANLkTimhD_cu46Bhtt9v8MjKMVCnVMT6Es+Ys9RNPOp1@mail.gmail.com>
	<20110402112037.ca288d7b.sfr@canb.auug.org.au>
	<BANLkTim_y-=rU8r0_LKEMjPco6TXrEpBvw@mail.gmail.com>
	<BANLkTimfCtqTA5aPYGRMZ1Ndz6eU8HnyJA@mail.gmail.com>
	<4D98F1DA.1060203@fusionio.com>
	<BANLkTin4T0CZPK_Vmk=UEh63+6CXM2f7Mg@mail.gmail.com>
	<4D98F2FF.7090201@fusionio.com>
	<BANLkTinMznekjV+6bG4+=2Y8cZ=jVGfJtQ@mail.gmail.com>
	<4D98F66D.9040808@fusionio.com>
Date: Mon, 4 Apr 2011 00:38:05 +0200
Message-ID: <BANLkTims96d+D_HBw1j6rvUtpMf3xcJLBw@mail.gmail.com>
Subject: Re: linux-next: Tree for April 1 [BROKEN ubifs when CONFIG_DEBUG_SECTION_MISMATCH=y]s
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        "dedekind1@gmail.com" <dedekind1@gmail.com>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 4, 2011 at 12:36 AM, Jens Axboe <jaxboe@fusionio.com> wrote:
> On 2011-04-04 00:33, Sedat Dilek wrote:
>> On Mon, Apr 4, 2011 at 12:21 AM, Jens Axboe <jaxboe@fusionio.com> wrote:
>>> On 2011-04-04 00:19, Sedat Dilek wrote:
>>>> On Mon, Apr 4, 2011 at 12:16 AM, Jens Axboe <jaxboe@fusionio.com> wrote:
>>>>> On 2011-04-02 13:02, Sedat Dilek wrote:
>>>>>> On Sat, Apr 2, 2011 at 12:14 PM, Sedat Dilek <sedat.dilek@googlemail.com> wrote:
>>>>>>> On Sat, Apr 2, 2011 at 2:20 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>>>>>>>> cc'ing Jens ...
>>>>>>>>
>>>>>>>> On Fri, 1 Apr 2011 20:22:41 +0200 Sedat Dilek <sedat.dilek@googlemail.com> wrote:
>>>>>>>>>
>>>>>>>>> On Fri, Apr 1, 2011 at 7:02 PM, Artem Bityutskiy <dedekind1@gmail.com> wrote:
>>>>>>>>>> On Fri, 2011-04-01 at 18:10 +0200, Sedat Dilek wrote:
>>>>>>>>>>> On Fri, Apr 1, 2011 at 6:06 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>>>>>>>>>>>> Cc'ing Artem,
>>>>>>>>>>>>
>>>>>>>>>>>> On Fri, 1 Apr 2011 17:55:52 +0200 Sedat Dilek <sedat.dilek@googlemail.com> wrote:
>>>>>>>>>>>>>
>>>>>>>>>>>>> With CONFIG_DEBUG_SECTION_MISMATCH=y set, I see in my build.log:
>>>>>>>>>>>>> ...
>>>>>>>>>>>>> MODPOST 2742 modules
>>>>>>>>>>>>> ...
>>>>>>>>>>>>> ERROR: "empty_aops" [fs/ubifs/ubifs.ko] undefined!
>>>>>>>>>>>>> make[5]: *** [__modpost] Error 1
>>>>>>>>>>>>> make[4]: *** [modules] Error 2
>>>>>>>>>>>>> make[3]: *** [sub-make] Error 2
>>>>>>>>>>>>> make[2]: *** [all] Error 2
>>>>>>>>>>>>> make[2]: Leaving directory
>>>>>>>>>>>>> `/home/sd/src/linux-2.6/linux-2.6.39-rc1/debian/build/build_i386_none_686-iniza'
>>>>>>>>>>>>>
>>>>>> [...]
>>>>>>> Just FYI:
>>>>>>> I contacted Jens last night and he refreshed his for-linus GIT branch.
>>>>>>> Adding missing include <linux/fs.h> did not fix the issue.
>>>>>>> I am trying with the attached one.
>>>>>>>
>>>>>>> - Sedat -
>>>>>>>
>>>>>>
>>>>>> I have split the single patch into two, first reflects ther build-error.
>>>>>> The second considers {inode,file}_operations have also undefined
>>>>>> functions by using "unified" empty_{iops,fops} as used in other fs/*
>>>>>> files.
>>>>>
>>>>> What are these patches against? Not for-next nor my for-linus.
>>>>>
>>>>
>>>> I tested with linux-next (next-20110401) as base and pulled-in your
>>>> for-linus GIT branch.
>>>
>>> Then perhaps there was some merge error. There's no empty_aops defined
>>> in my tree in nilfs_mapping_init(), for instance.
>>>
>>> Are you using an old for-linus?
>>>
>>
>> I dropped the idea of exporting empty_aops via include/linux/fs.h (&
>> changes in fs/inode.c) as it did not work as intended.
>> As an alternative I used empty_{aops,iops,fops} only in
>> fs/nilfs2/page.c and fs/ubifs/xattr.c where it is only needed (for
>> example for aops: static const struct address_space_operations
>> empty_aops {}; etc.)
>
> I'm asking one thing, you are replying with something else. The patches
> you sent do NOT apply to for-linus.
>

Oh, I am sorry. I checkout your tree and adapt.

- Sedat -

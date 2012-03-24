Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754008Ab2CXGv7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2012 02:51:59 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:50479 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753565Ab2CXGv5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2012 02:51:57 -0400
MIME-Version: 1.0
In-Reply-To: <43D088FE-7FB5-4C9F-A4FF-2B01DB392F43@gmail.com>
References: <1332366608-2695-1-git-send-email-thierry.reding@avionic-design.de>
 <20120321222357.GB24330@quack.suse.cz> <20120321231651.GC32041@thunk.org>
 <20120322055354.GA3942@avionic-0098.mockup.avionic-design.de>
 <1332396053.3058.2.camel@koala> <20120322162825.GA4028@thunk.org>
 <20120322173150.GY6589@ZenIV.linux.org.uk> <43D088FE-7FB5-4C9F-A4FF-2B01DB392F43@gmail.com>
From: Mike Frysinger <vapier@gentoo.org>
Date: Sat, 24 Mar 2012 02:51:35 -0400
X-Google-Sender-Auth: H6ILNIoy6MrpNh2_9h63zhO0fDg
Message-ID: <CAMjpGUcqSSSVy1MSRa_41UkKWc4VOn2yetxLOa=RbE0L7YGHYg@mail.gmail.com>
Subject: Re: [PATCH] ext2: Don't export ext2_mask_flags() to user space
To: Andreas Dilger <aedilger@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, "Ted Ts'o" <tytso@mit.edu>,
        Artem Bityutskiy <dedekind1@gmail.com>,
        ThierryReding <thierry.reding@avionic-design.de>,
        Jan Kara <jack@suse.cz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 22, 2012 at 20:25, Andreas Dilger wrote:
> On 2012-03-22, at 11:31, Al Viro wrote:
>> On Thu, Mar 22, 2012 at 12:28:25PM -0400, Ted Ts'o wrote:
>>> Even if they're not iwlling to use libext2fs (for space reasons, I
>>> would assume?  It can't be because of license compatibility issues
>>> since they are both GPLv2), they could just simply grab the ext2_fs.h
>>> from e2fsprogs.  That has all of the file system definitions for ext2,
>>> ext3, and ext4.
>>
>> Ho-hum...  Then we could kill a lot of lines in include/linux/ext2_fs.h.
>> I wonder how much of what remains has any business being outside of
>> fs/ext2, actually - AFAICS, there are very few places that might possibly
>> care:
>>
>> arch/blackfin/kernel/setup.c:595:       if (*((unsigned short *)(mtd_phys + 0x438)) == EXT2_SUPER_MAGIC)
>> fs/nfsd/nfs3proc.c:599:         case EXT2_SUPER_MAGIC:
>> fs/nfsd/nfs3proc.c:600:                 resp->p_link_max = EXT2_LINK_MAX;
>> fs/nfsd/nfs3proc.c:601:                 resp->p_name_max = EXT2_NAME_LEN;
>
> These don't really make sense to be using ext2 constants.

i'm guessing your quoting is over zealous and you're not actually
talking about the Blackfin code here ... just the nfsd code
-mike

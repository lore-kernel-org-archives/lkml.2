Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757614Ab2IDTCT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 15:02:19 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:35403 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757494Ab2IDTCR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 15:02:17 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Namjae Jeon <linkinjeon@gmail.com>, akpm@linux-foundation.org,
        viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Ravishankar N <ravi.n1@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: Re: [PATCH v2 4/5] fat: eliminate orphaned inode number allocation
References: <1346774312-8142-1-git-send-email-linkinjeon@gmail.com>
	<87mx15910k.fsf@devron.myhome.or.jp>
	<87fw6x90o3.fsf@devron.myhome.or.jp>
	<20120904183815.GA29369@fieldses.org>
Date: Wed, 05 Sep 2012 04:02:13 +0900
In-Reply-To: <20120904183815.GA29369@fieldses.org> (J. Bruce Fields's message
	of "Tue, 4 Sep 2012 14:38:15 -0400")
Message-ID: <87y5kp7gsq.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"J. Bruce Fields" <bfields@fieldses.org> writes:

> On Wed, Sep 05, 2012 at 02:07:40AM +0900, OGAWA Hirofumi wrote:
>> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp> writes:
>> 
>> > Namjae Jeon <linkinjeon@gmail.com> writes:
>> >
>> >> From: Namjae Jeon <namjae.jeon@samsung.com>
>> >>
>> >> Maintain a list of inode(i_pos) numbers of orphaned inodes (i.e the
>> >> inodes that have been unlinked but still having open file
>> >> descriptors).At file/directory creation time, skip using such i_pos
>> >> values.Removal of the i_pos from the list is done during inode eviction.
>> >
>> > What happens if the directory (has busy entries) was completely removed?
>> >
>> >
>> > And Al's point is important for NFS too. If you want stable ino for NFS,
>> > you never can't change it.
>> 
>> s/never can't/never can/
>
> If vfat exports aren't fixable, maybe we should just remove that
> feature?
>
> I'm afraid that having unfixable half-working vfat exports is just an
> attractive nuisance that causes users and developers to waste their
> time....

In historically, it was introduced by Neil Brown, when nfs export
interface was rewritten (I'm not sure what was intended).

Personally, I'm ok to remove it though, it is really personal
opinion. The state would be rather I don't have strong opinion to
remove.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753140Ab2GED7I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 23:59:08 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:41567 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751418Ab2GED7E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 23:59:04 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: "Steve Magnani" <steve@digidescorp.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] fat (exportfs): reconnect file handles to evicted inodes/dentries
References: <1341342576-15394-1-git-send-email-steve@digidescorp.com>
	<1341342576-15394-3-git-send-email-steve@digidescorp.com>
	<87pq8bokcp.fsf@devron.myhome.or.jp>
	<WC20120704180312.82023C@digidescorp.com>
Date: Thu, 05 Jul 2012 12:59:01 +0900
In-Reply-To: <WC20120704180312.82023C@digidescorp.com> (Steve Magnani's
	message of "Wed, 04 Jul 2012 13:03:12 -0500")
Message-ID: <87a9zeeu4a.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Steve Magnani" <steve@digidescorp.com> writes:

>> And can you add explanation the test of this? What were tested?
>
> I set up a memory-limited virtual machine with a 2 GB FAT partition 
> containing a kernel tree (~770 MB, ~40000 files, 9 levels) and did some 
> 'cp -r' and 'ls -lR' operations on it, some overlapping, some not.

Sounds good. It would be useful to add to changelog.

>> Please don't add new lock_super() usage if it is not necessary. Almost
>> all of lock_super() just replaced lock_kernel() usage. It rather should
>> be removed in future.  Probably, this should use inode->i_mutex
>> instead.
>
> I will look into this. My concern was freezing the filesystem while we 
> walk the on-disk structures. Also I developed this patch against 2.6.35 
> (the Bad Old BKL days) and ported it forward to 3.5.

I see.

>> BTW, the above issue is same with all of directory read.
>> 
>> And although this is using i_pos, is there no possibility to be passed
>> the detached inode (i.e. open but unlinked inode, i_pos == 0)?
>
> It is possible, that's why I added code to fall back to using logstart.
>
> I may yet rip out the get_name code. The testing I did before posting the 
> patch seemed to indicate that it was needed - I saw ESTALE errors without 
> get_name support that I did not see with it present. But I've been 
> digging into this some more and I think that was just a coincidence; 
> probably I just generated more extreme memory pressure when testing 
> without get_name. I should know more tomorrow.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

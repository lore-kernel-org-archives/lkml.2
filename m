Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761467Ab2FHPvu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 11:51:50 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:58258 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759518Ab2FHPvs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 11:51:48 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20120608154535.GA887@localhost>
References: <E1Sd0IP-0005nh-AJ@tytso-glaptop.cam.corp.google.com>
	<20120608150736.GF21080@quack.suse.cz>
	<20120608154535.GA887@localhost>
Date: Fri, 8 Jun 2012 17:51:48 +0200
Message-ID: <CA+icZUVC86sBLNND08rNn6xhWqagfWdM7WvrvG+fcW+FHoFjbw@mail.gmail.com>
Subject: Re: writeback: bad unlock balance detected in 3.5-rc1
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Jan Kara <jack@suse.cz>, "Theodore Ts'o" <tytso@mit.edu>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 8, 2012 at 5:45 PM, Fengguang Wu <fengguang.wu@intel.com> wrote:
> On Fri, Jun 08, 2012 at 05:07:36PM +0200, Jan Kara wrote:
>> On Fri 08-06-12 10:36:13, Ted Tso wrote:
>> >
>> > I can reproduce this fairly easily by using ext4 w/o a journal, running
>> > under KVM with 1024megs memory, with fsstress (xfstests #13):
>
> Good catch, thanks!
>
>>   Argh, I wonder how come I didn't hit this. Does attached patch fix the
>> problem?
>
>> diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
>> index 8d2fb8c..41a3ccf 100644
>> --- a/fs/fs-writeback.c
>> +++ b/fs/fs-writeback.c
>> @@ -664,6 +664,7 @@ static long writeback_sb_inodes(struct super_block *sb,
>>                       /* Wait for I_SYNC. This function drops i_lock... */
>>                       inode_sleep_on_writeback(inode);
>>                       /* Inode may be gone, start again */
>> +                     spin_lock(&wb->list_lock);
>>                       continue;
>>               }
>
> That looks like the fix. So I pushed it to writeback-for-next.
> Thanks for the quick fixing!
>

s/writeback-for-next/writeback-for-linus ?

- Sedat -

> I'm yet to setup and run xfstests regularly, so as to catch such kind
> of problems earlier in future.
>
> Thanks,
> Fengguang
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754638Ab1L1V6U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Dec 2011 16:58:20 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:56379 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754553Ab1L1V6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Dec 2011 16:58:16 -0500
Message-ID: <4EFB90F2.9030107@gmail.com>
Date: Wed, 28 Dec 2011 23:58:10 +0200
From: Konstantinos Skarlatos <k.skarlatos@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Dave Chinner <david@fromorbit.com>
CC: linux-kernel@vger.kernel.org, Linux Btrfs <linux-btrfs@vger.kernel.org>,
        Chris Mason <chris.mason@oracle.com>, linux-raid@vger.kernel.org
Subject: Re: Btrfs: blocked for more than 120 seconds, made worse by 3.2 rc7
References: <4EFB6D4F.6070002@gmail.com> <20111228214832.GG12731@dastard>
In-Reply-To: <20111228214832.GG12731@dastard>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Τετάρτη, 28 Δεκέμβριος 2011 11:48:32 μμ, Dave Chinner wrote:
> On Wed, Dec 28, 2011 at 09:26:07PM +0200, Konstantinos Skarlatos wrote:
>> Hello all:
>> I have two machines with btrfs, that give me the "blocked for more
>> than 120 seconds" message. After that I cannot write anything to
>> disk, i am unable to unmount the btrfs filesystem and i can only
>> reboot with sysrq-trigger.
>>
>> It always happens when i write many files with rsync over network.
>> When i used 3.2rc6 it happened randomly on both machines after
>> 50-500gb of writes. with rc7 it happens after much less writes,
>> probably 10gb or so, but only on machine 1 for the time being.
>> machine 2 has not crashed yet after 200gb of writes and I am still
>> testing that.
>>
>> machine 1: btrfs on a 6tb sparse file, mounted as loop, on a xfs
>> filesystem that lies on a 10TB md raid5. mount options
>> compress=zlib,compress-force
>>
>> machine 2: btrfs over md raid 5 (4x2TB)=5.5TB filesystem. mount
>> options compress=zlib,compress-force
>>
>> pastebins:
>>
>> machine1:
>> 3.2rc7 http://pastebin.com/u583G7jK
>> 3.2rc6 http://pastebin.com/L12TDaXa
>
> These two are caused by it taking longer than 120s for XFS to fsync
> the loop file. Writing a signficant chunk of a sparse 6TB file on a
> software RAID5  volume is going to take some time.  However, if IO
> is not occurring, then somewhere below XFS an IO has gone missing
> (MD or hardware problem) because the fsync on the XFS file is
> blocked waiting for an IO completion.
>
>> machine2:
>> 3.2rc6 http://pastebin.com/khD0wGXx
>> 3.2rc7 (not crashed yet)
Crashed a few hours ago, here is the rc7 pastebin
http://pastebin.com/gvfUm0az 
>
> These don't have XFS in the picture, but also appear to be hung
> waiting on IO completion with MD stuck in
> make_request()->get_active_stripe(). That, to me, indicates an MD
> problem.....
>
Added the linux-raid mailing list
Please reply to me too, because i am not subscribed.

> Cheers,
>
> Dave.

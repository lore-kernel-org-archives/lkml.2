Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755555Ab2JIN0g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 09:26:36 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:62862 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753846Ab2JIN0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 09:26:32 -0400
Message-ID: <50742600.10606@gmail.com>
Date: Tue, 09 Oct 2012 09:26:24 -0400
From: Sasha Levin <levinsasha928@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120913 Thunderbird/15.0.1
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Jan Kara <jack@suse.cz>, Tejun Heo <tj@kernel.org>, axboe@kernel.dk,
        Dave Jones <davej@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        ben@decadent.org.uk
Subject: Re: blk: NULL ptr deref in blk_dequeue_request()
References: <505E2108.2060108@gmail.com> <CA+1xoqc1Bc1rPgH+9Xs9-BV7qp3N7mDpNLj1mPwZHdF=H4mHTg@mail.gmail.com> <20121008172207.GB14767@quack.suse.cz> <alpine.LNX.2.00.1210082340501.19980@pobox.suse.cz> <507424F7.60801@gmail.com>
In-Reply-To: <507424F7.60801@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/09/2012 09:21 AM, Sasha Levin wrote:
> On 10/08/2012 05:45 PM, Jiri Kosina wrote:
>> On Mon, 8 Oct 2012, Jan Kara wrote:
>>
>>>>>> I'm still seeing this on linux-next.
>>>>   I think this is floppy related (see redo_fd_request() in the stack
>>>> trace). And there were quite some changes to the area recently. Adding
>>>> maintainer to CC.
>> Hmm ... I don't immediately see how this is happening.
>>
>> Sasha, could you please do git bisect on drivers/block/floppy.c between 
>> f6365201d and your git HEAD for starters (assuming that f6365201d works 
>> well for you?).
>>
> 
> A bisect on floppy.c yielded the following:
> 
> b33d002f4b6bae912463e5a66387c498aa69b6fe is the first bad commit
> commit b33d002f4b6bae912463e5a66387c498aa69b6fe
> Author: Ben Hutchings <ben@decadent.org.uk>
> Date:   Mon Aug 27 20:56:53 2012 -0300
> 
>     genhd: Make put_disk() safe for disks that have not been registered

2 more things:

 1. The guest vm which I'm testing on doesn't emulate anything which even looks like a floppy.
 2. I'm seeing the following lines before the BUG:

[    9.836604] floppy0: no floppy controllers found
[    9.837246] work still pending
[    9.837743] floppy0: floppy_shutdown: timeout handler died.


Thanks,
Sasha

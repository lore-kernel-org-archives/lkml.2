Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754181Ab1KSVx0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Nov 2011 16:53:26 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:41843 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753834Ab1KSVxZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Nov 2011 16:53:25 -0500
MIME-Version: 1.0
In-Reply-To: <4EC81AF1.2080108@linux.vnet.ibm.com>
References: <1321023744-16249-1-git-send-email-linkinjeon@gmail.com>
	<4EC80D6E.3090404@linux.vnet.ibm.com>
	<4EC81AF1.2080108@linux.vnet.ibm.com>
Date: Sun, 20 Nov 2011 06:53:23 +0900
Message-ID: <CAKYAXd8BdKXOPEV0d4hN27Mb5kDbEfYnhcF5+Lxcw2nFkCKFpw@mail.gmail.com>
Subject: Re: [PATCH] ext4: remove unneeded variable.
From: NamJae Jeon <linkinjeon@gmail.com>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: tytso@mit.edu, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
        Amit Sahrawat <amit.sahrawat83@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/11/20 Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>:
> On 11/20/2011 01:41 AM, Srivatsa S. Bhat wrote:
>> On 11/11/2011 08:32 PM, Namjae Jeon wrote:
>>> ret2 is not needed in ext4_flush_completed_IO().
>>>
>>
>> Not needed? I went through the code briefly, and I don't agree.
>>
>>> Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
>>> Signed-off-by: Amit Sahrawat <amit.sahrawat83@gmail.com>
>>> ---
>>>  fs/ext4/fsync.c |    5 +----
>>>  1 files changed, 1 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/fs/ext4/fsync.c b/fs/ext4/fsync.c
>>> index 00a2cb7..40397ac 100644
>>> --- a/fs/ext4/fsync.c
>>> +++ b/fs/ext4/fsync.c
>>> @@ -81,7 +81,6 @@ int ext4_flush_completed_IO(struct inode *inode)
>>>      struct ext4_inode_info *ei = EXT4_I(inode);
>>>      unsigned long flags;
>>>      int ret = 0;
>>> -    int ret2 = 0;
>>>
>>>      dump_completed_IO(inode);
>>>      spin_lock_irqsave(&ei->i_completed_io_lock, flags);
>>> @@ -105,12 +104,10 @@ int ext4_flush_completed_IO(struct inode *inode)
>>>               */
>>>              spin_unlock_irqrestore(&ei->i_completed_io_lock, flags);
>>>              ret = ext4_end_io_nolock(io);
>>> -            if (ret < 0)
>>> -                    ret2 = ret;
>>>              spin_lock_irqsave(&ei->i_completed_io_lock, flags);
>>>      }
>>>      spin_unlock_irqrestore(&ei->i_completed_io_lock, flags);
>>> -    return (ret2 < 0) ? ret2 : 0;
>>> +    return (ret < 0) ? ret : 0;
>>>  }
>>
>> Please note that there is a while loop involved here. Which means, that ret2
>> is used to store the last negative value of ret. And due to the loop, ret can
>> be over-written in the next loop iteration, which we can afford, because we
>> have already stored what we need to save, in ret2. And this ret2 value is used
>> to return appropriate value to the caller.
>>
>
> Actually, what I really meant was, removing ret2 as merely "unneeded" might not
> be the right thing to do because once you apply your patch, you end up altering
> the value returned by this function!
>
> If the return value is indeed wrong in the current code, you should rather
> be saying that this is a bug fix, with appropriate justification IMO.
>
Thanks for your review. My thinking was reaching for to while loop().
I will remember your advice.
Thanks Srivatsa.
> Thanks,
> Srivatsa S. Bhat
>
>

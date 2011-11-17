Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751936Ab1KQFLW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 00:11:22 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:37878 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750955Ab1KQFLV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 00:11:21 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1111161347000.16596@chino.kir.corp.google.com>
References: <1321455848-1929-1-git-send-email-linkinjeon@gmail.com>
	<47270FB7-96AC-4F41-98D3-9AD469080DBE@mit.edu>
	<alpine.DEB.2.00.1111161347000.16596@chino.kir.corp.google.com>
Date: Thu, 17 Nov 2011 10:41:20 +0530
Message-ID: <CADDb1s1pLddZ4TQciL=yO-17WwQDyLmzP1E8U0UsyiQqez8Q8A@mail.gmail.com>
Subject: Re: [PATCH] ext4: slab caches set to SLAB_MEM_SPREAD flags.
From: Amit Sahrawat <amit.sahrawat83@gmail.com>
To: David Rientjes <rientjes@google.com>
Cc: Theodore Tso <tytso@mit.edu>, Namjae Jeon <linkinjeon@gmail.com>,
        linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

To share with you all, this was picked as part of some review process.
We looked for the details regarding the introduction of
SLAB_MEM_SHARED(http://linux.derkeiler.com/Mailing-Lists/Kernel/2006-02/msg01409.html
- provide the slab cache infrastructure to support cpuset memory
spreading), and further the changes were introduced across all
filesystems - http://lwn.net/Articles/173654/.
Since, we do not have direct access to NUMA architecture machine, so
could not think of verifying the changes - but looking at the
respective changes - the changes in this patch does seems relevant
keeping in sync with all changes.
And, Yes David - these changes will make sense in case of CONFIG_SLAB.

Please share your opinion on the above introductions irrespective of
the code changes done in this patch.

Thanks & Regards,
Amit Sahrawat

On Thu, Nov 17, 2011 at 3:22 AM, David Rientjes <rientjes@google.com> wrote:
> On Wed, 16 Nov 2011, Theodore Tso wrote:
>
>> On Nov 16, 2011, at 10:04 AM, Namjae Jeon wrote:
>>
>> > If slab caches set to SLAB_MEM_SPREAD flags, The allocation is spread
>> > evenly over all the memory nodes instead of favoring allocation on the
>> > node local to current cpu.
>>
>> And why do you think this is a good thing?   For mballoc in particular,
>> the data structures are used immediately and then freed immediately ---
>> on the local node, so using a non-local memory just makes things worse
>> in a NUMA system.
>>
>
> I don't think this has the effect that Namjae thinks it does: this is only
> useful for CONFIG_SLAB and when you have cpusets enabled with
> cpuset.memory_spread_slab set.
>
> To test how useful it is, you should enable CONFIG_SLAB and then mount
> cpusets, set cpuset.memory_spread_slab, and create an MPOL_INTERLEAVE
> mempolicy over all online nodes.  This will have the same effect as adding
> SLAB_MEM_SPREAD to these slab caches (it just doesn't require the
> mempolicy) and will be able to quantify the effects without any changes to
> the kernel at all.
>

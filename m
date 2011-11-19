Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754457Ab1KSWQy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Nov 2011 17:16:54 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:54557 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754140Ab1KSWQx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Nov 2011 17:16:53 -0500
MIME-Version: 1.0
In-Reply-To: <710B9EAE-A4C8-4E8F-9AA1-F6CBDC84FD54@mit.edu>
References: <1321455848-1929-1-git-send-email-linkinjeon@gmail.com>
	<47270FB7-96AC-4F41-98D3-9AD469080DBE@mit.edu>
	<alpine.DEB.2.00.1111161347000.16596@chino.kir.corp.google.com>
	<CADDb1s1pLddZ4TQciL=yO-17WwQDyLmzP1E8U0UsyiQqez8Q8A@mail.gmail.com>
	<710B9EAE-A4C8-4E8F-9AA1-F6CBDC84FD54@mit.edu>
Date: Sun, 20 Nov 2011 07:16:51 +0900
Message-ID: <CAKYAXd85nEpYhiA3VFC53TA4jQJfWixDagab4WRWrsSANyLp-Q@mail.gmail.com>
Subject: Re: [PATCH] ext4: slab caches set to SLAB_MEM_SPREAD flags.
From: NamJae Jeon <linkinjeon@gmail.com>
To: Theodore Tso <tytso@mit.edu>
Cc: Amit Sahrawat <amit.sahrawat83@gmail.com>,
        David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org,
        linux-ext4@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/11/20 Theodore Tso <tytso@mit.edu>:
>
> On Nov 17, 2011, at 12:11 AM, Amit Sahrawat wrote:
>> We looked for the details regarding the introduction of
>> SLAB_MEM_SHARED(http://linux.derkeiler.com/Mailing-Lists/Kernel/2006-02/msg01409.html
>> - provide the slab cache infrastructure to support cpuset memory
>> spreading), and further the changes were introduced across all
>> filesystems - http://lwn.net/Articles/173654/.
>
> The main thing I see when I look at this list was it was focused only on the file system's inode structures, or other structures which were long lived and likely to be accessed from many NUMA nodes other than the one where it was originally allocated.
>
> It's unfortunate that this has gotten turned into a much broader generalization that all slab caches should have this flag set.   Perhaps it might be interesting to reflect on the fact that if it was always good to do this, that a flag wouldn't be used to control this behavior, but rather it would be done conditionally?
>
> It's all very good to send  lots of clean up patches, perhaps as a way to learn how to submit kernel patches.   But I would ask people who do this to understand a bit more deeply what is going on.  What's most important for people who are getting started with kernel development is not so much the mechanics of submitting patches, but understanding why things work the way they do.

Actually I checked btrfs before I posted this patch, I was more
confused by temparal slab caches similar with page_io caches of ext4
were not even using the spread flags in btrfs.
I apologize for lacking a point. I will post a patch after
understanding a bit more deeply.

>
> Best regards,
>
> -- Ted
>
>

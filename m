Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752536Ab1KSPkc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Nov 2011 10:40:32 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:36415 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019Ab1KSPkb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Nov 2011 10:40:31 -0500
MIME-Version: 1.0
In-Reply-To: <0912364C-C313-4BCA-9EE2-73F55FE012E6@mit.edu>
References: <1321455848-1929-1-git-send-email-linkinjeon@gmail.com>
	<47270FB7-96AC-4F41-98D3-9AD469080DBE@mit.edu>
	<alpine.DEB.2.00.1111161347000.16596@chino.kir.corp.google.com>
	<CADDb1s1pLddZ4TQciL=yO-17WwQDyLmzP1E8U0UsyiQqez8Q8A@mail.gmail.com>
	<CAKYAXd9wCJFuJZ8uxHESuq92G9EUc0Dq0ejAwbJk0OrwhCcVCA@mail.gmail.com>
	<8343168C-D5F7-43E4-B614-45FBAF5B29A7@mit.edu>
	<A5A56693-9C4C-4957-AAA5-3D1BD8AA7DCE@mit.edu>
	<CAKYAXd99NrOC77=p31nax223UOxOONv3_JcLXUpXign8=58Vxw@mail.gmail.com>
	<0912364C-C313-4BCA-9EE2-73F55FE012E6@mit.edu>
Date: Sun, 20 Nov 2011 00:40:29 +0900
Message-ID: <CAKYAXd91gcPbfAqRRkW7HhxRDXstzGVRbwqzve40z6BTDEj4_w@mail.gmail.com>
Subject: Re: [PATCH] ext4: slab caches set to SLAB_MEM_SPREAD flags.
From: NamJae Jeon <linkinjeon@gmail.com>
To: Theodore Tso <tytso@mit.edu>
Cc: David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org,
        linux-ext4@vger.kernel.org, Amit Sahrawat <amit.sahrawat83@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/11/19 Theodore Tso <tytso@mit.edu>:
>
> On Nov 19, 2011, at 8:52 AM, NamJae Jeon wrote:
>
>> 2011/11/18 Theodore Tso <tytso@mit.edu>:
>>>
>>> On Nov 17, 2011, at 10:11 AM, Theodore Tso wrote:
>>>>
>>>> So accessing non-local memory can be a really, really big deal.  And this
>>>> isn't just theoretical, but have you considered what might happen on a 8
>>>> core AMD machine?
>>>
>>> Sorry, typo.  This should have read, "have you considered what might happen on a 8 _socket_ AMD machine"?
>>>
>> You're right. but..
>> It is only useful using cpuset, And have you read cpuset spread
>> history link of Amit provided ?
>> And why have you still used spread flags for inode cache ?
>
> The inode cache is different for the following reasons:
>
> (1) The memory allocations are long-lived, and there is a good chance for many of them that they will be used by other CPU's on different NUMA nodes.
>
> (2)  There are a very large number of inodes, so uneven allocation of the inodes has a significantly larger impact.
>
> In contrast, the page_io and mballoc allocations are very short lived, there aren't a whole lot of them (check /proc/slabinfo), and they are guaranteed to be used during their very short lifetime on the local CPU node.   So the benefits of spreading them around are not that great, since they aren't that many of them, and downsides of potential 2x or 3x time to access memory is large.
>
Thanks for your opinion.
Have you thought that mem spread flags is not needed in group info
caches same with page_io and mballoc ?

> -- Ted
>
>

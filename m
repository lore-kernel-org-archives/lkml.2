Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751771Ab1KSOmI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Nov 2011 09:42:08 -0500
Received: from DMZ-MAILSEC-SCANNER-3.MIT.EDU ([18.9.25.14]:45487 "EHLO
	dmz-mailsec-scanner-3.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750932Ab1KSOmG convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Nov 2011 09:42:06 -0500
X-AuditID: 1209190e-b7f4a6d0000008e5-fc-4ec7c03cea23
Subject: Re: [PATCH] ext4: slab caches set to SLAB_MEM_SPREAD flags.
Mime-Version: 1.0 (Apple Message framework v1251.1)
Content-Type: text/plain; charset=us-ascii
From: Theodore Tso <tytso@MIT.EDU>
In-Reply-To: <CAKYAXd99NrOC77=p31nax223UOxOONv3_JcLXUpXign8=58Vxw@mail.gmail.com>
Date: Sat, 19 Nov 2011 09:42:00 -0500
Cc: Theodore Tso <tytso@MIT.EDU>, David Rientjes <rientjes@google.com>,
        linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
        Amit Sahrawat <amit.sahrawat83@gmail.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <0912364C-C313-4BCA-9EE2-73F55FE012E6@mit.edu>
References: <1321455848-1929-1-git-send-email-linkinjeon@gmail.com> <47270FB7-96AC-4F41-98D3-9AD469080DBE@mit.edu> <alpine.DEB.2.00.1111161347000.16596@chino.kir.corp.google.com> <CADDb1s1pLddZ4TQciL=yO-17WwQDyLmzP1E8U0UsyiQqez8Q8A@mail.gmail.com> <CAKYAXd9wCJFuJZ8uxHESuq92G9EUc0Dq0ejAwbJk0OrwhCcVCA@mail.gmail.com> <8343168C-D5F7-43E4-B614-45FBAF5B29A7@mit.edu> <A5A56693-9C4C-4957-AAA5-3D1BD8AA7DCE@mit.edu> <CAKYAXd99NrOC77=p31nax223UOxOONv3_JcLXUpXign8=58Vxw@mail.gmail.com>
To: NamJae Jeon <linkinjeon@gmail.com>
X-Mailer: Apple Mail (2.1251.1)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphleLIzCtJLcpLzFFi42IRYrdT0bU5cNzP4M1Wdovm1Q+YLK7fvcVs
	MXPeHTaLy7vmsFm0LdnI5MDqsXPWXXaPBZtKPT5vkgtgjuKySUnNySxLLdK3S+DKODKjjaVg
	AndFy6ezbA2M9zi6GDk5JARMJN53rGSBsMUkLtxbz9bFyMUhJLCPUWLRxB5WCGcDo8TV4xOY
	IJzTTBJnj25mBGkRFnCRePTtNZjNK2AssebWO7BRzAJaEjf+vWQCsdkElCTufNoPFOfg4BQI
	lPi6iBMkzCKgKvF5eQPYNmaBvYwSR3cdZYLo1ZZYtvA1M8RMK4lrM5YzQyy+zyzx4/xudpCE
	iICaxL4tE5kh7paXaPl6h20Co+AsJHfMQnLHLCRzFzAyr2KUTcmt0s1NzMwpTk3WLU5OzMtL
	LdI11svNLNFLTSndxAgKdE5Jvh2MXw8qHWIU4GBU4uEtmHHMT4g1say4MvcQoyQHk5Ior+re
	435CfEn5KZUZicUZ8UWlOanFhxglOJiVRHgvrAPK8aYkVlalFuXDpKQ5WJTEeVfvcPATEkhP
	LEnNTk0tSC2CycpwcChJ8HIAI1pIsCg1PbUiLTOnBCHNxMEJMpwHaPjq/SDDiwsSc4sz0yHy
	pxgVpcR5p4EkBEASGaV5cL2wRPSKURzoFWHe5yBVPMAkBtf9CmgwE9Dg3D1HQAaXJCKkpBoY
	hSK/sOyTWljXMJnV1Uwylnn9H7EKnidSLfZbuErknljEXYzQePV5WsDyylxDNabfT8QNHHdc
	kxPr8vAxjujRP1L58r/w5rtPlzO5rVoQfeRlm5f+kolmUh/9572+YvZ0fmvZ29b+e91tlS88
	c+3XGE9yEQh+xHbBkLOAl3ubq++hYwVfK/iVWIozEg21mIuKEwFdrsxnHwMAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Nov 19, 2011, at 8:52 AM, NamJae Jeon wrote:

> 2011/11/18 Theodore Tso <tytso@mit.edu>:
>> 
>> On Nov 17, 2011, at 10:11 AM, Theodore Tso wrote:
>>> 
>>> So accessing non-local memory can be a really, really big deal.  And this
>>> isn't just theoretical, but have you considered what might happen on a 8
>>> core AMD machine?
>> 
>> Sorry, typo.  This should have read, "have you considered what might happen on a 8 _socket_ AMD machine"?
>> 
> You're right. but..
> It is only useful using cpuset, And have you read cpuset spread
> history link of Amit provided ?
> And why have you still used spread flags for inode cache ?

The inode cache is different for the following reasons:

(1) The memory allocations are long-lived, and there is a good chance for many of them that they will be used by other CPU's on different NUMA nodes.

(2)  There are a very large number of inodes, so uneven allocation of the inodes has a significantly larger impact.

In contrast, the page_io and mballoc allocations are very short lived, there aren't a whole lot of them (check /proc/slabinfo), and they are guaranteed to be used during their very short lifetime on the local CPU node.   So the benefits of spreading them around are not that great, since they aren't that many of them, and downsides of potential 2x or 3x time to access memory is large. 

-- Ted


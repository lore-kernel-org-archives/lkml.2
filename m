Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932199Ab1KQPLI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 10:11:08 -0500
Received: from DMZ-MAILSEC-SCANNER-6.MIT.EDU ([18.7.68.35]:60902 "EHLO
	dmz-mailsec-scanner-6.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757785Ab1KQPLG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 10:11:06 -0500
X-AuditID: 12074423-b7f266d0000008b8-cd-4ec52408c9e9
Subject: Re: [PATCH] ext4: slab caches set to SLAB_MEM_SPREAD flags.
Mime-Version: 1.0 (Apple Message framework v1251.1)
Content-Type: text/plain; charset=us-ascii
From: Theodore Tso <tytso@MIT.EDU>
In-Reply-To: <CAKYAXd9wCJFuJZ8uxHESuq92G9EUc0Dq0ejAwbJk0OrwhCcVCA@mail.gmail.com>
Date: Thu, 17 Nov 2011 10:11:07 -0500
Cc: Theodore Tso <tytso@MIT.EDU>, David Rientjes <rientjes@google.com>,
        linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
        Amit Sahrawat <amit.sahrawat83@gmail.com>
Content-Transfer-Encoding: 7bit
Message-Id: <8343168C-D5F7-43E4-B614-45FBAF5B29A7@mit.edu>
References: <1321455848-1929-1-git-send-email-linkinjeon@gmail.com> <47270FB7-96AC-4F41-98D3-9AD469080DBE@mit.edu> <alpine.DEB.2.00.1111161347000.16596@chino.kir.corp.google.com> <CADDb1s1pLddZ4TQciL=yO-17WwQDyLmzP1E8U0UsyiQqez8Q8A@mail.gmail.com> <CAKYAXd9wCJFuJZ8uxHESuq92G9EUc0Dq0ejAwbJk0OrwhCcVCA@mail.gmail.com>
To: NamJae Jeon <linkinjeon@gmail.com>
X-Mailer: Apple Mail (2.1251.1)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLKsWRmVeSWpSXmKPExsUixCmqrcuhctTPYNp0MYvm1Q+YLK7fvcVs
	MXPeHTaLy7vmsFm0LdnI5MDqsXPWXXaPBZtKPT5vkgtgjuKySUnNySxLLdK3S+DK+DB5BlvB
	Q7aKzvtLmRoYl7J2MXJwSAiYSLxr1uti5AQyxSQu3FvP1sXIxSEksI9R4te9pUwQzgZGiRVz
	7rOCVAkJrGSSmP6fCcQWFnCRePTtNSOIzStgLLHm1jsWEJtZQEvixr+XYDVsAkoSdz7tB4tz
	CgRK9D9oZAaxWQRUJRacO8YIsoBZYC+jxNFdR5kgmuUltr+dwwwx1Epixr4JjBBX7GGS6Dr2
	FmySiICaxL4tE5kh7paXaPl6h20Co+AsJIfMQnLILCRzFzAyr2KUTcmt0s1NzMwpTk3WLU5O
	zMtLLdI108vNLNFLTSndxAgKc3YX5R2Mfw4qHWIU4GBU4uG9yXrET4g1say4MvcQoyQHk5Io
	7x6lo35CfEn5KZUZicUZ8UWlOanFhxglOJiVRHh5nwOV86YkVlalFuXDpKQ5WJTEeWV2OvgJ
	CaQnlqRmp6YWpBbBZGU4OJQkeE2VgYYKFqWmp1akZeaUIKSZODhBhvMADdcBqeEtLkjMLc5M
	h8ifYjTm2DZ9w2lGjkcfNp1mFGLJy89LlRLndQMpFQApzSjNg5sGS1WvGMWBnhPm1QKp4gGm
	Obh5r4BWMQGtyt0D8kdxSSJCSqqBccrVfxsPcsTkvDzPcpjlz6bHkfeTTeS+Vb7nEU+QU1r6
	sv/9rknK9d/MFzRrnJfh8fA86S0vd9JSIEzdlPfbPd/FX7ffDuiLUeuYxjg3Si28SfLaiku7
	vjQfc9spk5WSLNKfvKToZd2B2fMbOvc9nBpjkpWzfd89WzdLjxcdlm+0H84tL1rxXYmlOCPR
	UIu5qDgRAAin6dswAwAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Nov 17, 2011, at 12:35 AM, NamJae Jeon wrote:

> We prevent one node being concentrating workload from redundant
> alloc/free by balancing workload to other nodes in performance side.
> and we can avoid reclaim probability a little by allocation from only
> local node also.

Can you say more about this?   I'm afraid I don't understand what you
are trying to do here.

What I'm worried about is systems where the memory latency time for
local versus remote nodes might be 2-3 to 1.  That is, it takes 2-3 times
as much time to access memory on a remote node.   (On older machines,
the memory access time ratio's could have been as bad as 12:1 or 15:1.)

So accessing non-local memory can be a really, really big deal.  And this
isn't just theoretical, but have you considered what might happen on a 8
core AMD machine?

Regards,

-- Ted


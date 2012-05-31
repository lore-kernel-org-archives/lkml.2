Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752291Ab2EaGa0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 02:30:26 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:47397 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751518Ab2EaGaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 02:30:25 -0400
Message-ID: <4FC70FFE.50809@gmail.com>
Date: Thu, 31 May 2012 02:30:22 -0400
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Cong Wang <amwang@redhat.com>
CC: =?UTF-8?B?UMOhZHJhaWcgQnJhZHk=?= <P@draigBrady.com>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Matthew Wilcox <matthew@wil.cx>, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, kosaki.motohiro@gmail.com
Subject: Re: [RFC Patch] fs: implement per-file drop caches
References: <1338385120-14519-1-git-send-email-amwang@redhat.com>  <4FC6393B.7090105@draigBrady.com> <1338445233.19369.21.camel@cr0>
In-Reply-To: <1338445233.19369.21.camel@cr0>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(5/31/12 2:20 AM), Cong Wang wrote:
> On Wed, 2012-05-30 at 16:14 +0100, Pádraig Brady wrote:
>> On 05/30/2012 02:38 PM, Cong Wang wrote:
>>> This is a draft patch of implementing per-file drop caches.
>>>
>>> It introduces a new fcntl command  F_DROP_CACHES to drop
>>> file caches of a specific file. The reason is that currently
>>> we only have a system-wide drop caches interface, it could
>>> cause system-wide performance down if we drop all page caches
>>> when we actually want to drop the caches of some huge file.
>>
>> This is useful functionality.
>> Though isn't it already provided with POSIX_FADV_DONTNEED?
>
> Thanks for teaching this!
>
> However, from the source code of madvise_dontneed() it looks like it is
> using a totally different way to drop page caches, that is to invalidate
> the page mapping, and trigger a re-mapping of the file pages after a
> page fault. So, yeah, this could probably drop the page caches too (I am
> not so sure, haven't checked the code in details), but with my patch, it
> flushes the page caches directly, what's more, it can also prune
> dcache/icache of the file.

madvise should work. I don't think we need duplicate interface. Moreomover
madvise(2) is cleaner than fcntl(2).


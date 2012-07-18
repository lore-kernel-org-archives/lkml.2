Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753006Ab2GRILS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 04:11:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62516 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751275Ab2GRILJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 04:11:09 -0400
Message-ID: <50067009.9030508@redhat.com>
Date: Wed, 18 Jul 2012 16:12:57 +0800
From: Asias He <asias@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Stefan Hajnoczi <stefanha@gmail.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        linux-aio@kvack.org, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        virtualization@lists.linux-foundation.org,
        Benjamin LaHaise <bcrl@kvack.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 0/5] Add vhost-blk support
References: <1342107302-28116-1-git-send-email-asias@redhat.com> <CAJSP0QWgmXns89se+xdGgM6i1_hsfVWPQ8caHua9d-dDA4CTDQ@mail.gmail.com> <50052276.2080906@redhat.com> <500527BA.9000001@redhat.com> <50052E7E.6020100@redhat.com> <CAJSP0QW0tPV3WASGOBRE4hL=8zzSFQ6T=bHbEwMAzmHR9wnwJg@mail.gmail.com>
In-Reply-To: <CAJSP0QW0tPV3WASGOBRE4hL=8zzSFQ6T=bHbEwMAzmHR9wnwJg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/17/2012 07:11 PM, Stefan Hajnoczi wrote:
> On Tue, Jul 17, 2012 at 10:21 AM, Asias He <asias@redhat.com> wrote:
>> On 07/17/2012 04:52 PM, Paolo Bonzini wrote:
>>>
>>> Il 17/07/2012 10:29, Asias He ha scritto:
>>>>
>>>> So, vhost-blk at least saves ~6 syscalls for us in each request.
>>>
>>>
>>> Are they really 6?  If I/O is coalesced by a factor of 3, for example
>>> (i.e. each exit processes 3 requests), it's really 2 syscalls per request.
>>
>>
>> Well. I am counting the number of syscalls in one notify and response
>> process. Sure the IO can be coalesced.
>
> Linux AIO also supports batching in io_submit() and io_getevents().
> Depending on the request pattern in the vring when you process it, you
> should be able to do better than 1 set of syscalls per host I/O
> request.
>
> Are you taking advantage of that at the moment in your userspace benchmark?

OK. I know that batching in io_submit() and io_getevetns(). There was a 
patch for kvm tool long time ago. Now, both vhost-blk and kvm tool are 
not taking advantage of that atm. There are issues: e.g. How many number 
of request we want to batch? Does this batching hurt latency?

-- 
Asias



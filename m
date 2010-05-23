Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754291Ab0EWQfK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 May 2010 12:35:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35670 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753817Ab0EWQfI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 May 2010 12:35:08 -0400
Date: Sun, 23 May 2010 19:30:39 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
       virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
       qemu-devel@nongnu.org
Subject: Re: [Qemu-devel] [PATCH RFC] virtio: put last seen used index into
	ring itself
Message-ID: <20100523163039.GC14733@redhat.com>
References: <20100505205814.GA7090@redhat.com> <4BF39C12.7090407@redhat.com> <201005201431.51142.rusty@rustcorp.com.au> <201005201438.17010.rusty@rustcorp.com.au> <20100523153134.GA14646@redhat.com> <4BF94CAD.5010504@redhat.com> <20100523155132.GA14733@redhat.com> <4BF951BE.1010402@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BF951BE.1010402@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 23, 2010 at 07:03:10PM +0300, Avi Kivity wrote:
> On 05/23/2010 06:51 PM, Michael S. Tsirkin wrote:
>>>
>>>> So locked version seems to be faster than unlocked,
>>>> and share/unshare not to matter?
>>>>
>>>>        
>>> May be due to the processor using the LOCK operation as a hint to
>>> reserve the cacheline for a bit.
>>>      
>> Maybe we should use atomics on index then?
>>    
>
> This should only be helpful if you access the cacheline several times in  
> a row.  That's not the case in virtio (or here).

So why does it help?

> I think the problem is that LOCKSHARE and SHARE are not symmetric, so  
> they can't be directly compared.

In what sense are they not symmetric?

>> OK, after adding mb in code patch will be sent separately,
>> the test works for my workstation. locked is still fastest,
>> unshared sometimes shows wins and sometimes loses over shared.
>>
>> [root@qus19 ~]# ./cachebounce share 0 1
>> CPU 0: share cacheline: 6638521 usec
>> CPU 1: share cacheline: 6638478 usec
>>    
>
> 66 ns? nice.
>
>> [root@qus19 ~]# ./cachebounce share 0 2
>> CPU 0: share cacheline: 14529198 usec
>> CPU 2: share cacheline: 14529156 usec
>>    
>
> 140 ns, not too bad.  I hope I'm not misinterpreting the results.
>
> -- 
> error compiling committee.c: too many arguments to function

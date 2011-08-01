Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753462Ab1HAJh6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 05:37:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6426 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753282Ab1HAJhw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 05:37:52 -0400
Message-ID: <4E3673E3.6020100@redhat.com>
Date: Mon, 01 Aug 2011 12:37:39 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110621 Fedora/3.1.11-1.fc15 Thunderbird/3.1.11
MIME-Version: 1.0
To: Liu Yuan <namei.unix@gmail.com>
CC: Sasha Levin <levinsasha928@gmail.com>,
        Stefan Hajnoczi <stefanha@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Khoa Huynh <khoa@us.ibm.com>,
        Badari Pulavarty <pbadari@us.ibm.com>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC PATCH]vhost-blk: In-kernel accelerator for virtio block
 device
References: <1311863346-4338-1-git-send-email-namei.unix@gmail.com>	 <CAJSP0QUKz7LFuARF_n2LcBi_uuSzfmkjrWsHAWrXXkEaQJKkEA@mail.gmail.com>	 <4E325F98.5090308@gmail.com>	 <CAJSP0QX=mXvkZyeMx28iwVNDrKEZZVAZxLLOFRv62pu7byo6gw@mail.gmail.com>	 <4E32A105.6080509@gmail.com> <1311953104.30835.15.camel@lappy> <4E36612F.6040809@redhat.com> <4E366F4A.1030704@gmail.com>
In-Reply-To: <4E366F4A.1030704@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01/2011 12:18 PM, Liu Yuan wrote:
>> Agree.  vhost-net works around the lack of async zero copy networking 
>> interface.  Block I/O on the other hand does have such an interface, 
>> and in addition transaction rates are usually lower.  All we're 
>> saving is the syscall overhead.
>>
>
> Personally I too agree with Sasha Levin. But vhost-blk is the first 
> fast prototype that is supposed to act as a code base to do further 
> optimisation, which I plan to utilize  kernel's internal stuff like 
> BIO layer,  that can not be accessed from user space, to maximize the 
> performance for raw disk based block IO.

Is there anything in the bio layer which is not exposed by linux-aio?  
Or is linux-aio slow in translating from vfs ops to bio ops?

-- 
error compiling committee.c: too many arguments to function


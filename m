Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760403Ab0FKNn7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 09:43:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35653 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760334Ab0FKNn5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 09:43:57 -0400
Message-ID: <4C123D94.7060003@redhat.com>
Date: Fri, 11 Jun 2010 08:43:48 -0500
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Thunderbird 2.0.0.24 (Macintosh/20100228)
MIME-Version: 1.0
To: Tao Ma <tao.ma@oracle.com>
CC: linux-ext4@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
       linux-kernel@vger.kernel.org
Subject: Re: fiemap is broken for sparse file in ext4?
References: <4C119C2E.2090801@oracle.com> <4C11B6D8.8070909@redhat.com> <4C11C41C.9070000@oracle.com>
In-Reply-To: <4C11C41C.9070000@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tao Ma wrote:
> Hi Eric,
>     Thanks for the quick response.
> 
> On 06/11/2010 12:08 PM, Eric Sandeen wrote:

...

>> What are you using to call fiemap?  Here it seems to be working:
> I just wrote a simple test program by calling ioctl. It is attached.
> btw, you need to call it immediately after dd so that we have a chance
> that ext4 don't have time to allocate extents. ;)
>>
>> # dd if=/dev/zero of=testfile1 bs=1M count=1 seek=1;
>>
>> # filefrag -v testfile1
>> Filesystem type is: ef53
>> Filesystem cylinder groups is approximately 119
>> File size of testfile1 is 2097152 (512 blocks, blocksize 4096)
>>   ext logical physical expected length flags
>>     0     256   151946               1 merged
>>     1     257   151951   151946      2 merged
>>     2     259   152434   151952    253 merged,eof
>> testfile1: 4 extents found
> I guess maybe filefrag use the diffrent ioctl flag, maybe
> FIEMAP_FLAG_SYNC to let ext4 sync first.

My tester isn't calling sync or using the sync flag, AFAIK.
I'll take a look at yours.

Thanks,
-Eric
 
> Regards,
> Tao
> 


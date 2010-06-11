Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760371Ab0FKXrT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 19:47:19 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:55506 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756495Ab0FKXrR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 19:47:17 -0400
Message-ID: <4C12CAD7.3030008@oracle.com>
Date: Sat, 12 Jun 2010 07:46:31 +0800
From: Tao Ma <tao.ma@oracle.com>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090706)
MIME-Version: 1.0
To: Eric Sandeen <sandeen@redhat.com>
CC: Greg Freemyer <greg.freemyer@gmail.com>, linux-ext4@vger.kernel.org,
       Theodore Tso <tytso@mit.edu>, linux-kernel@vger.kernel.org
Subject: Re: fiemap is broken for sparse file in ext4?
References: <4C119C2E.2090801@oracle.com>	<4C11B6D8.8070909@redhat.com>	<4C11C41C.9070000@oracle.com>	<4C125A6C.2090805@redhat.com> <AANLkTim9xIyL842wapccPIwEPVgd3BY8_r0tBGfGgvOt@mail.gmail.com> <4C126AAB.4040802@redhat.com>
In-Reply-To: <4C126AAB.4040802@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090204.4C12CAF7.0027:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eric,
Eric Sandeen wrote:
> Greg Freemyer wrote:
>   
>> On Fri, Jun 11, 2010 at 11:46 AM, Eric Sandeen <sandeen@redhat.com> wrote:
>>     
>>> Tao Ma wrote:
>>>
>>>       
>>>>> What are you using to call fiemap?  Here it seems to be working:
>>>>>           
>>>> I just wrote a simple test program by calling ioctl. It is attached.
>>>> btw, you need to call it immediately after dd so that we have a chance
>>>> that ext4 don't have time to allocate extents. ;)
>>>>         
>>> OK I take it back, I do see it.  *cough* too many different filesystems
>>> on this box ... ;)
>>>
>>> Yes, it does look like a bug.
>>>
>>> -Eric
>>>       
>> I'm not clear how this is supposed to work.
>>
>> Is this just a userspace bug in that FIEMAP_FLAG_SYNC is needed in the
>> fiemap call, or is there a kernel bug as well?
>>     
>
> The flag is optional, though maybe filefrag should use it.
>
> Without it, we should get the proper logical offset and a delalloc-flagged
> extent returned
>
>   
>> If fiemap is called with the FIEMAP_FLAG_SYNC flag is there currently a problem?
>>     
>
> yep, we should get one delalloc extent in the results and we don't.
>   
With FIEMAP_FLAG_SYNC set, my test shows that we get one extent without 
dealloc flags. So no problem with it.
We have another different test result? ;)

Regards,
Tao


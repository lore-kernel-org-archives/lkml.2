Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753967Ab0DRIMa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Apr 2010 04:12:30 -0400
Received: from omr15.networksolutionsemail.com ([205.178.146.65]:55177 "EHLO
	omr15.networksolutionsemail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752126Ab0DRIM1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Apr 2010 04:12:27 -0400
Authentication-Results: cm-omr5 smtp.user=jon; auth=pass (CRAM-MD5)
Message-ID: <4BCABED6.7050400@nerdgrounds.com>
Date: Sun, 18 Apr 2010 01:12:06 -0700
From: Jonathan Campbell <jon@nerdgrounds.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.7) Gecko/20100111 Thunderbird/3.0.1
MIME-Version: 1.0
To: ratheesh k <ratheesh.ksz@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: open sockets from task_struct
References: <x2hcfeab66d1004180006ob6ebdba5r489f58f4edafc1a@mail.gmail.com>	 <4BCAB35A.6070806@nerdgrounds.com> <s2jcfeab66d1004180056m927c83f6l5642dcf56ad05a5e@mail.gmail.com>
In-Reply-To: <s2jcfeab66d1004180056m927c83f6l5642dcf56ad05a5e@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get the Linux kernel source and look at what the procfs filesystem is 
doing to get that information. Look under fs/proc.
fs/proc/base.c(2508) seems to contain the inode structures for 
/proc/pid/fd and /proc/pid/fdinfo, locate the inode operations
structure and locate the functions. Drill down through the function 
calls and you'll eventually find how to read what
file handles are open. A quick glance tells me that the calls go several 
layers deep including a call through a function pointer passed in one of 
the parameters, "instantiate", hopefully that won't be a problem for you.
> On Sun, Apr 18, 2010 at 12:53 PM, Jonathan Campbell<jon@nerdgrounds.com>  wrote:
>    
>> I know that on the user-space side any open handles can be seen in the
>> /proc/<pid>/fd directory (<pid>  is whatever process you're interested in).
>> Assuming you're talking about reading this from kernel space, I'd look at
>> what the procfs filesystem is doing and learn from that.
>> Sockets and block/char devices are listed like any other file, the list is
>> based on file handles.
>>      
>>> I have task_struct structure , how to find all the opened files ? how
>>> to find opened sockets ?
>>>
>>> Thanks,
>>> Ratheesh
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>> Please read the FAQ at  http://www.tux.org/lkml/
>>>
>>>
>>>
>>>        
>>
>>      
> I need it in kernel space and i am using  2.6.29.4 kernel .. could you
> please guide a little ?
>
>
>    


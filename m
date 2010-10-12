Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756248Ab0JLBQM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 21:16:12 -0400
Received: from nm16-vm0.bullet.mail.sp2.yahoo.com ([98.139.91.210]:31468 "HELO
	nm16-vm0.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755689Ab0JLBQK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 21:16:10 -0400
X-Greylist: delayed 344 seconds by postgrey-1.27 at vger.kernel.org; Mon, 11 Oct 2010 21:16:10 EDT
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 777408.11225.bm@omp1040.mail.sp2.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=ymail.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:References:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type;
  b=GP7IC7f11KDdKiSQRWW5hUuiPVYHOiWuu31pDi973+ysJi4rL8F9sbE/N4hqo0jmcQzzg8uyikqI9i8YQo8mFh26xaR0CgJqfMRAi0ZyBYqRCG/+dGAhVLSWpvZ5+69zC9CT7qiOqJUVukn75cEXbdlQ7gh2Q7/3Eugv+sBypTw=;
Message-ID: <177185.92462.qm@web113411.mail.gq1.yahoo.com>
X-YMail-OSG: 6.AgNqcVM1lh9sXqDAMMteVRzmGLH.2r40Ou6Y3qT7KGLQ2
 33inKUJSYC7AUXowNVkl.G2Ftglq2BG4TM6HthEys3KhtynhMRnjilAZF1Aa
 Jb5iq2SGI2KUJ_ex85TcQMe00Xs177HKkTtCR98Bvn19kaOP6D8Kd2cRpvlk
 YNLYdKRF2OajxJ2YY3z53rnzC7gsaJs.JSNq7VEZt_wjzA.oZ4akzKPmE.jU
 8T.KEJBb64C6iat60WxKz9G1zkhpMkRdE
X-Mailer: YahooMailRC/504.5 YahooMailWebService/0.8.106.282862
References: <633175.66987.qm@web113411.mail.gq1.yahoo.com> <4C9955A5.9080604@gmail.com>
Date: Mon, 11 Oct 2010 18:10:24 -0700 (PDT)
From: Neeraj Kumar <neeraj.kumar01@ymail.com>
Subject: Re: Doing a zero-copy move of data from a kernel buffer to hard disk
To: Robert Hancock <hancockrwd@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <4C9955A5.9080604@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



>On 09/20/2010 02:12 PM, Neeraj Kumar wrote:
>> I am trying to move data from a buffer in kernel space into the hard
>> disk without having to incur any additional copies from kernel buffer to
> >user buffers or any other kernel buffers. Any ideas/suggestions would be
> >most helpful.
>>
>>The use case is basically a demux driver which collects data into a
>> demux buffer in kernel space and this buffer has to be emptied
>>periodically by copying the contents into a FUSE-based partition on the
> disk. As the buffer gets full, a user process is signalled which then
>> determines the sector numbers on the disk the contents need to be copied
>> to.
>>
>> I was hoping to mmap the above demux kernel buffer into user address
>> space and issue a write system call to the raw partition device. But
>> from what I can see, the this data is being cached by the kernel on its
>> way to the Hard Disk driver. And so I am assuming that involves
>> additional copies by the linux kernel.
>>
>> At this point I am wondering if there is any other mechansim to do this
>> without involving additional copies by the kernel. I realize this is an
>> unsual usage scenario for non-embedded environments, but I would
>> appreciate any feedback on possible options.
>>
>> BTW - I have tried using O_DIRECT when opening the raw partition, but
>> the subsequent write call fails if the buffer being passed is the
>> mmapped buffer.

>O_DIRECT would be the right way to do it - I think you'd need to figure 
>out why that write is failing. Keep in mind you need to observe the 
>alignment restrictions of O_DIRECT (man 2 open).


I was able to figure out that O_DIRECT can not work with memory mapped 
pages. In the kernel, get_user_pages() returns error if user provided pages are 
mapped kernel pages.

Thanks
Neeraj



      

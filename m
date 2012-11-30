Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758921Ab2K3RYS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 12:24:18 -0500
Received: from mxout2.netvision.net.il ([194.90.9.21]:34886 "EHLO
	mxout2.netvision.net.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750709Ab2K3RYR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 12:24:17 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; CHARSET=US-ASCII; format=flowed
Message-id: <50B8E5A0.1020406@gmail.com>
Date: Fri, 30 Nov 2012 18:58:08 +0200
From: Eli Billauer <eli.billauer@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12)
 Gecko/20100907 Fedora/3.0.7-1.fc12 Thunderbird/3.0.7
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de
Subject: Re: [PATCH 2/2] New driver: Xillybus generic interface for FPGA
 (programmable logic)
References: <1354117293-13632-1-git-send-email-eli.billauer@gmail.com>
 <1354117293-13632-2-git-send-email-eli.billauer@gmail.com>
 <20121128165719.GB31314@kroah.com> <50B8C7BF.4000004@gmail.com>
 <20121130163254.GB4478@kroah.com>
In-reply-to: <20121130163254.GB4478@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/30/2012 06:32 PM, Greg KH wrote:
>
> As we need to review the user/kernel api here, putting the docs as part
> of the driver submission is a good idea :)
>
> I didn't know, nor do I trust, that a random web site would have the
> correct documentation for a kernel driver.
>    
OK. I'll add a file in Documentation/misc-devices/.
>>>> +#if (PAGE_SIZE<   4096)
>>>> +#error Your processor architecture has a page size smaller than 4096
>>>> +#endif
>>>>          
>>> That can never happen.  Even if it does, you don't care about that in
>>> the driver.
>>>
>>>        
>> I removed this check because it can't happen. But the driver *does*
>> care about this, since it creates a lot of buffers with different
>> alignments, hence depending on the pages' alignment.
>>      
> Alignment is different than the size of a page.  What happens if your
> driver runs on a machine with a page size bigger than 4K?  You need to
> be able to handle that properly, so perhaps you should check that?
>    
The problem is if the page size *smaller* than 4kB. The buffers 
allocated by the driver must not cross a 4kB boundary, and it's assumed 
that anything returned by __get_free_pages() is 4 kB-aligned. Otherwise 
the FPGA will generate illegal PCIe packets by crossing that boundary.

If the page boundary is bigger than 4k, the driver handles that well.

>
> It is no problem to create dozens of misc devices.  It makes your driver
> smaller, contain less code that I have to audit and you have to ensure
> you got right, and it removes another user of 'struct class' which we
> are trying to get rid of anyway.  So please, move to use a misc device.
>    
Very well. I'll remove that.

Thanks again for your comments. I'll prepare a v3.

    Eli


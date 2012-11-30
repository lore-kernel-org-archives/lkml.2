Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030744Ab2K3PaI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 10:30:08 -0500
Received: from mxout2.netvision.net.il ([194.90.9.21]:48840 "EHLO
	mxout2.netvision.net.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030718Ab2K3P3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 10:29:54 -0500
X-Greylist: delayed 1403 seconds by postgrey-1.27 at vger.kernel.org; Fri, 30 Nov 2012 10:29:53 EST
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; CHARSET=US-ASCII; format=flowed
Message-id: <50B8C7BF.4000004@gmail.com>
Date: Fri, 30 Nov 2012 16:50:39 +0200
From: Eli Billauer <eli.billauer@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12)
 Gecko/20100907 Fedora/3.0.7-1.fc12 Thunderbird/3.0.7
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de
Subject: Re: [PATCH 2/2] New driver: Xillybus generic interface for FPGA
 (programmable logic)
References: <1354117293-13632-1-git-send-email-eli.billauer@gmail.com>
 <1354117293-13632-2-git-send-email-eli.billauer@gmail.com>
 <20121128165719.GB31314@kroah.com>
In-reply-to: <20121128165719.GB31314@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the remarks.

I'm sending the updated patches in a minute. Basically, I divided the 
module into three (one core, one for PCIe and one for OF) and made 
several corrections.

On 11/28/2012 06:57 PM, Greg KH wrote:
> What is the user/kernel interface for this driver?  Is it documented
> anywhere?
>    
There's a rather extensive documentation for download at the site. The 
docs for the host side mostly instruct common UNIX programming 
techniques: The device files are just data pipes to FIFOs in the FPGA, 
behaving like one would expect.
>> +#if (PAGE_SIZE<  4096)
>> +#error Your processor architecture has a page size smaller than 4096
>> +#endif
>>      
> That can never happen.  Even if it does, you don't care about that in
> the driver.
>
>    
I removed this check because it can't happen. But the driver *does* care 
about this, since it creates a lot of buffers with different alignments, 
hence depending on the pages' alignment.
>
>> +static struct class *xillybus_class;
>>      
> Why not just use the misc interface instead of your own class?
>    
When Xillybus is used, the whole system's mission is usually around it 
(e.g. it's a computer doing data acquisition through the Xillybus 
pipes). So giving it a high profile makes sense, I believe. Besides, a 
dozen of device files are not rare.

Regards,
     Eli



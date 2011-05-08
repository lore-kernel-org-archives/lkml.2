Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755270Ab1EHTiF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 15:38:05 -0400
Received: from que11.charter.net ([209.225.8.21]:52485 "EHLO que11.charter.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754397Ab1EHTiB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 15:38:01 -0400
X-Greylist: delayed 1230 seconds by postgrey-1.27 at vger.kernel.org; Sun, 08 May 2011 15:38:00 EDT
X-Authority-Analysis: v=1.1 cv=1b2X7W/SifksZeClH/haT1SUt4udqxFGF00pZw2/jJk=
 c=1 sm=1 a=51Irx3Jbk-AA:10 a=DyMOC9dMV3IA:10 a=8nJEP1OIZ-IA:10
 a=xzrYXqw+0zwiO4gHSXHcAg==:17 a=_aY4kHNy_6vUiWjP974A:9 a=wPNLvfGTeEIA:10
 a=xzrYXqw+0zwiO4gHSXHcAg==:117
Message-ID: <4DC6EB3B.8070604@cuw.edu>
Date: Sun, 08 May 2011 14:12:59 -0500
From: Greg Dietsche <gregory.dietsche@cuw.edu>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110307 Icedove/3.0.11
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: gregkh@suse.de, mfuzzey@gmail.com, tom.leiming@gmail.com,
        ak@linux.intel.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: fix warning in usbtest module
References: <Pine.LNX.4.44L0.1105081033140.30441-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1105081033140.30441-100000@netrider.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/08/2011 09:37 AM, Alan Stern wrote:
> On Sat, 7 May 2011, Greg Dietsche wrote:
>
>    
>> On amd64 unsigned is not as wide as pointer and this causes
>> a compiler warning. Switching to uintptr_t fixes the problem
>> in an arch independent manner.
>>      
> People tend to prefer to see non-typedef'ed type names, whenever
> possible.  In this case, it would be enough to change the type to
> unsigned long.
>
> Lots of code throughout the kernel stores pointer values in unsigned
> long variables.  I've never heard any recommendation for using
> uintptr_t instead.
>
>    
I was leaning towards unsigned long at first too, but a several things 
made me reconsider:
1) uintptr_t adapts correctly to the size of a pointer on all 
architectures per C99
2) I greped the kernel source and found a number of instances where 
uintptr_t is used
3) unsigned long is technically too wide (though this is better than too 
small...) for some architectures

If the general consensus is that unsigned long is a better choice for 
the kernel, I will update my patch. I do, however think that uintptr_t 
is the best choice from a technical perspective and prefer it over 
unsigned long.

Thanks,
Greg


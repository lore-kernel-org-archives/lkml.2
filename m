Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753992Ab2LBRqX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2012 12:46:23 -0500
Received: from mxout2.netvision.net.il ([194.90.9.21]:38604 "EHLO
	mxout2.netvision.net.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752844Ab2LBRqW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2012 12:46:22 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; CHARSET=US-ASCII; format=flowed
Message-id: <50BB8F43.4010208@gmail.com>
Date: Sun, 02 Dec 2012 19:26:27 +0200
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
>>>> >  >>+static struct class *xillybus_class;
>>>>          
>>> >  >Why not just use the misc interface instead of your own class?
>>>        
>> >  When Xillybus is used, the whole system's mission is usually around
>> >  it (e.g. it's a computer doing data acquisition through the Xillybus
>> >  pipes). So giving it a high profile makes sense, I believe. Besides,
>> >  a dozen of device files are not rare.
>>      
> It is no problem to create dozens of misc devices.  It makes your driver
> smaller, contain less code that I have to audit and you have to ensure
> you got right, and it removes another user of 'struct class' which we
> are trying to get rid of anyway.  So please, move to use a misc device.
>
>    

It has just occurred to me that DYNAMIC_MINORS is 64 
(drivers/char/misc.c), so I guess that limits the number of misc devices 
that can be generated, at least with dynamically allocated minors. I 
previously mentioned "a dozen" as the number of devices, but I've 
already run tests with 100+ devices, and I can also think of a sane 
application for that.


So if I understood the situation correctly, it looks like using misc 
devices will create a limitation which will be reached sooner or later.

Any suggestion what to do?

Thanks in advance,

     Eli



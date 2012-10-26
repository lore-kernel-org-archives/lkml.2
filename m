Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966250Ab2JZTnl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 15:43:41 -0400
Received: from tru75-7-88-161-131-83.fbx.proxad.net ([88.161.131.83]:47101
	"EHLO next.fork.zz" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S966153Ab2JZTnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 15:43:40 -0400
Message-ID: <508AE7D7.309@free.fr>
Date: Fri, 26 Oct 2012 21:43:19 +0200
From: Wallak <wallak@free.fr>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:16.0) Gecko/20100101 Firefox/16.0
MIME-Version: 1.0
To: Chris Friesen <chris.friesen@genband.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Linix-3.6.3 sda, sdb drives in reverse order (with a USB 2.0
 drives and a monolithic kernel configuration)
References: <5089C20E.4090707@free.fr> <5089C70B.1020007@genband.com>
In-Reply-To: <5089C70B.1020007@genband.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Friesen wrote:
> On 10/25/2012 04:49 PM, Wallak wrote:
>> I've a very annoying behavior with the linux-3.6.x kernels release, and
>> a monolithic configuration. The USB 2.0 drives are mapped first with
>> /dev/sda, /dev/sdb... devices, and than the SATA AHCI drives come after.
>> This is out of order with the BIOS configuration and breaks a program
>> like lilo. This is also annoying when we use a static partition mapping.
>>
>> Linux-3.5 works fine. Where this bug come from ? Is this a patch to get
>> the old, and classical behavior ?
>
> As you have discovered it's fragile to rely on /dev/sd* names since a 
> BIOS update, kernel update, or motherboard replacement could 
> conceivably cause them to change.
>
> Better to use something like partition labels that you control and 
> that don't change.
>
> Chris
>
   You are right, when we have a configuration with a lot of drvies and 
adapters SATA, old SCSI,.. etc. the order may change. But having the 
main SATA hard drive defined, as the BIOS boot device, behind external 
and removable USB drives is in my opinion a bug.And may lead to security 
issues (drives with the same label, etc...).

  Using =LABEL, or =UUID with a bootloader like grub or lilo, save the 
the boot device mapped drive partition number , and so booting on an 
older kernel like linux 3.5 will fail. If we remove the external USB 
drive, the boot process will fail too...

So such a bug have to be fix.


Wallak.


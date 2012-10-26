Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966419Ab2JZUWj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 16:22:39 -0400
Received: from exprod7og109.obsmtp.com ([64.18.2.171]:53285 "EHLO
	exprod7og109.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966367Ab2JZUWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 16:22:37 -0400
Message-ID: <508AF0E4.7030701@genband.com>
Date: Fri, 26 Oct 2012 14:21:56 -0600
From: Chris Friesen <chris.friesen@genband.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.16
MIME-Version: 1.0
To: Wallak <wallak@free.fr>
CC: linux-kernel@vger.kernel.org
Subject: Re: Linix-3.6.3 sda, sdb drives in reverse order (with a USB 2.0
 drives and a monolithic kernel configuration)
References: <5089C20E.4090707@free.fr> <5089C70B.1020007@genband.com> <508AE7D7.309@free.fr>
In-Reply-To: <508AE7D7.309@free.fr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Oct 2012 20:21:57.0488 (UTC) FILETIME=[8C1F9700:01CDB3B7]
X-TM-AS-Product-Ver: SMEX-8.0.0.4160-6.500.1024-19312.001
X-TM-AS-Result: No--18.461000-8.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/26/2012 01:43 PM, Wallak wrote:
> Chris Friesen wrote:
>> On 10/25/2012 04:49 PM, Wallak wrote:
>>> I've a very annoying behavior with the linux-3.6.x kernels release, and
>>> a monolithic configuration. The USB 2.0 drives are mapped first with
>>> /dev/sda, /dev/sdb... devices, and than the SATA AHCI drives come after.
>>> This is out of order with the BIOS configuration and breaks a program
>>> like lilo. This is also annoying when we use a static partition mapping.
>>>
>>> Linux-3.5 works fine. Where this bug come from ? Is this a patch to get
>>> the old, and classical behavior ?
>>
>> As you have discovered it's fragile to rely on /dev/sd* names since a
>> BIOS update, kernel update, or motherboard replacement could
>> conceivably cause them to change.
>>
>> Better to use something like partition labels that you control and
>> that don't change.
>>
>> Chris
>>
> You are right, when we have a configuration with a lot of drvies and
> adapters SATA, old SCSI,.. etc. the order may change. But having the
> main SATA hard drive defined, as the BIOS boot device, behind external
> and removable USB drives is in my opinion a bug.And may lead to security
> issues (drives with the same label, etc...).
>
> Using =LABEL, or =UUID with a bootloader like grub or lilo, save the the
> boot device mapped drive partition number , and so booting on an older
> kernel like linux 3.5 will fail. If we remove the external USB drive,
> the boot process will fail too...
>
> So such a bug have to be fix.

If you specify "root=LABEL=<label>" as part of the kernel boot args in 
grub does it not check the label at boot time?

Chris

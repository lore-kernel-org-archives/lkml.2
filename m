Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756896Ab1DMHNu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 03:13:50 -0400
Received: from ns2.q-leap.de ([88.79.172.217]:55617 "EHLO mail.q-leap.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754607Ab1DMHNt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 03:13:49 -0400
Message-ID: <4DA54D2A.3050206@q-leap.de>
Date: Wed, 13 Apr 2011 09:13:46 +0200
From: Peter Kruse <pk@q-leap.de>
Organization: Q-Leap Networks GmbH
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.15) Gecko/20110303 Lightning/1.0b2 Thunderbird/3.1.9
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Christoph Lameter <cl@linux.com>, eric.dumazet@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: I have a blaze of 353 page allocation failures, all alike
References: <4D53FE43.8030106@q-leap.com>    <alpine.DEB.2.00.1102141046170.26158@router.home>    <4D5A2EDB.8060603@q-leap.com>    <alpine.DEB.2.00.1102151040560.10511@router.home>    <4D5BC16A.2090205@q-leap.com>    <alpine.DEB.2.00.1102160956250.27814@router.home> <4D5BF56F.1000504@q-leap.com>    <alpine.DEB.2.00.1102161010330.27814@router.home>    <4D5CCEED.3010501@q-leap.com>    <alpine.DEB.2.00.1102171102520.11140@router.home> <272bf0cc51439a2ab31ee2f06317dd9f.squirrel@www.q-leap.de> <4D6648B5.1090306@q-leap.com> <4DA4692D.7080207@q-leap.de> <alpine.DEB.2.00.1104121306581.14692@router.home> <alpine.DEB.2.00.1104121830030.14956@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1104121830030.14956@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

thanks for your replies, I appreciate that.

On 04/13/2011 03:34 AM, David Rientjes wrote:
> On Tue, 12 Apr 2011, Christoph Lameter wrote:
>
>> The problem maybe that you have lots and lots of SCSI devices which
>> consume ZONE_DMA memory for their control structures. I guess that is
>> oversubscribing the 16M zone.

but there are only two devices:

# fdisk -l

Disk /dev/sda: 249.8 GB, 249865175040 bytes
255 heads, 63 sectors/track, 30377 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Disk identifier: 0x4ac39024

    Device Boot      Start         End      Blocks   Id  System
/dev/sda1               1          13      104422   83  Linux
/dev/sda2              14       30377   243898830   8e  Linux LVM

WARNING: GPT (GUID Partition Table) detected on '/dev/sdb'! The util fdisk 
doesn't support GPT. Use GNU Parted.


Disk /dev/sdb: 37946.0 GB, 37946025574400 bytes
255 heads, 63 sectors/track, 4613341 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Disk identifier: 0x00000000

Disk /dev/sdb doesn't contain a valid partition table

> You can try to get more memory reserves specifically for lowmem in
> ZONE_DMA by changing /proc/sys/vm/lowmem_reserve_ratio.  The values are
> ratios, so lowering the numbers will yield larger amounts of memory
> reserves in ZONE_DMA for GFP_DMA allocations.  Try lowering the non-zero
> entries to 1 to reserve the entire zone for lowmem, assuming your system
> has enough RAM for everything else you're running.

this server has 48GB - that should be enough.

> This will verify if ZONE_DMA is being depleted from the larger number of
> SCSI devices.  If you don't get any additional page allocation failures,
> then check how much memory in ZONE_DMA is used at peak and that would be a
> sane reserve ratio to use next time you restart the system.

Could that still be a problem if there are only two scsi devices?

Regards,

   Peter

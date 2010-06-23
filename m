Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751766Ab0FWIqX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 04:46:23 -0400
Received: from eu1sys200aog112.obsmtp.com ([207.126.144.133]:36343 "EHLO
	eu1sys200aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751367Ab0FWIqV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 04:46:21 -0400
X-Greylist: delayed 1331 seconds by postgrey-1.27 at vger.kernel.org; Wed, 23 Jun 2010 04:46:21 EDT
Message-ID: <4C21C48A.4030407@stericsson.com>
Date: Wed, 23 Jun 2010 10:23:38 +0200
From: Ulf Hansson <ulf.hansson@stericsson.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: "Andries E. Brouwer" <Andries.Brouwer@cwi.nl>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus WALLEIJ <linus.walleij@stericsson.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] Add commandline partitions for block devices v2
References: <1275997141-25419-1-git-send-email-linus.walleij@stericsson.com> <20100622130915.16ad67cd.akpm@linux-foundation.org> <20100622214812.GB1797@ub>
In-Reply-To: <20100622214812.GB1797@ub>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andries E. Brouwer wrote:
> On Tue, Jun 22, 2010 Andrew Morton wrote:
>   
>> On Tue, 8 Jun 2010 Linus Walleij wrote:
>>
>>     
>>> From: Ulf Hansson <ulf.hansson@stericsson.com>
>>>
>>> This adds an option to pass in block device partitions from the kernel
>>> cmdline.
>>>
>>> The rationale is that in embedded systems we sometimes have no standard
>>> partition table available: often due to the fact that raw binary data is
>>> read out from the first sectors of the device by ROM code in ASICs. We
>>> have for a long time supplied custom partition information to embedded
>>> flash memories through the MTDparts interface which has similar
>>> semantics, and with the advent of embedded MMC block devices this now
>>> comes to standard block devices.
>>>       
>
> There exist ioctls BLKPG_ADD_PARTITION and BLKPG_DEL_PARTITION that
> allow one to add or remove partitions at run time, without having
> a partition table, or without having a partition table in a format
> understood by the kernel. Things can be done in user space.
>
> In general there are many things one would like the kernel to do at
> init time, and it is a bad idea to do all of this from the kernel
> command line. So adding options like these should be done only
> if it would be really awkward to do the same from an initial
> ramdisk.
>
> Andries
>
>   
I see your point!

Although, in an embedded system it is not always convenient to use an 
initial ramdisk. Instead your init program will be found directy from 
your rootfs, which means the kernel must itself be able to setup the 
partitions.

Regards
Uffe


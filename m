Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759473Ab2EIUQQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 16:16:16 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:37732 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753271Ab2EIUQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 16:16:15 -0400
MIME-Version: 1.0
In-Reply-To: <201205091756.16050.arnd@arndb.de>
References: <CAMP44s2eVtquLoB6Zjbs4nGVKP6e=Dxse4uicL4s8vmrFeJdTQ@mail.gmail.com>
	<201205091756.16050.arnd@arndb.de>
Date: Wed, 9 May 2012 22:16:13 +0200
Message-ID: <CAMP44s2eKgTzn9q1CN1X-8P+m0bcTw+UCz7FGQ1ekjzRe8j0SQ@mail.gmail.com>
Subject: Re: Big I/O latencies, except when iotop is hooked
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 9, 2012 at 7:56 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Wednesday 09 May 2012, Felipe Contreras wrote:
>> I've been noticing big I/O latencies when doing operations with
>> notmuch (xapian database), the operations are quite simple and
>> probably should not need a lot of I/O, however, they seen to take a
>> long time, sometimes even seconds. But when I hook iotop (-p pid), the
>> latency goes away, and every operation is reliably instantaneous
>> (basically).
>>
>> Do you have any ideas what might be causing this delay, and why is
>> iotop making it go away?
>>
>> BTW. This is an ext4 encrypted partition on a USB stick, I tried
>> different mount options without any noticeable change. I tried to copy
>> the data to my SSD drive and do the same operations, while it was much
>> faster, it still seemed to have some delays triggered randomly. This
>> is with v3.3.5.
>
> USB sticks like most other cheap flash media tend to have long latencies
> because of the effects I describe on https://lwn.net/Articles/428584/.
>
> I don't know if you have the chance to run flashbench[1] on it (which
> will destroy the data for the partition you are testing), but that
> should at least tell you if it's a problem with the drive.
> You can also use the information from that and combine it with
> a blocktrace log and flashsim[2] to see where the actual latencies
> are expected to happen.
>
> The first thing you should check is whether the partitions are
> properly aligned, using 'fdisk -l -u /dev/sdX'.
>
> Of course none of this will tell you why iotop makes any difference.

And it doesn't tell me why I see the issue on my SSD as well; albeit
with much less delay.

I'll try what you suggest, maybe I will get better performance by
aligning the partitions, but the real issue seems to lie elsewhere,
right?

Cheers.

-- 
Felipe Contreras

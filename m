Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756193Ab1HUXbX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Aug 2011 19:31:23 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:59519 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752190Ab1HUXbV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Aug 2011 19:31:21 -0400
Message-ID: <4E519546.1050406@codemonkey.ws>
Date: Sun, 21 Aug 2011 18:31:18 -0500
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110516 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Sasha Levin <levinsasha928@gmail.com>
CC: Avi Kivity <avi@redhat.com>, linux-kernel@vger.kernel.org,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        Pekka Enberg <penberg@kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] virtio-blk: Add stats VQ to collect information about
 devices
References: <1313524071-27250-1-git-send-email-levinsasha928@gmail.com>	 <4E4C481A.5080205@redhat.com> <1313642283.22532.4.camel@lappy>	 <4E4D2B6D.1040908@redhat.com> <1313684984.30799.20.camel@lappy>
In-Reply-To: <1313684984.30799.20.camel@lappy>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/18/2011 11:29 AM, Sasha Levin wrote:
> On Thu, 2011-08-18 at 08:10 -0700, Avi Kivity wrote:
>> On 08/17/2011 09:38 PM, Sasha Levin wrote:
>>> On Wed, 2011-08-17 at 16:00 -0700, Avi Kivity wrote:
>>>>   On 08/16/2011 12:47 PM, Sasha Levin wrote:
>>>>   >   This patch adds support for an optional stats vq that works similary to the
>>>>   >   stats vq provided by virtio-balloon.
>>>>   >
>>>>   >   The purpose of this change is to allow collection of statistics about working
>>>>   >   virtio-blk devices to easily analyze performance without having to tap into
>>>>   >   the guest.
>>>>   >
>>>>   >
>>>>
>>>>   Why can't you get the same info from the host?  i.e. read sectors?
>>>
>>> Some of the stats you can collect from the host, but some you can't.
>>>
>>> The ones you can't include all the timing statistics and the internal
>>> queue statistics (read/write merges).
>>
>> Surely you can time the actual amount of time the I/O takes?  It doesn't
>> account for the virtio round-trip, but does it matter?
>>
>> Why is the merge count important for the host?
>>
>
> I assumed that the time the request spends in the virtio layer is
> (somewhat) significant, specially since that this is something that adds
> up over time.
>
> Merge count can be useful for several testing scenarios (I'll describe
> the reasoning behind this patch below).
>
>>>
>>> The idea behind providing all of the stats on the stats vq (which is
>>> basically what you see in '/dev/block/[device]/stats') is to give a
>>> consistent snapshot of the state of the device.
>>>
>>>
>>
>> What can you do with it?
>>
>
> I was actually planning on submitting another patch that would add
> something similar into virtio-net. My plan was to enable collecting
> statistics regarding memory, network and disk usage in a simple manner
> without accessing guests.

Why not just add an interface that lets you read files from a guest 
either via a guest agent (like qemu-ga) or a purpose built PV device?

That would let you access the guest's full sysfs which seems to be quite 
a lot more useful long term than adding a bunch of specific interfaces.

Regards,

Anthony Liguori

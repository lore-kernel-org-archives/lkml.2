Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754982Ab1DDRy4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 13:54:56 -0400
Received: from mail.lang.hm ([64.81.33.126]:49594 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754876Ab1DDRyz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 13:54:55 -0400
Date: Mon, 4 Apr 2011 10:54:49 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Charles Samuels <charles@cariden.com>
cc: "Ted Ts'o" <tytso@mit.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Queuing of disk writes
In-Reply-To: <201104041050.12731.charles@cariden.com>
Message-ID: <alpine.DEB.2.00.1104041051560.21230@asgard.lang.hm>
References: <201104011259.53936.charles@cariden.com> <20110404020235.GA4706@thunk.org> <201104041050.12731.charles@cariden.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Apr 2011, Charles Samuels wrote:

> Hi,
>
> Thanks for the reply.
>
> On Sunday, April 03, 2011 7:02:35 pm Ted Ts'o wrote:
>> On Fri, Apr 01, 2011 at 12:59:53PM -0700, Charles Samuels wrote:
>>> I have an application that is writing large amounts of very
>>> fragmented data to harddrives. That is, I could write megabytes of
>>> data in blocks of a few bytes scattered around a multi-gigabyte
>>> file.
>>
>> Doctor, doctor, it hurts when I do this....  any way you can avoid
>> doing this?  What is your application doing at the high level.
> Not really, I need the on-disk data organized in this pattern, so that the
> reads are optimized nicely. It's a database application.
>
>>
>>> Obviously, doing this causes the harddrive to seek a lot and takes a
>>> while.  From what I understand, if I allow linux to cache the
>>> writes, it will fill up the kernel's write cache, and then
>>> consequently the disk drive's DMA queue. As a result of that, the
>>> harddrive can pick the correct order to do these writes,
>>> significantly reducing seek times.
>>
>> This is one way to avoid some of the seeks, yes.
>
> What's another way? Other than not doing it :)
>
>> Who or what is calling fsync()?  Is it being called by your
>> application because you want to initiate writeout?  Or is it being
>> called by some completely unrelated process?
>
> It's being called by my own process. When fsync finishes, I update another file
> with some offset counters, fsync that, and with some luck, my writes are
> transactional.

get yourself a raid controller with a battery-backed cache on it. Then 
your application can consider the data 'safe' once it's written to the 
raid controller (and the fsync will return at that point), the raid 
controller and the disks can then write the data in whatever order they 
want and you won't care.

This is a standard requirement for high performance databases. Without 
this they run into the exact problem you are experiancing.

This battery backed cache can be on the raid card in your machine, or in 
the disk array that you are connecting to.

David Lang

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751994Ab1A0Pkc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 10:40:32 -0500
Received: from lucidpixels.com ([75.144.35.66]:40809 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751374Ab1A0Pkb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 10:40:31 -0500
Date: Thu, 27 Jan 2011 10:40:31 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Mark Lord <kernel@teksavvy.com>
cc: Stan Hoeppner <stan@hardwarefreak.com>,
        Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Alex Elder <aelder@sgi.com>
Subject: Re: xfs: very slow after mount, very slow at umount
In-Reply-To: <4D418B57.1000501@teksavvy.com>
Message-ID: <alpine.DEB.2.00.1101271040000.31246@p34.internal.lan>
References: <4D40C8D1.8090202@teksavvy.com> <20110127033011.GH21311@dastard> <4D40EB2F.2050809@teksavvy.com> <4D418B57.1000501@teksavvy.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 27 Jan 2011, Mark Lord wrote:

> On 11-01-27 12:30 AM, Stan Hoeppner wrote:
>> Mark Lord put forth on 1/26/2011 9:49 PM:
>>
>>> agcount=7453
>>
>> That's probably a bit high Mark, and very possibly the cause of your problems.
>> :)  Unless the disk array backing this filesystem has something like 400-800
>> striped disk drives.  You said it's a single 2TB drive right?
>>
>> The default agcount for a single drive filesystem is 4 allocation groups.  For
>> mdraid (of any number of disks/configuration) it's 16 allocation groups.
>>
>> Why/how did you end up with 7452 allocation groups?  That can definitely cause
>> some performance issues due to massively excessive head seeking, and possibly
>> all manner of weirdness.
>
> This is great info, exactly the kind of feedback I was hoping for!
>
> The filesystem is about a year old now, and I probably used agsize=nnnnn
> when creating it or something.
>
> So if this resulted in what you consider to be many MANY too MANY ags,
> then I can imagine the first new file write wanting to go out and read
> in all of the ag data to determine the "best fit" or something.
> Which might explain some of the delay.
>
> Once I get the new 2TB drive, I'll re-run mkfs.xfs and then copy everything
> over onto a fresh xfs filesystem.
>
> Can you recommend a good set of mkfs.xfs parameters to suit the characteristics
> of this system?  Eg. Only a few thousand active inodes, and nearly all files are
> in the 600MB -> 20GB size range.  The usage pattern it must handle is up to
> six concurrent streaming writes at the same time as up to three streaming reads,
> with no significant delays permitted on the reads.
>
> That's the kind of workload that I find XFS handles nicely,
> and EXT4 has given me trouble with in the past.
>
> Thanks


Hi Mark,

I did a load of benchmarks a long time ago testing every mkfs.xfs option 
there was, and I found that most of the time (if not all), the defaults 
were the best.

Justin.

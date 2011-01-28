Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754594Ab1A1T1W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 14:27:22 -0500
Received: from mail.lang.hm ([64.81.33.126]:41465 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753530Ab1A1T1V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 14:27:21 -0500
Date: Fri, 28 Jan 2011 11:26:00 -0800 (PST)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Dave Chinner <david@fromorbit.com>
cc: Stan Hoeppner <stan@hardwarefreak.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com,
        Christoph Hellwig <hch@infradead.org>,
        Justin Piszcz <jpiszcz@lucidpixels.com>, Alex Elder <aelder@sgi.com>,
        Mark Lord <kernel@teksavvy.com>
Subject: Re: xfs: very slow after mount, very slow at umount
In-Reply-To: <20110128135629.GX21311@dastard>
Message-ID: <alpine.DEB.2.00.1101281119250.17579@asgard.lang.hm>
References: <4D40C8D1.8090202@teksavvy.com> <20110127033011.GH21311@dastard> <4D40EB2F.2050809@teksavvy.com> <4D418B57.1000501@teksavvy.com> <alpine.DEB.2.00.1101271040000.31246@p34.internal.lan> <4D419765.4070805@teksavvy.com> <4D41CA16.8070001@hardwarefreak.com>
 <alpine.DEB.2.00.1101271209370.17579@asgard.lang.hm> <4D42056E.2050505@hardwarefreak.com> <alpine.DEB.2.00.1101271730030.17579@asgard.lang.hm> <20110128135629.GX21311@dastard>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 29 Jan 2011, Dave Chinner wrote:

> On Thu, Jan 27, 2011 at 06:09:58PM -0800, david@lang.hm wrote:
>> On Thu, 27 Jan 2011, Stan Hoeppner wrote:
>>> david@lang.hm put forth on 1/27/2011 2:11 PM:
>>>
>>> Picking the perfect mkfs.xfs parameters for a hardware RAID array can be
>>> somewhat of a black art, mainly because no two vendor arrays act or perform
>>> identically.
>>
>> if mkfs.xfs can figure out how to do the 'right thing' for md raid
>> arrays, can there be a mode where it asks the users for the same
>> information that it gets from the kernel?
>
> mkfs.xfs can get the information it needs directly from dm and md
> devices. However, when hardware RAID luns present themselves to the
> OS in an identical manner to single drives, how does mkfs tell the
> difference between a 2TB hardware RAID lun made up of 30x73GB drives
> and a single 2TB SATA drive? The person running mkfs should already
> know this little detail....

that's my point, the person running mkfs knows this information, and can 
easily answer questions that mkfs asks (or provide this information on the 
command line). but mkfs doesn't ask for this infomation, instead it asks 
the user to define a whole bunch of parameters that are not well 
understood. An XFS guru can tell you how to configure these parameters 
based on different hardware layouts, but as long as it remains a 'back 
art' getting new people up to speed is really hard. If this can be reduced 
down to

is this a hardware raid device
   if yes
     how many drives are there
     what raid type is used (linear, raid 0, 1, 5, 6, 10)

and whatever questions are needed, it would _greatly_ improve the quality 
of the settings that non-guru people end up using.

David  Lang

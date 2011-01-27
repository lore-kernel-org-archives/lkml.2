Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752763Ab1A0UXu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 15:23:50 -0500
Received: from mail.lang.hm ([64.81.33.126]:51225 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751501Ab1A0UXt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 15:23:49 -0500
X-Greylist: delayed 668 seconds by postgrey-1.27 at vger.kernel.org; Thu, 27 Jan 2011 15:23:49 EST
Date: Thu, 27 Jan 2011 12:11:54 -0800 (PST)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Stan Hoeppner <stan@hardwarefreak.com>
cc: Mark Lord <kernel@teksavvy.com>, Justin Piszcz <jpiszcz@lucidpixels.com>,
        Christoph Hellwig <hch@infradead.org>, Alex Elder <aelder@sgi.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com
Subject: Re: xfs: very slow after mount, very slow at umount
In-Reply-To: <4D41CA16.8070001@hardwarefreak.com>
Message-ID: <alpine.DEB.2.00.1101271209370.17579@asgard.lang.hm>
References: <4D40C8D1.8090202@teksavvy.com> <20110127033011.GH21311@dastard> <4D40EB2F.2050809@teksavvy.com> <4D418B57.1000501@teksavvy.com> <alpine.DEB.2.00.1101271040000.31246@p34.internal.lan> <4D419765.4070805@teksavvy.com>
 <4D41CA16.8070001@hardwarefreak.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Jan 2011, Stan Hoeppner wrote:

>> Rather than hundreds or thousands of "tiny" MB sized extents.
>> I wonder what the best mkfs.xfs parameters might be to encourage that?
>
> You need to use the mkfs.xfs defaults for any single drive filesystem, and trust
> the allocator to do the right thing.  XFS uses variable size extents and the
> size is chosen dynamically--you don't have direct or indirect control of the
> extent size chosen for a given file or set of files AFAIK.
>
> As Dave Chinner is fond of pointing out, it's those who don't know enough about
> XFS and choose custom settings that most often get themselves into trouble (as
> you've already done once).  :)
>
> The defaults exist for a reason, and they weren't chosen willy nilly.  The vast
> bulk of XFS' configurability exists for tuning maximum performance on large to
> very large RAID arrays.  There isn't much, if any, additional performance to be
> gained with parameter tweaks on a single drive XFS filesystem.

how do I understand how to setup things on multi-disk systems? the 
documentation I've found online is not that helpful, and in some ways 
contradictory.

If there really are good rules for how to do this, it would be very 
helpful if you could just give mkfs.xfs the information about your system 
(this partition is on a 16 drive raid6 array) and have it do the right 
thing.

David Lang


> A brief explanation of agcount:  the filesystem is divided into agcount regions
> called allocation groups, or AGs.  The allocator writes to all AGs in parallel
> to increase performance.  With extremely fast storage (SSD, large high RPM RAID)
> this increases throughput as the storage can often sink writes faster than a
> serial writer can push data.  In your case, you have a single slow spindle with
> over 7,000 AGs.  Thus, the allocator is writing to over 7,000 locations on that
> single disk simultaneously, or, at least, it's trying to.  Thus, the poor head
> on that drive is being whipped all over the place without actually getting much
> writing done.  To add insults to injury, this is one of these low RPM low head
> performance "green" drives correct?
>
> Trust the defaults.  If they give you problems (unlikely) then we can't talk. ;)
>
>

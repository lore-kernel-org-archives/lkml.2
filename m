Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754675Ab1A1OdF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 09:33:05 -0500
Received: from ironport2-out.teksavvy.com ([206.248.154.183]:45960 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754151Ab1A1OdE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 09:33:04 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApIBAGxiQk1Ld/sX/2dsb2JhbAAMhAjNAZB1gSODOHQEhRg
X-IronPort-AV: E=Sophos;i="4.60,392,1291611600"; 
   d="scan'208";a="89557769"
Message-ID: <4D42D39E.4080304@teksavvy.com>
Date: Fri, 28 Jan 2011 09:33:02 -0500
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-GB; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Dave Chinner <david@fromorbit.com>
CC: Stan Hoeppner <stan@hardwarefreak.com>,
        Justin Piszcz <jpiszcz@lucidpixels.com>,
        Christoph Hellwig <hch@infradead.org>, Alex Elder <aelder@sgi.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com
Subject: Re: xfs: very slow after mount, very slow at umount
References: <4D40C8D1.8090202@teksavvy.com> <20110127033011.GH21311@dastard> <4D40EB2F.2050809@teksavvy.com> <4D418B57.1000501@teksavvy.com> <alpine.DEB.2.00.1101271040000.31246@p34.internal.lan> <4D419765.4070805@teksavvy.com> <4D41CA16.8070001@hardwarefreak.com> <4D41EA04.7010506@teksavvy.com> <20110128001735.GO21311@dastard> <4D421A68.9000607@teksavvy.com> <20110128073119.GV21311@dastard>
In-Reply-To: <20110128073119.GV21311@dastard>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11-01-28 02:31 AM, Dave Chinner wrote:
>
> A simple google search turns up discussions like this:
> 
> http://oss.sgi.com/archives/xfs/2009-01/msg01161.html

"in the long term we still expect fragmentation to degrade the performance of
XFS file systems"
Other than that, no hints there about how changing agcount affects things.


> Configuring XFS filesystems for optimal performance has always been
> a black art because it requires you to understand your storage, your
> application workload(s) and XFS from the ground up.  Most people
> can't even tick one of those boxes, let alone all three....

Well, I've got 2/3 of those down just fine, thanks.
But it's the "XFS" part that is still the "black art" part,
because so little is written about *how* it works
(as opposed to how it is laid out on disk).

Again, that's only a minor complaint -- XFS is way better documented
than the alternatives, and also works way better than the others I've
tried here on this workload.

>>> Why 8 AGs and not the default?
>>
>> How AGs are used is not really explained anywhere I've looked,
>> so I am guessing at what they do and how the system might respond
>> to different values there (that documentation thing again).
> 
> Section 5.1 of this 1996 whitepaper tells you what allocation groups
> are and the general allocation strategy around them:
> 
> http://oss.sgi.com/projects/xfs/papers/xfs_usenix/index.html

Looks a bit dated:  "Allocation groups are typically 0.5 to 4 gigabytes in size."
But it does suggest that "processes running concurrently can allocate space
in the file system concurrently without interfering with each other".

Dunno if that's still true today, but it sounds pretty close to what I was
theorizing about how it might work.

> start to see what I mean about tuning XFS really being a "black art"?

No, I've seen that "black" (aka. undefined, undocumented) part from the start.  :)
Thanks for chipping in here, though -- it's been really useful.

Cheers!

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753522Ab1A0V4Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 16:56:24 -0500
Received: from ironport2-out.teksavvy.com ([206.248.154.183]:28333 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750911Ab1A0V4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 16:56:23 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApIBADd5QU1Ld/sX/2dsb2JhbAAMhAjNC5BigSODOHQEhRc
X-IronPort-AV: E=Sophos;i="4.60,387,1291611600"; 
   d="scan'208";a="89473119"
Message-ID: <4D41EA04.7010506@teksavvy.com>
Date: Thu, 27 Jan 2011 16:56:20 -0500
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-GB; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Stan Hoeppner <stan@hardwarefreak.com>
CC: Justin Piszcz <jpiszcz@lucidpixels.com>,
        Christoph Hellwig <hch@infradead.org>, Alex Elder <aelder@sgi.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com
Subject: Re: xfs: very slow after mount, very slow at umount
References: <4D40C8D1.8090202@teksavvy.com> <20110127033011.GH21311@dastard>	<4D40EB2F.2050809@teksavvy.com> <4D418B57.1000501@teksavvy.com>	<alpine.DEB.2.00.1101271040000.31246@p34.internal.lan> <4D419765.4070805@teksavvy.com> <4D41CA16.8070001@hardwarefreak.com>
In-Reply-To: <4D41CA16.8070001@hardwarefreak.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11-01-27 02:40 PM, Stan Hoeppner wrote:
..
> You need to use the mkfs.xfs defaults for any single drive filesystem, and trust
> the allocator to do the right thing.

But it did not do the right thing when I used the defaults.
Big files ended up with tons of (exactly) 64MB extents, ISTR.

With the increased number of ags, I saw much less fragmentation,
and the drive was still very light on I/O despite multiple simultaneous
recordings, commflaggers, and playback at once.

The only, ONLY, glitch, was this recent "first write takes 45 seconds" glitch.
After that initial write after boot, throughput was normal (great).

Thus the attempts to tweak.

> Trust the defaults.

I imagine the defaults are designed to handle a typical Linux install,
with 100,000 to 1,000,000 files varying from a few bytes to a few megabytes.

That's not what this filesystem will have. It will have only a few thousand
(max) inodes at any given time, but each file will be HUGE.

XFS is fantastic at adapting to the workload, but I'd like to try and have
it tuned more closely for the known workload this system is throwing at it.

I'm now trying again, but with 8 ags instead of 8000+.

Thanks!

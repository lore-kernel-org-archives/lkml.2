Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756606Ab1EBXVk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 19:21:40 -0400
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:61053 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753715Ab1EBXVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 19:21:36 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEALo7v015LBza/2dsb2JhbACmDnjEbw6FcgSVdYc4
Date: Tue, 3 May 2011 09:21:21 +1000
From: Dave Chinner <david@fromorbit.com>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Lukas Czerner <lczerner@redhat.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Dmitry Monakhov <dmonakhov@openvz.org>,
        Jens Axboe <jaxboe@fusionio.com>
Subject: Re: [PATCH 3/3] blkdev: honor discard_granularity in
 blkdev_issue_discard()
Message-ID: <20110502232121.GD2978@dastard>
References: <1304345841-20063-1-git-send-email-lczerner@redhat.com>
 <1304345841-20063-3-git-send-email-lczerner@redhat.com>
 <yq17ha94175.fsf@sermon.lab.mkp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq17ha94175.fsf@sermon.lab.mkp.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 02, 2011 at 10:38:38AM -0400, Martin K. Petersen wrote:
> >>>>> "Lukas" == Lukas Czerner <lczerner@redhat.com> writes:
> 
> Lukas> As Jeff Moyer pointed out we do not honor discard granularity
> Lukas> while submitting REQ_DISCARD bios of size smaller than
> Lukas> max_discard_sectors.  That fact might have unwanted consequences
> Lukas> of device ignoring the request, or even worse if device firmware
> Lukas> is buggy.
> 
> We've discussed this before and the consensus was not to do it. The
> granularity is a hint, not a hard limit like max_discard_sectors.
> 
> We want the reporting to be comprehensive throughout the block layer. If
> we start aligning to the granularity at the top we lose information for
> stacked devices below with a finer granularity.
> 
> So if we were to align to the granularity we'd want to do it at the
> bottom of the stack when we issue the command to the device. We've had a
> few proposed patches to did that but so far we've only found one device
> where it made a difference. And that case didn't justify adding a quirk.

Adding this comment to the code to explain why we don't enforce the
granularity would be a good idea, yes?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

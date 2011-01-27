Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751482Ab1A0PM0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 10:12:26 -0500
Received: from ironport2-out.teksavvy.com ([206.248.154.181]:35675 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750960Ab1A0PMY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 10:12:24 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApIBAA4aQU1Ld/sX/2dsb2JhbAAMhAjMZZBfgSODOHQEhRc
X-IronPort-AV: E=Sophos;i="4.60,386,1291611600"; 
   d="scan'208";a="89417796"
Message-ID: <4D418B57.1000501@teksavvy.com>
Date: Thu, 27 Jan 2011 10:12:23 -0500
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-GB; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Stan Hoeppner <stan@hardwarefreak.com>
CC: Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@infradead.org>,
        Alex Elder <aelder@sgi.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com
Subject: Re: xfs: very slow after mount, very slow at umount
References: <4D40C8D1.8090202@teksavvy.com> <20110127033011.GH21311@dastard> <4D40EB2F.2050809@teksavvy.com>
In-Reply-To: <4D40EB2F.2050809@teksavvy.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11-01-27 12:30 AM, Stan Hoeppner wrote:
> Mark Lord put forth on 1/26/2011 9:49 PM:
> 
>> agcount=7453
> 
> That's probably a bit high Mark, and very possibly the cause of your problems.
> :)  Unless the disk array backing this filesystem has something like 400-800
> striped disk drives.  You said it's a single 2TB drive right?
> 
> The default agcount for a single drive filesystem is 4 allocation groups.  For
> mdraid (of any number of disks/configuration) it's 16 allocation groups.
> 
> Why/how did you end up with 7452 allocation groups?  That can definitely cause
> some performance issues due to massively excessive head seeking, and possibly
> all manner of weirdness.

This is great info, exactly the kind of feedback I was hoping for!

The filesystem is about a year old now, and I probably used agsize=nnnnn
when creating it or something.

So if this resulted in what you consider to be many MANY too MANY ags,
then I can imagine the first new file write wanting to go out and read
in all of the ag data to determine the "best fit" or something.
Which might explain some of the delay.

Once I get the new 2TB drive, I'll re-run mkfs.xfs and then copy everything
over onto a fresh xfs filesystem.

Can you recommend a good set of mkfs.xfs parameters to suit the characteristics
of this system?  Eg. Only a few thousand active inodes, and nearly all files are
in the 600MB -> 20GB size range.  The usage pattern it must handle is up to
six concurrent streaming writes at the same time as up to three streaming reads,
with no significant delays permitted on the reads.

That's the kind of workload that I find XFS handles nicely,
and EXT4 has given me trouble with in the past.

Thanks

-ml

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754025Ab0GZNwE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 09:52:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27837 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751851Ab0GZNwB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 09:52:01 -0400
Date: Mon, 26 Jul 2010 09:51:50 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk, nauman@google.com,
        dpshah@google.com, guijianfeng@cn.fujitsu.com, jmoyer@redhat.com,
        czoccolo@gmail.com
Subject: Re: [RFC PATCH] cfq-iosced: Implement IOPS mode and group_idle
 tunable V3
Message-ID: <20100726135150.GC12449@redhat.com>
References: <1279739181-24482-1-git-send-email-vgoyal@redhat.com>
 <20100722055602.GA18566@infradead.org>
 <20100722140044.GA28684@redhat.com>
 <20100724085135.GB32006@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100724085135.GB32006@infradead.org>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 24, 2010 at 04:51:35AM -0400, Christoph Hellwig wrote:
> To me this sounds like slice_idle=0 is the right default then, as it
> gives useful behaviour for all systems linux runs on.  Setups with
> more than a few spindles are for sure more common than setups making
> use of cgroups.  Especially given that cgroups are more of a high end
> feature you'd rarely use on a single SATA spindle anyway.  So setting
> a paramter to make this useful sounds like the much better option.
> 

Setting slice_idle=0 should give very bad interactivity experience on 
laptops/desktops having SATA disks. My previous tests showed that if
I start a buffered writer on the disk, then launching firefox took more
than 5 minutes.

So slice_idle=0 should not be default. It should be selectively done
on hardware with multiple spindles and where single cfq queue can't
keep all spindles busy.

> Especially given that the block cgroup code doesn't work particularly
> well in presence of barriers, which are on for any kind of real life
> production setup anyway.

True. I was hoping that on a battery backed up storage we shoudl not need
barriers. Last we talked about it, it sounded as if there might be some
bugs in file systems we need to fix before we can confidently say that
yes on battery backed up storage, one can mount file system (ext3, ext4,
xfs) with barrier disabled and still expect data integrity.

Thanks
Vivek

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752028Ab2DPQL3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 12:11:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37222 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751454Ab2DPQL1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 12:11:27 -0400
Date: Mon, 16 Apr 2012 11:52:07 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>, ctalbott@google.com, rni@google.com,
        andrea@betterlinux.com, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, lsf@lists.linux-foundation.org,
        linux-mm@kvack.org, jmoyer@redhat.com, lizefan@huawei.com,
        linux-fsdevel@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [Lsf] [RFC] writeback and cgroup
Message-ID: <20120416155207.GB15437@redhat.com>
References: <20120404145134.GC12676@redhat.com>
 <20120407080027.GA2584@quack.suse.cz>
 <20120410180653.GJ21801@redhat.com>
 <20120410210505.GE4936@quack.suse.cz>
 <20120410212041.GP21801@redhat.com>
 <20120410222425.GF4936@quack.suse.cz>
 <20120411154005.GD16692@redhat.com>
 <1334406314.2528.90.camel@twins>
 <20120416125432.GB12776@redhat.com>
 <20120416130707.GA10532@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120416130707.GA10532@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 16, 2012 at 09:07:07PM +0800, Fengguang Wu wrote:

[..]
> Vivek, I noticed these lines in cfq code
> 
>                 sscanf(dev_name(bdi->dev), "%u:%u", &major, &minor);
> 
> Why not use bdi->dev->devt?  The problem is that dev_name() will
> return "btrfs-X" for btrfs rather than "major:minor".

Isn't bdi->dev->devt 0?  I see following code.

add_disk()
   bdi_register_dev()
      bdi_register()
         device_create_vargs(MKDEV(0,0))
	      dev->devt = devt = MKDEV(0,0);

So for normal block devices, I think bdi->dev->devt will be zero, that's
why probably we don't use it.

Thanks
Vivek

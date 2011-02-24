Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932079Ab1BXQTu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 11:19:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64464 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754775Ab1BXQTt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 11:19:49 -0500
Date: Thu, 24 Feb 2011 11:18:44 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrea Righi <arighi@develer.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Greg Thelen <gthelen@google.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Gui Jianfeng <guijianfeng@cn.fujitsu.com>,
        Ryo Tsuruta <ryov@valinux.co.jp>,
        Hirokazu Takahashi <taka@valinux.co.jp>, Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>,
        containers@lists.linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 0/5] blk-throttle: writeback and swap IO control
Message-ID: <20110224161844.GD18494@redhat.com>
References: <1298394776-9957-1-git-send-email-arighi@develer.com>
 <20110222193403.GG28269@redhat.com>
 <20110222224141.GA23723@linux.develer.com>
 <20110223000358.GM28269@redhat.com>
 <20110223083206.GA2174@linux.develer.com>
 <20110223152354.GA2526@redhat.com>
 <20110223231410.GB1744@linux.develer.com>
 <20110224001033.GF2526@redhat.com>
 <20110224094039.89c07bea.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110224094039.89c07bea.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 24, 2011 at 09:40:39AM +0900, KAMEZAWA Hiroyuki wrote:

[..]
> > > If we don't consider the swap IO, any other IO
> > > operation from our point of view will happen directly from process
> > > context (writes in memory + sync reads from the block device).
> > 
> > Why do we need to account for swap IO? Application never asked for swap
> > IO. It is kernel's decision to move soem pages to swap to free up some
> > memory. What's the point in charging those pages to application group
> > and throttle accordingly?
> > 
> 
> I think swap I/O should be controlled by memcg's dirty_ratio.
> But, IIRC, NEC guy had a requirement for this...
> 
> I think some enterprise cusotmer may want to throttle the whole speed of
> swapout I/O (not swapin)...so, they may be glad if they can limit throttle
> the I/O against a disk partition or all I/O tagged as 'swapio' rather than
> some cgroup name.

If swap is on a separate disk, then one can control put write throttling rules
on systemwide swapout. Though I still don't understand how that can help.

> 
> But I'm afraid slow swapout may consume much dirty_ratio and make things
> worse ;)

Exactly. So I think focus should be controlling things earlier and stop
applications early before they can either write too much data in page
cache etc.

Thanks
Vivek

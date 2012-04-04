Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932511Ab2DDSgN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 14:36:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28520 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932288Ab2DDSgL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 14:36:11 -0400
Date: Wed, 4 Apr 2012 14:35:29 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Tejun Heo <tj@kernel.org>, Jan Kara <jack@suse.cz>,
        Jens Axboe <axboe@kernel.dk>, linux-mm@kvack.org, sjayaraman@suse.com,
        andrea@betterlinux.com, jmoyer@redhat.com,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        kamezawa.hiroyu@jp.fujitsu.com, lizefan@huawei.com,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        ctalbott@google.com, rni@google.com, lsf@lists.linux-foundation.org
Subject: Re: [RFC] writeback and cgroup
Message-ID: <20120404183528.GJ12676@redhat.com>
References: <20120403183655.GA23106@dhcp-172-17-108-109.mtv.corp.google.com>
 <20120404175124.GA8931@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120404175124.GA8931@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 04, 2012 at 10:51:24AM -0700, Fengguang Wu wrote:

[..]
> The sweet split point would be for balance_dirty_pages() to do cgroup
> aware buffered write throttling and leave other IOs to the current
> blkcg. For this to work well as a total solution for end users, I hope
> we can cooperate and figure out ways for the two throttling entities
> to work well with each other.

Throttling read + direct IO, higher up has few issues too. Users will
not like that a task got blocked as it tried to submit a read from a
throttled group. Current async behavior works well where we queue up the
bio from the task in throttled group and let task do other things. Same
is true for AIO where we would not like to block in bio submission.

Thanks
Vivek

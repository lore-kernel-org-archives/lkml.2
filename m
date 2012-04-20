Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755043Ab2DTTaT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 15:30:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4489 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754985Ab2DTTaQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 15:30:16 -0400
Date: Fri, 20 Apr 2012 15:29:30 -0400
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
Message-ID: <20120420192930.GR22419@redhat.com>
References: <20120403183655.GA23106@dhcp-172-17-108-109.mtv.corp.google.com>
 <20120404175124.GA8931@localhost>
 <20120404193355.GD29686@dhcp-172-17-108-109.mtv.corp.google.com>
 <20120406095934.GA10465@localhost>
 <20120417223854.GG19975@google.com>
 <20120419142343.GA12684@localhost>
 <20120419183118.GM10216@redhat.com>
 <20120420124518.GA7133@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120420124518.GA7133@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 20, 2012 at 08:45:18PM +0800, Fengguang Wu wrote:

[..]
> If still keep the global async queue, it can run small 40ms slices
> without defeating the flusher's 500ms granularity. After each slice
> it can freely switch to other cgroups with sync IOs, so is free from
> latency issues. After return, it will continue to serve the same
> inode. It will basically be working on behalf of one cgroup for 500ms
> data, working for another cgroup for 500ms data and so on. That
> behavior does not impact fairness, because it's still using small
> slices and its weight is computed system wide thus exhibits some kind
> of smooth/amortize effects over long period of time. It can naturally 
> serve the same inode after return.

Ok, So tejun did say that we will have a switch where we will allow
retaining the old behavior of keeping all async writes in root group
and not in individual group. So throughput sensitive users can make
use of that and there is no need to push proportional IO logic to
writeback layer for buffered writes?

I am personally is not too excited about the case of putting async IO
in separate groups due to the reason that async IO of one group will
start impacting latencies of sync IO of another group and in practice
it might not be desirable. But there are others who have use cases for
separate async IO queue. So as long as switch is there to change the
behavior, I am not too worried.

Thanks
Vivek

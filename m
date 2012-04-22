Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752205Ab2DVOcT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2012 10:32:19 -0400
Received: from mga11.intel.com ([192.55.52.93]:44494 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751504Ab2DVOcQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2012 10:32:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="144581809"
Date: Sun, 22 Apr 2012 22:26:48 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Tejun Heo <tj@kernel.org>
Cc: Vivek Goyal <vgoyal@redhat.com>, Jan Kara <jack@suse.cz>,
        Jens Axboe <axboe@kernel.dk>, linux-mm@kvack.org, sjayaraman@suse.com,
        andrea@betterlinux.com, jmoyer@redhat.com,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        kamezawa.hiroyu@jp.fujitsu.com, lizefan@huawei.com,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        ctalbott@google.com, rni@google.com, lsf@lists.linux-foundation.org
Subject: Re: [RFC] writeback and cgroup
Message-ID: <20120422142648.GA9530@localhost>
References: <20120403183655.GA23106@dhcp-172-17-108-109.mtv.corp.google.com>
 <20120404175124.GA8931@localhost>
 <20120404193355.GD29686@dhcp-172-17-108-109.mtv.corp.google.com>
 <20120406095934.GA10465@localhost>
 <20120417223854.GG19975@google.com>
 <20120419142343.GA12684@localhost>
 <20120419183118.GM10216@redhat.com>
 <20120420124518.GA7133@localhost>
 <20120420192930.GR22419@redhat.com>
 <20120420213301.GA29134@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120420213301.GA29134@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 20, 2012 at 02:33:01PM -0700, Tejun Heo wrote:
> On Fri, Apr 20, 2012 at 03:29:30PM -0400, Vivek Goyal wrote:
> > I am personally is not too excited about the case of putting async IO
> > in separate groups due to the reason that async IO of one group will
> > start impacting latencies of sync IO of another group and in practice
> > it might not be desirable. But there are others who have use cases for
> > separate async IO queue. So as long as switch is there to change the
> > behavior, I am not too worried.
> 
> Why not just fix cfq so that it prefers groups w/ sync IOs?

There may be a sync+async group in front, but when switch into it, it
decides to give its async queue a run. That's not necessarily a bad
decision, but we do lose some control here.

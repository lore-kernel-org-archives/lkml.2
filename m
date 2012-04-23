Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753489Ab2DWQFF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 12:05:05 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45401 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753186Ab2DWQFB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 12:05:01 -0400
Date: Mon, 23 Apr 2012 09:04:54 -0700
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Jens Axboe <axboe@kernel.dk>, linux-mm@kvack.org, sjayaraman@suse.com,
        andrea@betterlinux.com, jmoyer@redhat.com,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        kamezawa.hiroyu@jp.fujitsu.com, lizefan@huawei.com,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        ctalbott@google.com, rni@google.com, lsf@lists.linux-foundation.org
Subject: Re: [RFC] writeback and cgroup
Message-ID: <20120423160454.GA5406@google.com>
References: <20120404175124.GA8931@localhost>
 <20120404193355.GD29686@dhcp-172-17-108-109.mtv.corp.google.com>
 <20120406095934.GA10465@localhost>
 <20120417223854.GG19975@google.com>
 <20120419142343.GA12684@localhost>
 <20120419183118.GM10216@redhat.com>
 <20120420124518.GA7133@localhost>
 <20120420192930.GR22419@redhat.com>
 <20120420213301.GA29134@google.com>
 <20120423123011.GA8103@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120423123011.GA8103@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Vivek.

On Mon, Apr 23, 2012 at 08:30:11AM -0400, Vivek Goyal wrote:
> On Fri, Apr 20, 2012 at 02:33:01PM -0700, Tejun Heo wrote:
> > On Fri, Apr 20, 2012 at 03:29:30PM -0400, Vivek Goyal wrote:
> > > I am personally is not too excited about the case of putting async IO
> > > in separate groups due to the reason that async IO of one group will
> > > start impacting latencies of sync IO of another group and in practice
> > > it might not be desirable. But there are others who have use cases for
> > > separate async IO queue. So as long as switch is there to change the
> > > behavior, I am not too worried.
> > 
> > Why not just fix cfq so that it prefers groups w/ sync IOs?
> 
> Yes that could possibly be done but now that's change of requirements. Now
> we are saying that I want one buffered write to go faster than other
> buffered write only if there is no sync IO present in any of the groups.

It's a scheduling decision and the resource split may or may not be
about latency (the faster part).  We're currently just shoving all
asyncs into the root group and preferring sync IOs in general.  The
other end would be keeping them completely siloed and not caring about
[a]sync across different cgroups.  My point is that managing async IOs
per cgroup doesn't mean we can't prioritize sync IOs in general.

Thanks.

-- 
tejun

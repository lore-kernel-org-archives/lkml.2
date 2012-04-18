Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754311Ab2DRSTs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 14:19:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52193 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754027Ab2DRSTq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 14:19:46 -0400
Date: Wed, 18 Apr 2012 14:18:36 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Jan Kara <jack@suse.cz>, Fengguang Wu <fengguang.wu@intel.com>,
        Jens Axboe <axboe@kernel.dk>, linux-mm@kvack.org, sjayaraman@suse.com,
        andrea@betterlinux.com, jmoyer@redhat.com,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        kamezawa.hiroyu@jp.fujitsu.com, lizefan@huawei.com,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        ctalbott@google.com, rni@google.com, lsf@lists.linux-foundation.org
Subject: Re: [RFC] writeback and cgroup
Message-ID: <20120418181836.GD2224@redhat.com>
References: <20120404145134.GC12676@redhat.com>
 <20120407080027.GA2584@quack.suse.cz>
 <20120410180653.GJ21801@redhat.com>
 <20120410210505.GE4936@quack.suse.cz>
 <20120410212041.GP21801@redhat.com>
 <20120410222425.GF4936@quack.suse.cz>
 <20120411154005.GD16692@redhat.com>
 <20120411154531.GE16692@redhat.com>
 <20120411170542.GB16008@quack.suse.cz>
 <20120417214831.GE19975@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120417214831.GE19975@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 17, 2012 at 02:48:31PM -0700, Tejun Heo wrote:
[..]

> As for priority inversion through shared request pool, it is a problem
> which needs to be solved regardless of how async IOs are throttled.
> I'm not determined to which extent yet tho.  Different cgroups
> definitely need to be on separate pools but do we also want
> distinguish sync and async and what about ioprio?  Maybe we need a
> bybrid approach with larger common pool and reserved ones for each
> class?

currently we have global pool with separate limits for sync and async
and there is no consideration of ioprio. I think to keep it simple we
can just extend the same notion to keep per cgroup pool with internal
limits on sync/async requests to make sure sync IO does not get
serialized behind async IO. Personally I am not too worried about
async IO prio. It has never worked.

Thanks
Vivek

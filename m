Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755299Ab2CHSLe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 13:11:34 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:59997 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753573Ab2CHSLc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 13:11:32 -0500
Date: Thu, 8 Mar 2012 10:11:25 -0800
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, axboe@kernel.dk,
        hughd@google.com, avi@redhat.com, nate@cpanel.net,
        cl@linux-foundation.org, linux-kernel@vger.kernel.org,
        dpshah@google.com, ctalbott@google.com, rni@google.com
Subject: Re: [PATCHSET] mempool, percpu, blkcg: fix percpu stat allocation
 and remove stats_lock
Message-ID: <20120308181125.GB25508@google.com>
References: <20120229173639.GB5930@redhat.com>
 <20120305221321.GF1263@google.com>
 <20120306210954.GF32148@redhat.com>
 <20120306132034.ecaf8b20.akpm@linux-foundation.org>
 <20120306213437.GG32148@redhat.com>
 <20120306135531.828ca78e.akpm@linux-foundation.org>
 <20120307145556.GA11262@redhat.com>
 <20120307150549.955d6f9c.akpm@linux-foundation.org>
 <20120308175708.GB22922@redhat.com>
 <20120308180833.GA25508@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120308180833.GA25508@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 08, 2012 at 10:08:33AM -0800, Tejun Heo wrote:
> It's probably from something forgetting to put cgroup and pre_destroy
> waiting for it.  Such bugs would have been masked before but now show
> up as stalls during rmdir.  I'm not too happy with how cgroup is
> handling cgroup file additions and removals and hoping to implement
> proper 'sever' semantics similar to that of sysfs.  In the longer
> term, such behavior should go away but for now we'll just have to hunt
> down the actual bug to avoid stalls (which we have to do anyway but
> it's more visible now).

Hmm... I'll probably need it for dynamic file additions and removals
for dynamic policy updates && the blkcg changes are scheduled for
3.5-rc1 window (not 3.4-rc1), so we should have enough time to resolve
this.

Thanks.

-- 
tejun

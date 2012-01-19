Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932558Ab2ASQZw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 11:25:52 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:64686 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932325Ab2ASQZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 11:25:50 -0500
Date: Thu, 19 Jan 2012 08:25:44 -0800
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: axboe@kernel.dk, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/12] blkcg: use q and plid instead of opaque void *
 for blkio_group association
Message-ID: <20120119162544.GG5198@google.com>
References: <1326935490-11827-1-git-send-email-tj@kernel.org>
 <1326935490-11827-7-git-send-email-tj@kernel.org>
 <20120119140442.GA9582@redhat.com>
 <20120119155545.GD5198@google.com>
 <20120119161642.GC10908@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120119161642.GC10908@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Jan 19, 2012 at 11:16:42AM -0500, Vivek Goyal wrote:
> 1. elv_quiesce_start
> 2. unregister old elevator
> 3. ioc_clear_queue
> 4. allocate new elevator
> 5. init new elevator
> 6. exit old elevator
> 
> So any groups on old elevator, will be cleaned up in step 6. So till step
> 5 these groups are still present on blkcg list. Now assume between step 5
> and step 6, if a cgroup removal takes place and blkcg tries to call into
> elevator to remove that group, will it not be accessing the wrong cfqd
> in cfq_destroy_cfqg() (cfqd of new elevator instead of old elevator).
> 
> What am I missing?

I don't think you're missing anything.  The issue is moot as the
second patchset, which I'll probably post today, unifies blkg's so
that there's single blkg per cgroup - request_queue pair.

Hmmm... we can add code to shoot down blkg's along with ioc's while
preparing for elevator switch or just note the problem in the commit
message and explain the problem is transitional.  I'll see how complex
shooting down blkg's would be.

Thanks.

-- 
tejun

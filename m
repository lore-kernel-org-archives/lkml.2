Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755603Ab2BVWEL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 17:04:11 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:37883 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755387Ab2BVWEK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 17:04:10 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of htejun@gmail.com designates 10.68.229.33 as permitted sender) smtp.mail=htejun@gmail.com; dkim=pass header.i=htejun@gmail.com
Date: Wed, 22 Feb 2012 14:04:04 -0800
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: axboe@kernel.dk, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET] blkcg: accumulated blkcg updates
Message-ID: <20120222220404.GB22536@google.com>
References: <1329875223-5102-1-git-send-email-tj@kernel.org>
 <20120222193429.GA7635@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120222193429.GA7635@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Feb 22, 2012 at 02:34:29PM -0500, Vivek Goyal wrote:
> This series looks good to me. We just need two more pieces which need
> to be pushed along with this series.
>
> - Do not cleanup all blkg upon policy change. Just reclaim policy
>   data/blkg which belong to policy.
> 
> - per cpu stat allocation from async context. 

Yeah, I'm getting to this now.  Two more things I wanna do are

- Moving stats and configurations to blkg policies instead of putting
  them in blk-cgroup.c and then pipe to cgroup policies.  This will
  require updates to cgroup to allow live removal / addition of cgroup
  files on existing cgroup directories.  Should be doable but I'm a
  bit skeptical cgroup is implementing proper sever mechanism on files
  and if not we're gonna have to implement that first.

- Make enabled policies per-queue.

Thanks.

-- 
tejun

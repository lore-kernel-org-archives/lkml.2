Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756182Ab2CLSEc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 14:04:32 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:48893 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756027Ab2CLSE3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 14:04:29 -0400
Date: Mon, 12 Mar 2012 11:04:23 -0700
From: Tejun Heo <tj@kernel.org>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org,
        Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH] blk-cgroup: Call cgroup_path only under cgroup lock
Message-ID: <20120312180423.GC23255@google.com>
References: <1331582478-2259-1-git-send-email-levinsasha928@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331582478-2259-1-git-send-email-levinsasha928@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Sasha.

On Mon, Mar 12, 2012 at 04:01:18PM -0400, Sasha Levin wrote:
> Since we can't keep rcu read lock during blkg_alloc(), we currently
> call cgroup_path() without any locks at all.
> 
> This patch adds cgroup locking before calling cgroup_path.
> 
> This also fixes a lockdep warning on boot.
> 
> Signed-off-by: Sasha Levin <levinsasha928@gmail.com>

Which branch is this against?  There's already pending stat update
patch from Vivek which fix this problem along with the percpu
allocation problem.

Thanks.

-- 
tejun

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753188Ab1LTXSc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 18:18:32 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:64111 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752918Ab1LTXS3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 18:18:29 -0500
Date: Tue, 20 Dec 2011 15:18:23 -0800
From: Tejun Heo <tj@kernel.org>
To: Mandeep Singh Baines <msb@chromium.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>, LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Menage <paul@paulmenage.org>
Subject: Re: [PATCH 1/5 V3] cgroup: remove redundate get/put of old css_set
 from migrate
Message-ID: <20111220231823.GK10752@google.com>
References: <1324422873-31001-1-git-send-email-msb@chromium.org>
 <1324422873-31001-2-git-send-email-msb@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1324422873-31001-2-git-send-email-msb@chromium.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

s/redundate/redundant/ in $SUBJ, right?

On Tue, Dec 20, 2011 at 03:14:29PM -0800, Mandeep Singh Baines wrote:
> Changes in V3:
> * Fixed to put error in retval (thanks Frederic Weisbecker)
>   * https://lkml.org/lkml/2011/12/20/255
> Changes in V2:
> * Updated commit message as per Tejun's feedback:
>   * https://lkml.org/lkml/2011/12/19/289
> 
> -- >8 -- (snip)

Either put this as part of patch description or if you don't want it
to be part of commit message, put it between --- and diffstat.
Unfortunately, no tool understands "-- >8 --".

> We can now assume that the css_set reference held by the task
> will not go away for an exiting task. PF_EXITING state can be
> trusted throughout migration by checking it after locking
> threadgroup.
> 
> While at it, renamed css_set_check_fetched to css_set_fetched.
> !css_set_fetched() seems to read better than
> !css_set_check_fetched().

I don't feel too hot about the renaming.  Can you please drop it for
now?

> Signed-off-by: Mandeep Singh Baines <msb@chromium.org>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Li Zefan <lizf@cn.fujitsu.com>
> Cc: containers@lists.linux-foundation.org
> Cc: cgroups@vger.kernel.org
> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Oleg Nesterov <oleg@redhat.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Paul Menage <paul@paulmenage.org>

Other than that, looks good to me.  I'll commit this once Li acks it.

Thanks.

-- 
tejun

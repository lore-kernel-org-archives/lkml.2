Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752670Ab1LTTO4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 14:14:56 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:44190 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751531Ab1LTTOt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 14:14:49 -0500
Date: Tue, 20 Dec 2011 11:14:43 -0800
From: Tejun Heo <tj@kernel.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>, LKML <linux-kernel@vger.kernel.org>,
        Containers <containers@lists.linux-foundation.org>,
        Cgroups <cgroups@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Menage <paul@paulmenage.org>,
        Mandeep Singh Baines <msb@chromium.org>
Subject: Re: [PATCH 1/2] cgroup: Remove unnecessary task_lock before
 fetching css_set on migration
Message-ID: <20111220191443.GE10752@google.com>
References: <1324320274-18485-1-git-send-email-msb@chromium.org>
 <1324407673-18975-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1324407673-18975-1-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Frederic.

On Tue, Dec 20, 2011 at 08:01:12PM +0100, Frederic Weisbecker wrote:
> When we fetch the css_set of the tasks on cgroup migration, we don't need
> anymore to synchronize against cgroup_exit() that could swap the old one
> with init_css_set. Now that we are using threadgroup_lock() during
> the migrations, we don't need to worry about it anymore.
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Li Zefan <lizf@cn.fujitsu.com>
> Cc: Containers <containers@lists.linux-foundation.org>
> Cc: Cgroups <cgroups@vger.kernel.org>
> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Cc: Oleg Nesterov <oleg@redhat.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Paul Menage <paul@paulmenage.org>
> Cc: Mandeep Singh Baines <msb@chromium.org>

I like this but it doesn't apply on top of cgroup/for-3.3.  It
collides with Mandeep's patch.  Can you please rebase?

Li, can you please ack?

Thanks.

-- 
tejun

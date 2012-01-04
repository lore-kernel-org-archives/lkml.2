Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755338Ab2ADKi1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 05:38:27 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:35746 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755292Ab2ADKiY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 05:38:24 -0500
Date: Wed, 4 Jan 2012 11:38:18 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Mandeep Singh Baines <msb@chromium.org>
Cc: Tejun Heo <tj@kernel.org>, Li Zefan <lizf@cn.fujitsu.com>,
        linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Menage <paul@paulmenage.org>
Subject: Re: [PATCH 2/3] cgroup: replace tasklist_lock with rcu_read_lock
Message-ID: <20120104103810.GA1143@somewhere>
References: <1325654312-32477-1-git-send-email-msb@chromium.org>
 <1325654312-32477-2-git-send-email-msb@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1325654312-32477-2-git-send-email-msb@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 03, 2012 at 09:18:31PM -0800, Mandeep Singh Baines wrote:
> We can replace the tasklist_lock in cgroup_attach_proc with an
> rcu_read_lock.
> 
> Changes in V4:
> * https://lkml.org/lkml/2011/12/23/284 (Frederic Weisbecker)
>   * Minimize size of rcu_read_lock critical section
>   * Add comment
> * https://lkml.org/lkml/2011/12/26/136 (Li Zefan)
>   * Split into two patches
> Changes in V3:
> * https://lkml.org/lkml/2011/12/22/419 (Frederic Weisbecker)
>   * Add an rcu_read_lock to protect against exit
> Changes in V2:
> * https://lkml.org/lkml/2011/12/22/86 (Tejun Heo)
>   * Use a goto instead of returning -EAGAIN
> 
> Suggested-by: Frederic Weisbecker <fweisbec@gmail.com>
> Signed-off-by: Mandeep Singh Baines <msb@chromium.org>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Li Zefan <lizf@cn.fujitsu.com>
> Cc: containers@lists.linux-foundation.org
> Cc: cgroups@vger.kernel.org
> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Cc: Oleg Nesterov <oleg@redhat.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Paul Menage <paul@paulmenage.org>

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>

Thanks!

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932259Ab1IRTAe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Sep 2011 15:00:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12071 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932082Ab1IRTAd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Sep 2011 15:00:33 -0400
Date: Sun, 18 Sep 2011 20:56:21 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <htejun@gmail.com>
Cc: rjw@sisk.pl, paul@paulmenage.org, lizf@cn.fujitsu.com,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org, fweisbec@gmail.com,
        matthltc@us.ibm.com, akpm@linux-foundation.org,
        Tejun Heo <tj@kernel.org>, Paul Menage <menage@google.com>
Subject: Re: [PATCH 1/4] cgroup: change locking order in
	attach_task_by_pid()
Message-ID: <20110918185621.GB6159@redhat.com>
References: <1315159280-25032-1-git-send-email-htejun@gmail.com> <1315159280-25032-2-git-send-email-htejun@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1315159280-25032-2-git-send-email-htejun@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/05, Tejun Heo wrote:
>
> cgroup_mutex is updated to nest inside threadgroup_fork_lock instead
> of the other way around.  threadgroup locking is scheduled to be
> updated to cover all threadgroup altering operations and nesting it
> inside cgroup_mutex complicates locking dependency unnecessarily.

Could you please explain this change?

I can't understand why threadgroup_lock() under cgroup_mutex is bad.
Do you mean we can deadlock otherwise?

And, this means we can't change cpuset_do_move_task() to do
threadgroup_lock().

Oleg.


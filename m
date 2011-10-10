Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753220Ab1JJRec (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 13:34:32 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:35224 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751879Ab1JJReb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 13:34:31 -0400
Date: Mon, 10 Oct 2011 10:34:26 -0700
From: Tejun Heo <htejun@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: rjw@sisk.pl, paul@paulmenage.org, lizf@cn.fujitsu.com,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org, fweisbec@gmail.com,
        matthltc@us.ibm.com, akpm@linux-foundation.org,
        Paul Menage <menage@google.com>
Subject: Re: [PATCH 1/4] cgroup: change locking order in
 attach_task_by_pid()
Message-ID: <20111010173426.GG8100@google.com>
References: <1315159280-25032-1-git-send-email-htejun@gmail.com>
 <1315159280-25032-2-git-send-email-htejun@gmail.com>
 <20110918185621.GB6159@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110918185621.GB6159@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Sun, Sep 18, 2011 at 08:56:21PM +0200, Oleg Nesterov wrote:
> On 09/05, Tejun Heo wrote:
> >
> > cgroup_mutex is updated to nest inside threadgroup_fork_lock instead
> > of the other way around.  threadgroup locking is scheduled to be
> > updated to cover all threadgroup altering operations and nesting it
> > inside cgroup_mutex complicates locking dependency unnecessarily.
> 
> Could you please explain this change?
> 
> I can't understand why threadgroup_lock() under cgroup_mutex is bad.
> Do you mean we can deadlock otherwise?

Yeah, I forgot the chain but it triggers a valid lockdep deadlock
warning.

> And, this means we can't change cpuset_do_move_task() to do
> threadgroup_lock().

Would that be problematic?

Thanks.

-- 
tejun

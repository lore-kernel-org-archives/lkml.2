Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757587Ab2AECF6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 21:05:58 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:62923 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751923Ab2AECFz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 21:05:55 -0500
Message-ID: <4F05060F.5090600@cn.fujitsu.com>
Date: Thu, 05 Jan 2012 10:08:15 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Mandeep Singh Baines <msb@chromium.org>
CC: Tejun Heo <tj@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Menage <paul@paulmenage.org>
Subject: Re: [PATCH 1/3] cgroup: simplify double-check locking in cgroup_attach_proc
References: <1325654312-32477-1-git-send-email-msb@chromium.org>
In-Reply-To: <1325654312-32477-1-git-send-email-msb@chromium.org>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-01-05 10:04:57,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-01-05 10:04:59,
	Serialize complete at 2012-01-05 10:04:59
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mandeep Singh Baines wrote:
> To keep the complexity of the double-check locking in one place,
> I moved the thread_group_leader check up into attach_task_by_pid.
> This allows us to use a goto instead of returning -EAGAIN.
> 
> While at it, converted a couple of returns to gotos and used
> rcu for the !pid case also in order to simplify the logic.
> 
> Changes in V2:
> * https://lkml.org/lkml/2011/12/22/86 (Tejun Heo)
>   * Use a goto instead of returning -EAGAIN
> 
> Signed-off-by: Mandeep Singh Baines <msb@chromium.org>

Acked-by: Li Zefan <lizf@cn.fujitsu.com>

> Cc: Tejun Heo <tj@kernel.org>
> Cc: Li Zefan <lizf@cn.fujitsu.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: containers@lists.linux-foundation.org
> Cc: cgroups@vger.kernel.org
> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Cc: Oleg Nesterov <oleg@redhat.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Paul Menage <paul@paulmenage.org>
> ---
>  kernel/cgroup.c |   79 ++++++++++++++++++++----------------------------------
>  1 files changed, 29 insertions(+), 50 deletions(-)

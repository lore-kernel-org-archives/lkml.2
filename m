Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753021Ab1LVFeF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 00:34:05 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:52621 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751250Ab1LVFeC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 00:34:02 -0500
Message-ID: <4EF2C1CB.4030103@cn.fujitsu.com>
Date: Thu, 22 Dec 2011 13:36:11 +0800
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
Subject: Re: [PATCH 2/4] cgroup: remove redundant get/put of task struct
References: <1324527518-24461-1-git-send-email-msb@chromium.org> <1324527518-24461-2-git-send-email-msb@chromium.org>
In-Reply-To: <1324527518-24461-2-git-send-email-msb@chromium.org>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-12-22 13:33:16,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-12-22 13:33:18,
	Serialize complete at 2011-12-22 13:33:18
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mandeep Singh Baines wrote:
> threadgroup_lock() guarantees that the target threadgroup will
> remain stable - no new task will be added, no new PF_EXITING
> will be set and exec won't happen.
> 
> Changes in V2:
> * https://lkml.org/lkml/2011/12/20/369 (Tejun Heo)
>   * Undo incorrect removal of get/put from attach_task_by_pid()
> * Author
>   * Remove a comment which is made stale by this change
> 
> Signed-off-by: Mandeep Singh Baines <msb@chromium.org>

Acked-by: Li Zefan <lizf@cn.fujitsu.com>

> Cc: Tejun Heo <tj@kernel.org>
> Cc: Li Zefan <lizf@cn.fujitsu.com>
> Cc: containers@lists.linux-foundation.org
> Cc: cgroups@vger.kernel.org
> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Oleg Nesterov <oleg@redhat.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Paul Menage <paul@paulmenage.org>
> ---
>  kernel/cgroup.c |   11 ++---------
>  1 files changed, 2 insertions(+), 9 deletions(-)

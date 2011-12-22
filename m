Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753210Ab1LVFJ4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 00:09:56 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:59517 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751630Ab1LVFJy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 00:09:54 -0500
Message-ID: <4EF2BC1C.90208@cn.fujitsu.com>
Date: Thu, 22 Dec 2011 13:11:56 +0800
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
Subject: Re: [PATCH 1/4] cgroup: remove redundant get/put of old css_set from
 migrate
References: <1324527518-24461-1-git-send-email-msb@chromium.org>
In-Reply-To: <1324527518-24461-1-git-send-email-msb@chromium.org>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-12-22 13:09:02,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-12-22 13:09:11,
	Serialize complete at 2011-12-22 13:09:11
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mandeep Singh Baines wrote:
> We can now assume that the css_set reference held by the task
> will not go away for an exiting task. PF_EXITING state can be
> trusted throughout migration by checking it after locking
> threadgroup.
> 
> While at it, renamed css_set_check_fetched to css_set_fetched.
> !css_set_fetched() seems to read better than
> !css_set_check_fetched().
> 
> Changes in V4:
> * https://lkml.org/lkml/2011/12/20/368 (Tejun Heo)
>   * Fix typo in commit message
>   * Undid the rename of css_set_check_fetched
> * https://lkml.org/lkml/2011/12/20/427 (Li Zefan)
>   * Fix comment in cgroup_task_migrate()
> Changes in V3:
> * https://lkml.org/lkml/2011/12/20/255 (Frederic Weisbecker)
>   * Fixed to put error in retval
> Changes in V2:
> * https://lkml.org/lkml/2011/12/19/289 (Tejun Heo)
>   * Updated commit message
> 
> Signed-off-by: Mandeep Singh Baines <msb@chromium.org>

Reviewed-by: Li Zefan <lizf@cn.fujitsu.com>

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
>  kernel/cgroup.c |   28 ++++++++--------------------
>  1 files changed, 8 insertions(+), 20 deletions(-)

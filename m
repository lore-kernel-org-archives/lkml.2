Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753998Ab1LUBvP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 20:51:15 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:59055 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751638Ab1LUBvL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 20:51:11 -0500
Message-ID: <4EF13C04.2050006@cn.fujitsu.com>
Date: Wed, 21 Dec 2011 09:53:08 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Tejun Heo <tj@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Containers <containers@lists.linux-foundation.org>,
        Cgroups <cgroups@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Menage <paul@paulmenage.org>,
        Mandeep Singh Baines <msb@chromium.org>
Subject: Re: [PATCH 1/2] cgroup: Remove unnecessary task_lock before fetching
 css_set on migration
References: <1324320274-18485-1-git-send-email-msb@chromium.org> <1324407673-18975-1-git-send-email-fweisbec@gmail.com>
In-Reply-To: <1324407673-18975-1-git-send-email-fweisbec@gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-12-21 09:50:16,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-12-21 09:50:24,
	Serialize complete at 2011-12-21 09:50:24
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker wrote:
> When we fetch the css_set of the tasks on cgroup migration, we don't need
> anymore to synchronize against cgroup_exit() that could swap the old one
> with init_css_set. Now that we are using threadgroup_lock() during
> the migrations, we don't need to worry about it anymore.
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>

Good catch!

Reviewed-by: Li Zefan <lizf@cn.fujitsu.com>

> Cc: Tejun Heo <tj@kernel.org>
> Cc: Li Zefan <lizf@cn.fujitsu.com>
> Cc: Containers <containers@lists.linux-foundation.org>
> Cc: Cgroups <cgroups@vger.kernel.org>
> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Cc: Oleg Nesterov <oleg@redhat.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Paul Menage <paul@paulmenage.org>
> Cc: Mandeep Singh Baines <msb@chromium.org>
> ---
>  kernel/cgroup.c |   21 +++++++++++----------
>  1 files changed, 11 insertions(+), 10 deletions(-)

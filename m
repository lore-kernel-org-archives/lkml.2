Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753698Ab1LUB1d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 20:27:33 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:59842 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753067Ab1LUB1b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 20:27:31 -0500
Message-ID: <4EF13675.9030000@cn.fujitsu.com>
Date: Wed, 21 Dec 2011 09:29:25 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Mandeep Singh Baines <msb@chromium.org>
CC: Tejun Heo <tj@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Menage <paul@paulmenage.org>
Subject: Re: [PATCH 3/5] cgroup: only need to check oldcgrp==newgrp once
References: <1324422873-31001-1-git-send-email-msb@chromium.org> <1324422873-31001-4-git-send-email-msb@chromium.org>
In-Reply-To: <1324422873-31001-4-git-send-email-msb@chromium.org>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-12-21 09:26:34,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-12-21 09:26:42,
	Serialize complete at 2011-12-21 09:26:42
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mandeep Singh Baines wrote:
> In cgroup_attach_proc it is now sufficient to only check that
> oldcgrp==newcgrp once. Now that we are using threadgroup_lock()
> during the migrations, oldcgrp will not change.
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
>  kernel/cgroup.c |   17 ++++++-----------
>  1 files changed, 6 insertions(+), 11 deletions(-)

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752914Ab1FTG2r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 02:28:47 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57596 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751951Ab1FTG2q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 02:28:46 -0400
Message-ID: <4DFEE9BE.6050501@cn.fujitsu.com>
Date: Mon, 20 Jun 2011 14:33:34 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>, Paul Menage <menage@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC PATCH 0/4] cgroups: Start a basic rlimit subsystem
References: <1308527474-20704-1-git-send-email-fweisbec@gmail.com>
In-Reply-To: <1308527474-20704-1-git-send-email-fweisbec@gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-06-20 14:28:20,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-06-20 14:28:20,
	Serialize complete at 2011-06-20 14:28:20
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker wrote:
> This starts a basic rlimit cgroup subsystem with only the
> equivalent of RLIMIT_NPROC yet. This can be useful to limit
> the global effects of a local fork bomb for example (local
> in term of a cgroup).
> 
> The thing is further expandable to host more general resource
> limitations in the scope of a cgroup.
> 

As this subsystem is named "rlimit", I think we should have a bigger
picture about how this subsystem will be.

For example, which of other RLIMIT_XXX can be make cgroup-aware in
a meaningful way and which can't.

Another issue is, we can apply the limit of RLIMIT_NPROC as the sum
of the tasks' limit in a cgroup, but some other RLIMIT_XXX can't
work in this way. Take RLIMIT_NICE for example, we can apply this
limit to each of the tasks in the cgroup.

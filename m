Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760055Ab2C3IiL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 04:38:11 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36615 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759930Ab2C3IiE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 04:38:04 -0400
Date: Fri, 30 Mar 2012 10:38:01 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Tejun Heo <tj@kernel.org>
Cc: Mandeep Singh Baines <msb@chromium.org>, lizefan@huawei.com,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        Paul Menage <paul@paulmenage.org>, Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH for-3.4-fixes] cgroup: cgroup_attach_task() could return
 -errno after success
In-Reply-To: <20120329162620.GD28941@google.com>
Message-ID: <alpine.LNX.2.00.1203301037380.25526@pobox.suse.cz>
References: <alpine.LNX.2.00.1203282354440.25526@pobox.suse.cz> <20120329160433.GC28941@google.com> <20120329162620.GD28941@google.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Mar 2012, Tejun Heo wrote:

> 61d1d219c4 "cgroup: remove extra calls to find_existing_css_set" made
> cgroup_task_migrate() return void.  An unfortunate side effect was
> that cgroup_attach_task() was depending on that function's return
> value to clear its @retval on the success path.  On cgroup mounts
> without any subsystem with ->can_attach() callback,
> cgroup_attach_task() ended up returning @retval without initializing
> it on success.
> 
> For some reason, gcc failed to warn about it and it didn't cause
> cgroup_attach_task() to return non-zero value in many cases, probably
> due to difference in register allocation.  When the problem
> materializes, systemd fails to populate /systemd cgroup mount and
> fails to boot.
> 
> Fix it by initializing @retval to zero on declaration.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Reported-by: Jiri Kosina <jkosina@suse.cz>
> LKML-Reference: <alpine.LNX.2.00.1203282354440.25526@pobox.suse.cz>
> ---
> Jiri, can you please confirm the fix?

Thanks Tejun, it works here.

Tested-by: Jiri Kosina <jkosina@suse.cz>

-- 
Jiri Kosina
SUSE Labs

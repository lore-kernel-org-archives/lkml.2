Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934025Ab2C3AhP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 20:37:15 -0400
Received: from szxga01-in.huawei.com ([58.251.152.64]:37615 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758527Ab2C3AhL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 20:37:11 -0400
Date: Fri, 30 Mar 2012 08:37:05 +0800
From: Li Zefan <lizefan@huawei.com>
Subject: Re: [PATCH for-3.4-fixes] cgroup: cgroup_attach_task() could return
 -errno after success
In-reply-to: <20120329162620.GD28941@google.com>
X-Originating-IP: [10.166.88.150]
To: Tejun Heo <tj@kernel.org>
Cc: Jiri Kosina <jkosina@suse.cz>, Mandeep Singh Baines <msb@chromium.org>,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        Paul Menage <paul@paulmenage.org>, Kay Sievers <kay.sievers@vrfy.org>
Message-id: <4F750031.3090903@huawei.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7BIT
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:11.0) Gecko/20120312
 Thunderbird/11.0
X-CFilter-Loop: Reflected
References: <alpine.LNX.2.00.1203282354440.25526@pobox.suse.cz>
 <20120329160433.GC28941@google.com> <20120329162620.GD28941@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:

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


Acked-by: Li Zefan <lizefan@huawei.com>

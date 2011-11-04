Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753386Ab1KDIjy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 04:39:54 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:33966 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752569Ab1KDIjx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 04:39:53 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 4 Nov 2011 17:38:34 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Tejun Heo <tj@kernel.org>
Cc: paul@paulmenage.org, rjw@sisk.pl, lizf@cn.fujitsu.com,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org, fweisbec@gmail.com,
        matthltc@us.ibm.com, akpm@linux-foundation.org, oleg@redhat.com,
        kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [PATCH 01/10] cgroup: add cgroup_root_mutex
Message-Id: <20111104173834.ea089a41.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1320191193-8110-2-git-send-email-tj@kernel.org>
References: <1320191193-8110-1-git-send-email-tj@kernel.org>
	<1320191193-8110-2-git-send-email-tj@kernel.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  1 Nov 2011 16:46:24 -0700
Tejun Heo <tj@kernel.org> wrote:

> cgroup wants to make threadgroup stable while modifying cgroup
> hierarchies which will introduce locking dependency on
> cred_guard_mutex from cgroup_mutex.  This unfortunately completes
> circular dependency.
> 
>  A. cgroup_mutex -> cred_guard_mutex -> s_type->i_mutex_key -> namespace_sem
>  B. namespace_sem -> cgroup_mutex
> 
> B is from cgroup_show_options() and this patch breaks it by
> introducing another mutex cgroup_root_mutex which nests inside
> cgroup_mutex and protects cgroupfs_root.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Oleg Nesterov <oleg@redhat.com>

Thanks,
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>


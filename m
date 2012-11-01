Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761802Ab2KAOwa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 10:52:30 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:38260 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760653Ab2KAOw0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 10:52:26 -0400
MIME-Version: 1.0
In-Reply-To: <20121101091644.GA8533@dhcp22.suse.cz>
References: <1351657365-25055-1-git-send-email-tj@kernel.org>
	<1351657365-25055-4-git-send-email-tj@kernel.org>
	<20121031155514.GD22809@dhcp22.suse.cz>
	<20121031170431.GF2945@htj.dyndns.org>
	<20121101091644.GA8533@dhcp22.suse.cz>
Date: Thu, 1 Nov 2012 07:52:24 -0700
X-Google-Sender-Auth: vXVoZT3_fUTRkIK5DqFVpkulXU4
Message-ID: <CAOS58YM+kRtspVUzmnSmOmrDoNS_kF6KA02zWGxqH5FUcRWo1Q@mail.gmail.com>
Subject: Re: [PATCH 3/8] cgroup: use cgroup_lock_live_group(parent) in cgroup_create()
From: Tejun Heo <tj@kernel.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: lizefan@huawei.com, hannes@cmpxchg.org, bsingharora@gmail.com,
        kamezawa.hiroyu@jp.fujitsu.com, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, Michal.

On Thu, Nov 1, 2012 at 2:16 AM, Michal Hocko <mhocko@suse.cz> wrote:
> I am not sure I understand. What does deactivate_super has to do with
> the above suggestion? cgroup_lock_live_group will take the cgroup_mutex
> on the success or frees the previously allocated&unused memory. The
> only thing I was suggesting is to do cgroup_lock_live_group first and
> allocate the cgroup only if it doesn't fail.

It complicates updates to the error exit path. You end up having to
update a lot more and it's not like grabbing lock first is
substantially better in any way, so why bother?

Thanks.

-- 
tejun

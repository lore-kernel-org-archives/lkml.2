Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758358Ab2JaRSz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 13:18:55 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:35586 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751956Ab2JaRSx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 13:18:53 -0400
Date: Wed, 31 Oct 2012 10:18:49 -0700
From: Tejun Heo <tj@kernel.org>
To: Glauber Costa <glommer@parallels.com>
Cc: lizefan@huawei.com, hannes@cmpxchg.org, mhocko@suse.cz,
        bsingharora@gmail.com, kamezawa.hiroyu@jp.fujitsu.com,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET] cgroup: simplify cgroup removal path
Message-ID: <20121031171849.GH2945@htj.dyndns.org>
References: <1351657365-25055-1-git-send-email-tj@kernel.org>
 <50912C6D.6020000@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50912C6D.6020000@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Oct 31, 2012 at 05:49:33PM +0400, Glauber Costa wrote:
> The only think that drew my attention is that you are changing the
> local_irq_save callsite to local_irq_disable. It shouldn't be a problem,
> since this is never expected to be called in interrupt context.
> 
> Still... it makes me wonder if that disabled-interrupt block is still
> needed? According to the changelogs, it was introduced in e7c5ec919 for
> the css_tryget mechanism. But css_tryget itself will never scan
> subsystems, so if we can no longer fail, we should be able to just ditch
> it. Unless I am missing something

Note both in the commit messages.

Thanks.

-- 
tejun

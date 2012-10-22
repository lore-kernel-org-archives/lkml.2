Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755986Ab2JVSdq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 14:33:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62561 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755744Ab2JVSdp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 14:33:45 -0400
Date: Mon, 22 Oct 2012 20:34:53 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: rjw@sisk.pl, linux-kernel@vger.kernel.org, lizefan@huawei.com,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org
Subject: Re: [PATCH 4/7] cgroup_freezer: don't stall transition to FROZEN
	for PF_NOFREEZE or PF_FREEZER_SKIP tasks
Message-ID: <20121022183453.GA24687@redhat.com>
References: <1350426526-14254-1-git-send-email-tj@kernel.org> <1350426526-14254-5-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350426526-14254-5-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/16, Tejun Heo wrote:
>
> cgroup_freezer doesn't transition from FREEZING to FROZEN if the
> cgroup contains PF_NOFREEZE tasks or tasks sleeping with
> PF_FREEZER_SKIP set.

And thus the patch looks like another bugfix to me.


Just one question, and this question is offtopic again,

> Only kernel tasks can be non-freezable (PF_NOFREEZE)

Hmm. We seem to "leak" PF_NOFREEZE if a kernel thread execs?
Perhaps do_execve_common() should do set_freezable() before return.

Or, at least, simply clear this flag along with PF_KTHREAD in
flush_old_exec().

Oleg.


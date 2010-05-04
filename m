Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757388Ab0EDLQq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 07:16:46 -0400
Received: from one.firstfloor.org ([213.235.205.2]:58417 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751106Ab0EDLQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 07:16:44 -0400
To: Arve =?iso-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Len Brown <len.brown@intel.com>, Oleg Nesterov <oleg@redhat.com>,
       Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 4/8] PM: suspend_block: Add debugfs file
From: Andi Kleen <andi@halobates.de>
References: <1272667021-21312-1-git-send-email-arve@android.com>
	<1272667021-21312-2-git-send-email-arve@android.com>
	<1272667021-21312-3-git-send-email-arve@android.com>
	<1272667021-21312-4-git-send-email-arve@android.com>
	<1272667021-21312-5-git-send-email-arve@android.com>
Date: Tue, 04 May 2010 13:16:40 +0200
In-Reply-To: <1272667021-21312-5-git-send-email-arve@android.com> (Arve
 =?iso-8859-1?Q?Hj=F8nnev=E5g's?= message of "Fri, 30 Apr 2010 15:36:57
 -0700")
Message-ID: <87mxwf533b.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arve Hjønnevåg <arve@android.com> writes:
>  
> +static int suspend_blocker_stats_show(struct seq_file *m, void *unused)
> +{
> +	unsigned long irqflags;
> +	struct suspend_blocker *blocker;
> +
> +	seq_puts(m, "name\tactive\n");
> +	spin_lock_irqsave(&list_lock, irqflags);
> +	list_for_each_entry(blocker, &inactive_blockers, link)
> +		seq_printf(m, "\"%s\"\t0\n", blocker->name);
> +	list_for_each_entry(blocker, &active_blockers, link)
> +		seq_printf(m, "\"%s\"\t1\n", blocker->name);
> +	spin_unlock_irqrestore(&list_lock, irqflags);

Could you report the pid here too? 

The name set by the application might be meaningless or duplicated.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.

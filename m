Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758186Ab1LGS7L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 13:59:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9547 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757832Ab1LGS7J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 13:59:09 -0500
Date: Wed, 7 Dec 2011 19:53:43 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Tejun Heo <tj@kernel.org>, Vasiliy Kulikov <segoon@openwall.com>,
        Andrew Vagin <avagin@openvz.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fs, proc: Introduce the /proc/<pid>/children entry v2
Message-ID: <20111207185343.GA3209@redhat.com>
References: <20111206181026.GO29781@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111206181026.GO29781@moon>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Cyrill,

Sorry, I didn't read this patch yet, but

On 12/06, Cyrill Gorcunov wrote:
>
> +static void *children_seq_start(struct seq_file *seq, loff_t *pos)
> +{
> +	struct task_struct *task;
> +
> +	rcu_read_lock();
> +	task = seq->private;
> +	if (task)
> +		return seq_list_start(&task->children, *pos);

This looks "obviously wrong".

We can not trust ->children->next after rcu_read_unlock(). Another
rcu_read_lock() can't help.

Once again, I can be easily wrong, need to read the patch first.

Oleg.


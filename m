Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932405Ab2B1RLt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 12:11:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36396 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932349Ab2B1RLr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 12:11:47 -0500
Date: Tue, 28 Feb 2012 18:04:36 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Siddhesh Poyarekar <siddhesh.poyarekar@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Jamie Lokier <jamie@shareable.org>, Mike Frysinger <vapier@gentoo.org>,
        Alexey Dobriyan <adobriyan@gmail.com>, Matt Mackall <mpm@selenic.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: + procfs-mark-thread-stack-correctly-in-proc-pid-maps.patch
	added to -mm tree
Message-ID: <20120228170436.GA9698@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +int vm_is_stack(struct task_struct *task,
> +			      struct vm_area_struct *vma, int in_group)
> +{
> +	if (vm_is_stack_for_task(task, vma))
> +		return 1;
> +
> +	if (in_group) {
> +		struct task_struct *t = task;
> +		while_each_thread(task, t) {
> +			if (vm_is_stack_for_task(t, vma))
> +				return 1;
> +		}
> +	}
> +
> +	return 0;
> +}

This is obviously wrong, while_each_thread() is not safe without
tasklist or siglock or rcu.

Oleg.


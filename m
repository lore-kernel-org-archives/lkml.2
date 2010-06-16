Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758987Ab0FPQG3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 12:06:29 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:10430 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752438Ab0FPQG2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 12:06:28 -0400
Message-ID: <4C18F625.9040107@openvz.org>
Date: Wed, 16 Jun 2010 20:04:53 +0400
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Louis Rilling <louis.rilling@kerlabs.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>,
       Linux Containers <containers@lists.osdl.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] procfs: Do not release pid_ns->proc_mnt too early
References: <1276703910-16936-1-git-send-email-louis.rilling@kerlabs.com>
In-Reply-To: <1276703910-16936-1-git-send-email-louis.rilling@kerlabs.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +void proc_new_task(struct task_struct *task)
> +{
> +	struct pid *pid;
> +	int i;
> +
> +	if (!task->pid)
> +		return;
> +
> +	pid = task_pid(task);
> +	for (i = 0; i <= pid->level; i++)
> +		mntget(pid->numbers[i].ns->proc_mnt);

I feel I'm missing something significant, but this patch breaks
the mntget/mntput balance. Doesn't it?

> +}

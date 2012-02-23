Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932209Ab2BWXSO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 18:18:14 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:64110 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756089Ab2BWXSN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 18:18:13 -0500
MIME-Version: 1.0
In-Reply-To: <1328972596-4142-1-git-send-email-siddhesh.poyarekar@gmail.com>
References: <4F32B776.6070007@gmail.com> <1328972596-4142-1-git-send-email-siddhesh.poyarekar@gmail.com>
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Date: Thu, 23 Feb 2012 18:17:52 -0500
Message-ID: <CAHGf_=oi8_s0Bxn4qSD7S_FBSgp29BPXor4hCf5-kekGnf3qEw@mail.gmail.com>
Subject: Re: [PATCH] Mark thread stack correctly in proc/<pid>/maps
To: Siddhesh Poyarekar <siddhesh.poyarekar@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, Jamie Lokier <jamie@shareable.org>,
        vapier@gentoo.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

This version makes sense to me. and I verified this change don't break
procps tools.

But,

> +int vm_is_stack(struct task_struct *task,
> +                             struct vm_area_struct *vma, int in_group)
> +{
> +       if (vm_is_stack_for_task(task, vma))
> +               return 1;
> +
> +       if (in_group) {
> +               struct task_struct *t = task;
> +               while_each_thread(task, t) {

How protect this loop from task exiting? AFAIK, while_each_thread
require rcu_read_lock or task_list_lock.


> +                       if (vm_is_stack_for_task(t, vma))
> +                               return 1;
> +               }
> +       }

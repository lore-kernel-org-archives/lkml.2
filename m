Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752992Ab1HYJnK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 05:43:10 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:57959 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752320Ab1HYJnG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 05:43:06 -0400
MIME-Version: 1.0
In-Reply-To: <1314138000-2049-3-git-send-email-tj@kernel.org>
References: <1314138000-2049-1-git-send-email-tj@kernel.org> <1314138000-2049-3-git-send-email-tj@kernel.org>
From: Paul Menage <paul@paulmenage.org>
Date: Thu, 25 Aug 2011 02:42:46 -0700
X-Google-Sender-Auth: L5RbwnQaKRJnuXlN-eqI4Sa2uRo
Message-ID: <CALdu-PBr-tu1qzScvncr-N4EpPaQ7sTdHf28GhEv_MZLbo1eSg@mail.gmail.com>
Subject: Re: [PATCH 2/6] cgroup: improve old cgroup handling in cgroup_attach_proc()
To: Tejun Heo <tj@kernel.org>
Cc: rjw@sisk.pl, lizf@cn.fujitsu.com, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 23, 2011 at 3:19 PM, Tejun Heo <tj@kernel.org> wrote:
> cgroup_attach_proc() behaves differently from cgroup_attach_task() in
> the following aspects.
>
> * All hooks are invoked even if no task is actually being moved.
>
> * ->can_attach_task() is called for all tasks in the group whether the
>  new cgrp is different from the current cgrp or not; however,
>  ->attach_task() is skipped if new equals new.  This makes the calls
>  asymmetric.
>
> This patch improves old cgroup handling in cgroup_attach_proc() by
> looking up the current cgroup at the head, recording it in the flex
> array along with the task itself, and using it to remove the above two
> differences.  This will also ease further changes.
>
> Signed-off-by: Tejun Heo <tj@kernel.org>

Acked-by: Paul Menage <paul@paulmenage.org>

With the later cgroup_taskset changes making use of the same flex
array, I guess I agree that leaving all the tasks in the array makes
sense.

> +       int retval, i, group_size, nr_todo;

I'd be inclined to call "nr_todo" something like "nr_migrating_tasks"
for clarity.

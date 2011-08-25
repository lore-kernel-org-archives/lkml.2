Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752337Ab1HYIwC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 04:52:02 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:60696 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751974Ab1HYIv7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 04:51:59 -0400
MIME-Version: 1.0
In-Reply-To: <1314138000-2049-3-git-send-email-tj@kernel.org>
References: <1314138000-2049-1-git-send-email-tj@kernel.org> <1314138000-2049-3-git-send-email-tj@kernel.org>
From: Paul Menage <paul@paulmenage.org>
Date: Thu, 25 Aug 2011 01:51:39 -0700
X-Google-Sender-Auth: QyVbUn0xj54ux667vlfMCwLphPE
Message-ID: <CALdu-PAj1ZUmB2ixxA6yeppB8MerBGk1cSeQadobH0H4cRSe7Q@mail.gmail.com>
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

While I'm all in favour of making things more consistent, do we need
such a big change?

In particular, making the group flex-array entries contain both a task
and a cgroup appears to be only necessary in order to skip tasks where
new_cgroup == old_cgroup. Can't we get the same effect by simply
leaving all such tasks out of the flex-array in the first place?

Paul

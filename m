Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751243Ab1ILELi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 00:11:38 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:39145 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745Ab1ILELh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 00:11:37 -0400
MIME-Version: 1.0
In-Reply-To: <1315159280-25032-1-git-send-email-htejun@gmail.com>
References: <1315159280-25032-1-git-send-email-htejun@gmail.com>
From: Paul Menage <paul@paulmenage.org>
Date: Sun, 11 Sep 2011 21:11:16 -0700
X-Google-Sender-Auth: vsmOOGENmNAO75jV7uiY977MB1w
Message-ID: <CALdu-PDP6hOBP7L8CGoxGZYfUCPnwic+ZuX9tLb9088V3b0V-A@mail.gmail.com>
Subject: Re: [PATCHSET cgroup] extend threadgroup locking
To: Tejun Heo <htejun@gmail.com>
Cc: rjw@sisk.pl, lizf@cn.fujitsu.com, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
        fweisbec@gmail.com, matthltc@us.ibm.com, akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 4, 2011 at 11:01 AM, Tejun Heo <htejun@gmail.com> wrote:
> Hello,
>
> cgroup currently only blocks new threads from joining the target
> threadgroup during migration, and on-going migration could race
> against exec and exit leading to interesting problems - the symmetry
> between various attach methods, task exiting during method execution,
> ->exit() racing against attach methods, migrating task switching basic
> properties during exec and so on.
>
> This patchset extends threadgroup locking such that it covers all
> operations which can alter the threadgroup - fork, exit and exec, and
> update cgroup to take advantage of it.  rwsem read ops are added to
> exit path but exec is excluded by grabbing the existing
> cred_guard_mutex from threadgroup locking helper.
>
> This makes threadgroup locking complete and resolves cgroup issues
> stemming from the target taskset being unstable.
>
> This patchset is on top of the current pm-freezer + "freezer: fixes &
> simplifications" patchset and contains the following four patches.
> Patch list and diffstat follow.
>
> Thanks.
>
>  [PATCH 1/4] cgroup: change locking order in attach_task_by_pid()
>  [PATCH 2/4] threadgroup: rename signal->threadgroup_fork_lock to
>  [PATCH 3/4] threadgroup: extend threadgroup_lock() to cover exit and
>  [PATCH 4/4] cgroup: always lock threadgroup during migration
>

Looks like a nice cleanup from the cgroups point of view. Hopefully
Oleg or other folks who have a handle on the performance impact of the
changes in the exit/exec code are happy with it.

Acked-by: Paul Menage <paul@paulmenage.org>

Thanks,
Paul

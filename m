Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757597Ab2AROEc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 09:04:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59819 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757529Ab2AROEb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 09:04:31 -0500
Date: Wed, 18 Jan 2012 14:58:09 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Tejun Heo <tj@kernel.org>, Andrew Vagin <avagin@openvz.org>,
        Vasiliy Kulikov <segoon@openwall.com>
Subject: Re: [RFC] fs, proc: Introduce /proc/<pid>/task/<tid>/children
	entry v6
Message-ID: <20120118135809.GA10105@redhat.com>
References: <20120116153231.GF2998@moon> <4F15EA53.8030405@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F15EA53.8030405@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/17, KOSAKI Motohiro wrote:
>
> (1/16/12 10:32 AM), Cyrill Gorcunov wrote:
>> When we do checkpoint of a task we need to know the list of children
>> the task, has but there is no easy and fast way to generate reverse
>> parent->children chain from arbitrary<pid>  (while a parent pid is
>> provided in "PPid" field of /proc/<pid>/status).
>>
>> So instead of walking over all pids in the system (creating one big process
>> tree in memory, just to figure out which children a task has) -- we add
>> explicit /proc/<pid>/task/<tid>/children entry, because the kernel already has
>> this kind of information but it is not yet exported.
>
> I doubt this is good idea. It move some complexity to userland, but not reduce.
> Again, if we add this interface, it should help pstree like process traversal
> tools. Bare task hierarchy shouldn't be exposed userland. I believe users need
> sub process, not sub threads.

IOW, you mean that the reading from 'children' should list all children
of the whole thread group. Yes, we discussed this before a bit.

In this case this file should live in /proc/pid/, not in /proc/pid/task/tid.
But this doesn't allow to restore the hierarchy correctly, you need to know
the parent thread. So I think /proc/pid/tasks/tid/children is still needed.
And I think it does help pstree-like apps, just they need to look into task/.

As for /proc/pid/children, may be we can add it later. But this is not that
simple. The problem is the threaded reparenting, we do not want to list the
same child twice.

Oleg.


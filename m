Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932470Ab2B1RSX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 12:18:23 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:50005 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932426Ab2B1RSS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 12:18:18 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of siddhesh.poyarekar@gmail.com designates 10.236.155.6 as permitted sender) smtp.mail=siddhesh.poyarekar@gmail.com; dkim=pass header.i=siddhesh.poyarekar@gmail.com
MIME-Version: 1.0
In-Reply-To: <20120228170436.GA9698@redhat.com>
References: <20120228170436.GA9698@redhat.com>
Date: Tue, 28 Feb 2012 22:48:18 +0530
Message-ID: <CAAHN_R1hmJt4zCxGAL7z2-9URmWUFwwV9pcqkdvQZodpunEJjQ@mail.gmail.com>
Subject: Re: + procfs-mark-thread-stack-correctly-in-proc-pid-maps.patch added
 to -mm tree
From: Siddhesh Poyarekar <siddhesh.poyarekar@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Jamie Lokier <jamie@shareable.org>, Mike Frysinger <vapier@gentoo.org>,
        Alexey Dobriyan <adobriyan@gmail.com>, Matt Mackall <mpm@selenic.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 28, 2012 at 10:34 PM, Oleg Nesterov <oleg@redhat.com> wrote:
>> +int vm_is_stack(struct task_struct *task,
>> +                           struct vm_area_struct *vma, int in_group)
>> +{
>> +     if (vm_is_stack_for_task(task, vma))
>> +             return 1;
>> +
>> +     if (in_group) {
>> +             struct task_struct *t = task;
>> +             while_each_thread(task, t) {
>> +                     if (vm_is_stack_for_task(t, vma))
>> +                             return 1;
>> +             }
>> +     }
>> +
>> +     return 0;
>> +}
>
> This is obviously wrong, while_each_thread() is not safe without
> tasklist or siglock or rcu.

I have fixed this in my git stash. I'll submit once I get to work on
Mike Frysinger's idea of marking stacks with their tids and see if it
breaks anything.

-- 
Siddhesh Poyarekar
http://siddhesh.in

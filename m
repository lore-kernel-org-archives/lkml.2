Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757241Ab1ELKnJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 06:43:09 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:53892 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756023Ab1ELKnH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 06:43:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=oVNf8zLOc4k40Z5DnlTk9D0zHerz8Qd370+hFSD4FW3PYLCprdnS0Y5i4jz0AWZcRT
         pv7y7DVlxIm9uyYHPD0iEZdvIYhEY5kd/P4bk4osihcOfJoA8ugQV5EumaQvui8SgdZP
         uc2VLIVadeSt4piUGkyEnxsloLOa4nMTscZLM=
MIME-Version: 1.0
In-Reply-To: <1305147776.2883.1.camel@work-vm>
References: <1305073386-4810-1-git-send-email-john.stultz@linaro.org>
	<1305073386-4810-3-git-send-email-john.stultz@linaro.org>
	<BANLkTikXyqddLbQKyDYFrAwq9DamDj--AQ@mail.gmail.com>
	<1305147776.2883.1.camel@work-vm>
Date: Thu, 12 May 2011 18:43:05 +0800
Message-ID: <BANLkTikxcfGYAmKf5QEAwJjDLdo6_k6zaw@mail.gmail.com>
Subject: Re: [PATCH 2/3] printk: Add %ptc to safely print a task's comm
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: John Stultz <john.stultz@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>, "Ted Ts'o" <tytso@mit.edu>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 12, 2011 at 5:02 AM, John Stultz <john.stultz@linaro.org> wrote:
> On Wed, 2011-05-11 at 17:33 +0800, Américo Wang wrote:
>> On Wed, May 11, 2011 at 8:23 AM, John Stultz <john.stultz@linaro.org> wrote:
>> > Acessing task->comm requires proper locking. However in the past
>> > access to current->comm could be done without locking. This
>> > is no longer the case, so all comm access needs to be done
>> > while holding the comm_lock.
>> >
>> > In my attempt to clean up unprotected comm access, I've noticed
>> > most comm access is done for printk output. To simpify correct
>> > locking in these cases, I've introduced a new %ptc format,
>> > which will safely print the corresponding task's comm.
>> >
>> > Example use:
>> > printk("%ptc: unaligned epc - sending SIGBUS.\n", current);
>> >
>>
>> Why do you hide current->comm behide printk?
>> How is this better than printk("%s: ....", task_comm(current)) ?
>
> So to properly access current->comm, you need to hold the task-lock (or
> with my new patch set, the comm_lock). Rather then adding locking to all
> the call sites that printk("%s ...", current->comm), I'm suggesting we
> add a new %ptc method which will handle the locking for you.
>

Sorry, I meant why not adding the locking into a wrapper function,
probably get_task_comm() and let the users to call it directly?

Why is %ptc better than

char comm[...];
get_task_comm(comm, current);
printk("%s: ....", comm);

?

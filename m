Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756576Ab2JIRlO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 13:41:14 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:63927 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756415Ab2JIRlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 13:41:12 -0400
MIME-Version: 1.0
In-Reply-To: <20121009162925.GA6517@redhat.com>
References: <1349603358-1085282-1-git-send-email-avagin@openvz.org>
	<20121007190118.GA16068@redhat.com>
	<CANaxB-w+KkhzTQVie=9PE8LJtazqvh+JducTcDmXvH+ZA4oO0A@mail.gmail.com>
	<20121009162925.GA6517@redhat.com>
Date: Tue, 9 Oct 2012 21:41:10 +0400
Message-ID: <CANaxB-xymHL8q8-yjCXQrL0fH7AKk0d4xV_AL77NFKYD=cAdMA@mail.gmail.com>
Subject: Re: [PATCH] [RFC] pidns: don't zap processes several times
From: Andrey Wagin <avagin@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Pavel Emelyanov <xemul@parallels.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/10/9 Oleg Nesterov <oleg@redhat.com>:
> On 10/08, Andrey Wagin wrote:
>>
>> 2012/10/7 Oleg Nesterov <oleg@redhat.com>:
>> >
>> > Perhaps we should MAX_PID_NS_LEVEL instead?
>>
>> Yes, we can.
>>
>> Could I just define MAX_PID_NS_LEVEL in a code:
>> #define MAX_PID_NS_LEVEL ((PAGE_SIZE - offsetof(struct pid, numbers))
>> / sizeof(struct upid))
>
> Or even less. But looks reasonable.
>
>> Or should it be added in a config?
>
> Personally I think that "define" is fine, we can add config/sysctl
> later if needed.

Ok, I'm going to send a patch.

>
>
> Hmm. This is off-topic, but...
>
>         create_pid_namespace:
>
>                 unsigned int level = parent_pid_ns->level + 1;
>                 ns->pid_cachep = create_pid_cachep(level + 1);

Yes, it's correct, because pid->numbers[ns->level] should be valid, so
 a size of an array pid->numbers should be (level + 1).

/*
....
 * @nr_ids: the number of numerical ids this pid will have to carry
 */
static struct kmem_cache *create_pid_cachep(int nr_ids)

>
> is it correct? is seems that only one "+ 1" is needed?
>
> Oleg.
>

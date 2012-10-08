Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754249Ab2JHRKe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 13:10:34 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:44455 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752952Ab2JHRK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 13:10:29 -0400
MIME-Version: 1.0
In-Reply-To: <20121007190118.GA16068@redhat.com>
References: <1349603358-1085282-1-git-send-email-avagin@openvz.org>
	<20121007190118.GA16068@redhat.com>
Date: Mon, 8 Oct 2012 21:10:28 +0400
Message-ID: <CANaxB-w+KkhzTQVie=9PE8LJtazqvh+JducTcDmXvH+ZA4oO0A@mail.gmail.com>
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

2012/10/7 Oleg Nesterov <oleg@redhat.com>:
> On 10/07, Andrew Vagin wrote:
>>
>> I wrote a test program. It does clone(CLONE_NEWPID | CLONE_VM) and
>> sleep(), a new task repeates the same actions. This program creates
>> 4000 tasks. When I tried to kill all this processes, a system was
>> inaccessible for some minutes.
>
> So this creates 4000 nested namespaces? Not sure this really needs the
> fix... The size of pid would be more than 4000 * sizeof(struct upid).
>
> Perhaps we should MAX_PID_NS_LEVEL instead?

Yes, we can.

Could I just define MAX_PID_NS_LEVEL in a code:
#define MAX_PID_NS_LEVEL ((PAGE_SIZE - offsetof(struct pid, numbers))
/ sizeof(struct upid))

Or should it be added in a config?
My opinion is that MAX_PID_NS_LEVEL can be defined, it will be 126 on
x86_64. I don't know a usecase for which, it will be not enough. When
someone finds a reasonable use case, it can be changed.

>
> As for the patch, it looks correct at first glance. But,

I agree with all your comments.

Thanks.

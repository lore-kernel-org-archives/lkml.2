Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756320Ab1EGWjf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 May 2011 18:39:35 -0400
Received: from smtp6-g21.free.fr ([212.27.42.6]:42100 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756089Ab1EGWjd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 May 2011 18:39:33 -0400
Message-ID: <4DC5CA16.2070103@free.fr>
Date: Sun, 08 May 2011 00:39:18 +0200
From: Daniel Lezcano <daniel.lezcano@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        jamal <hadi@cyberus.ca>, Linux Containers <containers@lists.osdl.org>,
        Renato Westphal <renatowestphal@gmail.com>
Subject: Re: [PATCH 2/7] ns: Introduce the setns syscall
References: <m1tyd7p7tq.fsf@fess.ebiederm.org> <1304735101-1824-1-git-send-email-ebiederm@xmission.com> <1304735101-1824-2-git-send-email-ebiederm@xmission.com>
In-Reply-To: <1304735101-1824-2-git-send-email-ebiederm@xmission.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/07/2011 04:24 AM, Eric W. Biederman wrote:
> With the networking stack today there is demand to handle
> multiple network stacks at a time.  Not in the context
> of containers but in the context of people doing interesting
> things with routing.
>
> There is also demand in the context of containers to have
> an efficient way to execute some code in the container itself.
> If nothing else it is very useful ad a debugging technique.
>
> Both problems can be solved by starting some form of login
> daemon in the namespaces people want access to, or you
> can play games by ptracing a process and getting the
> traced process to do things you want it to do. However
> it turns out that a login daemon or a ptrace puppet
> controller are more code, they are more prone to
> failure, and generally they are less efficient than
> simply changing the namespace of a process to a
> specified one.
>
> Pieces of this puzzle can also be solved by instead of
> coming up with a general purpose system call coming up
> with targed system calls perhaps socketat that solve
> a subset of the larger problem.  Overall that appears
> to be more work for less reward.
>
> int setns(int fd, int nstype);
>
> The fd argument is a file descriptor referring to a proc
> file of the namespace you want to switch the process to.
>
> In the setns system call the nstype is 0 or specifies
> an clone flag of the namespace you intend to change
> to prevent changing a namespace unintentionally.
>
> v2: Most of the architecture support added by Daniel Lezcano<dlezcano@fr.ibm.com>
> v3: ported to v2.6.36-rc4 by: Eric W. Biederman<ebiederm@xmission.com>
> v4: Moved wiring up of the system call to another patch
>
> Signed-off-by: Eric W. Biederman<ebiederm@xmission.com>
> ---

Acked-by: Daniel Lezcano <daniel.lezcano@free.fr>

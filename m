Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756859Ab1KXRgQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 12:36:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51199 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752291Ab1KXRgP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 12:36:15 -0500
Date: Thu, 24 Nov 2011 18:31:21 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Pavel Emelyanov <xemul@parallels.com>
Cc: Tejun Heo <tj@kernel.org>, Pedro Alves <pedro@codesourcery.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        James Bottomley <jbottomley@parallels.com>
Subject: Re: [RFC][PATCH 0/3] fork: Add the ability to create tasks with
	given pids
Message-ID: <20111124173121.GA23260@redhat.com>
References: <4EC4F2FB.408@parallels.com> <201111221204.39235.pedro@codesourcery.com> <20111122153326.GD322@google.com> <201111231620.45440.pedro@codesourcery.com> <20111123162417.GE25780@google.com> <4ECD3946.1030503@parallels.com> <4ECD542C.7010705@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ECD542C.7010705@parallels.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/24, Pavel Emelyanov wrote:
>
> Hm... Started testing this stuff and thought about Pedro's wish to use this
> in gdb one more time :(
>
> The thing is, that we (in checkpoint/restore) are going to use this sysctl
> when creating a pid namespace from scratch, thus having full control over
> all the forks happening in this namespace.
>
> But when it comes to the ability for gdb to create a task with a given pid in
> a _living_ namespace this solution simply won't work! It doesn't guarantee,
> that after setting the last_pid via sysctl this last_pid stays the same at
> the time we do call fork()/clone(). Because there are other tasks that can call
> fork themselves ignoring any lask_pid locking we can play with.

Sure. ->last_pid is a hint, nothing more.

But nothing can work reliably on the running system. Even if we can't
race with another fork(), the required pid_nr can be already in use.

Oleg.


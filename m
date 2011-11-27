Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755784Ab1K0Q3y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 11:29:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42349 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755662Ab1K0Q3x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 11:29:53 -0500
Date: Sun, 27 Nov 2011 17:24:56 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Pedro Alves <pedro@codesourcery.com>
Cc: Pavel Emelyanov <xemul@parallels.com>, Tejun Heo <tj@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        James Bottomley <jbottomley@parallels.com>
Subject: Re: [RFC][PATCH 0/3] fork: Add the ability to create tasks
	with?given pids
Message-ID: <20111127162456.GA5674@redhat.com>
References: <201111221204.39235.pedro@codesourcery.com> <20111125165409.GA19238@redhat.com> <4ECFCA5E.1020307@parallels.com> <201111252236.40246.pedro@codesourcery.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201111252236.40246.pedro@codesourcery.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/25, Pedro Alves wrote:
>
> From the perspective of a client that is
> going to use this on a live system, CLONE_CHILD_USEPIDS seems a little better,
> in that the pid race is only against another task reusing the same pid,

Yes. Except you can't use on a live system at all. It simply doesn't
work after the first "normal" clone() without CLONE_CHILD_USEPIDS.

Although we can probably allow CLONE_CHILD_USEPIDS for CAP_SYS_ADMIN.

> while with setting last_pid, you have a try/whoops-not-the-pid-I-want/kill/retry/rinse/repeat/
> loop racing against all fork/clone's in the system,

Yes, setting last_pid can race with another fork(). I agree this
sucks. But simple ;)

Oleg.


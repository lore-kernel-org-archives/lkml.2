Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755579Ab2LSQee (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 11:34:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23128 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754264Ab2LSQe0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 11:34:26 -0500
Date: Wed, 19 Dec 2012 17:34:28 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Neil Horman <nhorman@tuxdriver.com>, Pavel Emelyanov <xemul@parallels.com>,
        Daniel Berrange <berrange@redhat.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: +
	core_pattern-set-core-helpers-root-and-namespace-to-crashing-process
	.patch added to -mm tree
Message-ID: <20121219163428.GB17514@redhat.com>
References: <20121217123428.GA1957@redhat.com> <20121217150559.GD25322@hmsreliant.think-freely.org> <20121217160408.GA20166@redhat.com> <20121217183925.GE25322@hmsreliant.think-freely.org> <20121218200604.GA28834@redhat.com> <20121218201900.GA10059@hmsreliant.think-freely.org> <874njj3x9d.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <874njj3x9d.fsf@xmission.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/18, Eric W. Biederman wrote:
>
> Neil Horman <nhorman@tuxdriver.com> writes:
>
> > On Tue, Dec 18, 2012 at 09:06:04PM +0100, Oleg Nesterov wrote:
> >>
> >> Yes, and we probably want to change pid_ns as well. But afaics currently
> >> this is not possible, even setns can't do this.
>
> The code for setns to change the pid namespace just merged.

Yes... I see pidns_install() after git pull... And it seems that
unshare(NEWPID) should work too...

So in general task_active_pid_ns() is no longer equal to nsproxy->pid_ns.
Oh, I can't understand how this can be right ;)

> Oleg I copied you on that code when I put it up for review.  Did I use
> the wrong email address?

Probably, I didn't see any email. I'll try to read the new code later.
I simply can't understand what will happen if, say, the task does
clone(CLONE_THREAD) after unshare(NEWPID)...

Oleg.


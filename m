Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754040Ab2FXPfV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2012 11:35:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15058 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751972Ab2FXPfT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2012 11:35:19 -0400
Date: Sun, 24 Jun 2012 17:33:10 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        ". James Morris" <jmorris@namei.org>,
        linux-security-module@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: deferring __fput()
Message-ID: <20120624153310.GB24596@redhat.com>
References: <1340369098.2464.20.camel@falcor> <20120623092049.GH14083@ZenIV.linux.org.uk> <20120623194505.GI14083@ZenIV.linux.org.uk> <20120623203800.GA10306@redhat.com> <20120623210141.GK14083@ZenIV.linux.org.uk> <20120624041652.GN14083@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120624041652.GN14083@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/24, Al Viro wrote:
>
> BTW, I suspect that we really want to move exit_task_work() down past the
> calls of exit_mm()/exit_files()

Yes, probably. But I do not know how far we should move it.

> (and lose the PF_EXITING check in
> task_work_add(), making that ordering responsibility of callers).

No, we can't do this?

OK, perhaps we can check something else instead of PF_EXITING.
But somehow we should ensuree that if task_work_add(twork) succeeds,
then twork->func() will be called. IOW, if task_work_add() races with
the exiting task, it should not succeed after exit_task_work().

> I'm not 100% sure about that one - if you have planned task_work users
> relying on e.g. task->mm still being there when callback runs,

No, I didn't.

Oleg.


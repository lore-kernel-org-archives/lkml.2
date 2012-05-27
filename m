Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752207Ab2E0TMK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 15:12:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8240 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751778Ab2E0TMG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 15:12:06 -0400
Date: Sun, 27 May 2012 21:10:32 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Louis Rilling <louis.rilling@kerlabs.com>,
        Mike Galbraith <efault@gmx.de>
Subject: [PATCH v2 -mm 0/1] pidns: find_new_reaper() can no longer switch
	to init_pid_ns.child_reaper
Message-ID: <20120527191032.GB13929@redhat.com>
References: <20120518123911.GA417@redhat.com> <87zk95kper.fsf@xmission.com> <20120521124414.GA20391@redhat.com> <87d35x5ank.fsf_-_@xmission.com> <20120522122315.c3f2118c.akpm@linux-foundation.org> <20120523145239.GA20378@redhat.com> <20120525151526.GA13111@redhat.com> <20120525155941.GA16885@redhat.com> <20120525160008.GB16885@redhat.com> <87pq9sdjhn.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87pq9sdjhn.fsf@xmission.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/25, Eric W. Biederman wrote:
>
> Oleg Nesterov <oleg@redhat.com> writes:
>
> > Change find_new_reaper() to use pid_ns->parent->child_reaper.
>
> Oleg this is a good catch for a real problem.  However I disagree about
> the fix.
>
> We should make unhash_process say:
> 	if ((task_active_pid_ns(parent)->child_reaper == parent) &&

Damn, I hate you^W^W^W thanks a lot Eric.

Indeed! Not only this is more simple, this is just more natural!

> And we should just set delete the code after zap_pid_ns_processes

Yes, this is clear.

> We could set pid_ns.child_reaper to NULL after that
> but why bother.

Agreed. Plus I do not think that pid_ns.child_reaper == NULL looks
good even if this doesn't matter currently.

OK, please see v2. Note that I moved detach_pid(PIDTYPE_PID) back.
Yes, yes, there is no real reason to do this. Just I think that if
someone look at these changes later, it is not easy to understand
why it was moved down.

Thanks!

Oleg.


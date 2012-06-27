Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754645Ab2F0Sjh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 14:39:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32006 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751396Ab2F0Sjg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 14:39:36 -0400
Date: Wed, 27 Jun 2012 20:37:21 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        ". James Morris" <jmorris@namei.org>,
        linux-security-module@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        David Howells <dhowells@redhat.com>
Subject: [PATCH 0/4] Was: deferring __fput()
Message-ID: <20120627183721.GA23086@redhat.com>
References: <1340369098.2464.20.camel@falcor> <20120623092049.GH14083@ZenIV.linux.org.uk> <20120623194505.GI14083@ZenIV.linux.org.uk> <20120623203800.GA10306@redhat.com> <20120623210141.GK14083@ZenIV.linux.org.uk> <20120624041652.GN14083@ZenIV.linux.org.uk> <20120624153310.GB24596@redhat.com> <20120625060357.GT14083@ZenIV.linux.org.uk> <20120625151812.GA16062@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120625151812.GA16062@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/25, Oleg Nesterov wrote:
>
> And if it always takes ->pi_lock we do not need the new PF_ or something
> else, exit_task_work() can set task->task_works = NO_MORE under ->pi_lock
> (task_work_run() can check PF_EXITING), and task_work_add() ensures that
> task_works != NO_MORE.
>
> What do you think?

It is not clear to me if you agree or not. So I am simply sending the
patches I have.

Feel free to ignore or re-do.

Seriously, why should we add 2 pointers into task_struct? Sure, this
is minor, but still... But perhaps task_work.c should not play tricks
with the circular list, task_work_run() can reverse the list as you
initially suggested.

Also, I am not sure about "define rcu_head callback_head", this series
doesn't do this. But again, up to you.

Oleg.


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755331Ab2F1Qs2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 12:48:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2715 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751293Ab2F1Qs0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 12:48:26 -0400
Date: Thu, 28 Jun 2012 18:45:39 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        ". James Morris" <jmorris@namei.org>,
        linux-security-module@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 0/4] Was: deferring __fput()
Message-ID: <20120628164539.GA26350@redhat.com>
References: <20120623194505.GI14083@ZenIV.linux.org.uk> <20120623203800.GA10306@redhat.com> <20120623210141.GK14083@ZenIV.linux.org.uk> <20120624041652.GN14083@ZenIV.linux.org.uk> <20120624153310.GB24596@redhat.com> <20120625060357.GT14083@ZenIV.linux.org.uk> <20120625151812.GA16062@redhat.com> <20120627183721.GA23086@redhat.com> <20120628043836.GW14083@ZenIV.linux.org.uk> <20120628162253.GA25357@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120628162253.GA25357@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Forgot to mention...

And I still think that task_work_add() should not succeed unconditionally,
it synchronize with exit_task_work(). Otherwise keyctl_session_to_parent()
is broken.

On 06/28, Oleg Nesterov wrote:
>
> On 06/28, Al Viro wrote:
> >
> > The list removal logics in mine looks really ugly ;-/
>
> Basically the code is almost the same as mine.
>
> But task_work_add() can be simplified a bit, no need to check
> last != NULL twice.
>
> 	last = task->task_works ?: twork;
> 	task->last_twork = twork;
> 	twork->next = last->next;	/* XXX */
> 	last->next = twork;
>
> If ->task_works == NULL, then XXX is meaningless but safe.
>
> Oleg.


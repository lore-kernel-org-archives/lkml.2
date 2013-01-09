Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932379Ab3AIRtr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 12:49:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1757 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932148Ab3AIRtp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 12:49:45 -0500
Date: Wed, 9 Jan 2013 18:49:22 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Michel Lespinasse <walken@google.com>
Cc: David Howells <dhowells@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Salman Qazi <sqazi@google.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: rwlock_t unfairness and tasklist_lock
Message-ID: <20130109174922.GA31211@redhat.com>
References: <CANN689HRmVTLCjNL9c=JqhWy5F5vwr=A7coo3TVKLZGSVUpQjw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANN689HRmVTLCjNL9c=JqhWy5F5vwr=A7coo3TVKLZGSVUpQjw@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/08, Michel Lespinasse wrote:
>
> Like others before me, I have discovered how easy it is to DOS a
> system by abusing the rwlock_t unfairness and causing the
> tasklist_lock read side to be continuously held

Yes. Plus it has perfomance problems.

It should die. We still need the global lock to protect, say,
init_task.tasks list, but otherwise we need the per-process locking.

> - Would there be any fundamental objection to implementing a fair
> rwlock_t and dealing with the reentrancy issues in tasklist_lock ? My
> proposal there would be along the lines of:

I don't really understand your proposal in details, but until we kill
tasklist_lock, perhaps it makes sense to implement something simple, say,
write-biased rwlock and add "int task_struct->tasklist_read_lock_counter"
to avoid the read-write-read deadlock.

Oleg.


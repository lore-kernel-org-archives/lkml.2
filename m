Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754499Ab0KIU3P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 15:29:15 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:60695 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751831Ab0KIU3G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 15:29:06 -0500
Date: Tue, 9 Nov 2010 12:29:00 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Greg Thelen <gthelen@google.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: INFO: suspicious rcu_dereference_check() usage -
	kernel/pid.c:419 invoked rcu_dereference_check() without protection!
Message-ID: <20101109202900.GV4032@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <xr93fwwbdh1d.fsf@ninji.mtv.corp.google.com>
 <20101107182028.GZ15561@linux.vnet.ibm.com>
 <20101108151509.GA3702@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101108151509.GA3702@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 08, 2010 at 04:15:09PM +0100, Oleg Nesterov wrote:
> On 11/07, Paul E. McKenney wrote:
> >
> > On Tue, Oct 12, 2010 at 12:08:46AM -0700, Greg Thelen wrote:
> > >
> > > ioprio_set() contains a comment warning against of usage of
> > > rcu_read_lock() to avoid this warning:
> > > 	/*
> > > 	 * We want IOPRIO_WHO_PGRP/IOPRIO_WHO_USER to be "atomic",
> > > 	 * so we can't use rcu_read_lock(). See re-copy of ->ioprio
> > > 	 * in copy_process().
> > > 	 */
> > >
> > > So I'm not sure what the best fix is.
> 
> (please note that "we can't use rcu_read_lock()" actually meant
>  rcu_read_lock() is not _enough_)
> 
> > I must defer to Oleg, who wrote the comment.  But please see below.
> 
> I added this comment to explain some oddities in copy_process().
> Nobody confirmed my understanding was correct ;)
> 
> In any case, this comment doesn't look right today. This code was
> changed by fd0928df98b9578be8a786ac0cb78a47a5e17a20
> "ioprio: move io priority from task_struct to io_context" after that,
> tasklist can't help to make sys_ioprio_set(IOPRIO_WHO_PGRP) atomic.
> 
> I think tasklist_lock can be removed now.
> 
> And, as Paul pointed out, we need rcu_read_lock() anyway, it was
> already added by Sergey.

Thank you, Oleg!  Greg, would you be willing to update your patch
to remove the comment?  (Perhaps tasklist_lock as well...)

							Thanx, Paul

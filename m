Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756928Ab2EJHmX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 03:42:23 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:48840 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756066Ab2EJHmV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 03:42:21 -0400
Date: Thu, 10 May 2012 09:42:15 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        LKML <linux-kernel@vger.kernel.org>, anton@samba.org,
        Arnd Bergmann <arnd@arndb.de>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mike Travis <travis@sgi.com>, Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PULL] cpumask: finally make them variable size w/
 CPUMASK_OFFSTACK.
Message-ID: <20120510074215.GA28395@gmail.com>
References: <87ipg5c2bk.fsf@rustcorp.com.au>
 <20120509084453.GA6429@gmail.com>
 <87fwb8dgkn.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87fwb8dgkn.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Rusty Russell <rusty@rustcorp.com.au> wrote:

> Mainly because I didn't want to disturb the archs which don't 
> care at all about large cpumasks.  After all, putting a struct 
> cpumask on the stack is pretty convenient.

Yes.

> But we could add a new arch config which removes it, and set 
> it from x86.

Could we just use a single cpumask type, cpumask_t or so, which 
would be the *only* generic method to use cpumasks?

(Current cpumask_t would move to cpumask_full_t.)

This would be the 'final' destiation for the cpumask code: the 
natural type to use in new code is cpumask_t, while in special 
cases we could use cpumask_full_t - but the name signals that 
it's a potentially large structure.

On architectures that don't worry about large cpumasks (yet ...) 
cpumask_t and cpumask_full_t maps to the same thing, so there's 
no difference.

This would make things more natural IMO.

There would be no 'struct cpumask'. (and 'cpumask_var_t' would 
disappear too due to the rename.)

Thoughts?

	Ingo

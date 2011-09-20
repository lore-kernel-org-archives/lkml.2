Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751510Ab1ITOnV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 10:43:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14286 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750784Ab1ITOnU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 10:43:20 -0400
Date: Tue, 20 Sep 2011 16:39:20 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "Serge E. Hallyn" <serge@hallyn.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: "Serge E. Hallyn" <serge.hallyn@canonical.com>,
        lkml <linux-kernel@vger.kernel.org>, richard@nod.at,
        "Eric W. Biederman" <ebiederm@xmission.com>, Tejun Heo <tj@kernel.org>
Subject: [PATCH 0/2] (Was: user namespace: make signal.c respect user
	namespaces)
Message-ID: <20110920143920.GA15859@redhat.com>
References: <20110919214531.GA18085@sergelap> <20110920122202.GA26504@redhat.com> <20110920124419.GA10759@hallyn.com> <20110920134108.GA30749@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110920134108.GA30749@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/20, Oleg Nesterov wrote:
>
> On 09/20, Serge E. Hallyn wrote:
> >
> > Quoting Oleg Nesterov (oleg@redhat.com):
> > >
> > > 	static inline uid_t good_name(struct task_struct *from, struct task_struct *to)
> > > 	{
> > > 		// the caller does rcu_read_lock() if needed
> > > 		const struct cred *from_cred = __task_cred(from);
> > > 		return user_ns_map_uid(task_cred_xxx(to, user_ns),
> > > 					from_cred, from_cred->uid);
> > > 	}
> >
> > That looks great, thanks.  I couldn't think it up myself, but now that
> > I see it in your email, I see this would be very valuable in helping
> > make this code more readable  :)
>
> Damn ;) The problem is, "the caller does rcu_read_lock() if needed"
> can't shut up __rcu_dereference_check(). current_cred() passes c == true
> to do this.
>
> This reminds me, __task_cred()->task_is_dead() should go away. Probably
> we can replace it with (__t == current). Otherwise send_signal() needs
> rcu_read_lock() to avoid the warning from lockdep, or the helper needs
> the unconditional rcu_read_lock().

IOW, I think we need 2 simple patches first.

The problem is, I have no idea how can I really test these changes ;)
David, Paul, may be you can review...

Oleg.


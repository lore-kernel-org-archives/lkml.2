Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932782Ab1CIRj0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 12:39:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22990 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932108Ab1CIRjZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 12:39:25 -0500
Date: Wed, 9 Mar 2011 18:30:42 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Roland McGrath <roland@redhat.com>, jan.kratochvil@redhat.com,
        Denys Vlasenko <vda.linux@googlemail.com>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
Subject: Re: PTRACE_SEIZE/INTERRUPT: [RFC] Proposal for ptrace improvements
Message-ID: <20110309173042.GA2936@redhat.com>
References: <20110301152457.GE26074@htj.dyndns.org> <20110307150803.GA16521@redhat.com> <20110309094119.GB27010@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110309094119.GB27010@htj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

On 03/09, Tejun Heo wrote:
>
> Hello, Oleg.
>
> On Mon, Mar 07, 2011 at 04:08:03PM +0100, Oleg Nesterov wrote:
> > Now that we more or less agree with Tejun's ideas,
>
> Yay! I finally succeeded at wearing down everyone.  :-)

Yes, thanks for correcting me, this is what I actually meant ;)

> > And I think there are other reasons. Say, suppose we want to add
> > the options for ATTACH/INTERRUPT. Right now I do not see the need,
> > but who knows.
>
> I think it would actually be better to share the option flags.  The
> two operations (whether implemented as separate operations or not)
> share the interrupting aspect and I think using separate set of
> options can be a bit confusing.  Hmmm... maybe it's actually better to
> make them have different prefixes and let the attach also accept the
> interrupt flags.

Perhaps, I agree with everything. As I said, I don't have a strong
opinion, just some random thoughts.

> > Final note... Previously I thought that we should not (I meant, can
> > not) change the current behaviour of PTRACE_O_TRACECLONE/etc which
> > sends SIGSTOP during the auto-attach. Now I am not sure, probably
> > we can avoid SIGSTOP if the forking task was PTRACE_SEIZE'ed. IOW,
> > perhaps the new ATTACH can have other "side effects". But, otoh,
> > this can complicate the transition to the new requests. Say, you
> > can't simply change strace to use PTRACE_SEIZE without auditing
> > the "-f" code.
>
> We can add attach option SIGSTOP_ON_AUTOATTACH to help the transition
> but then again it requires userland application change anyway so I
> think it would be better to simply enforce the new behavior when the
> new attach is used.  It's not like lack of SIGSTOP is gonna be super
> subtle.

Agreed.

> > And. This is off-topic, but we can also add PTRACE_DETACH_XXX which
> > does not require the stopped tracee. strace certainly needs it,
> > although INTERRUPT can solve most of the problems.
>
> I don't know.  The thing is that guaranteeing the tracee is in
> TASK_TRACED on attach/detach prevents a lot of subtle corner cases.

Agreed, but detach is different. It has to work with the running
tracee anyway.

However,

> Unless there are pretty compelling reasons, I'd like to keep that
> invariant intact.  What else does strace require that can't be
> provided by INTERRUPT + DETACH?

Yes, probably INTERRUPT + DETACH is enough. At least this certainly
solves the most annoying problems. IIRC. Denys can correct me.

Oleg.


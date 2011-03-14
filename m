Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756706Ab1CNBEb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Mar 2011 21:04:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54424 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756668Ab1CNBEa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Mar 2011 21:04:30 -0400
To: Tejun Heo <tj@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>, jan.kratochvil@redhat.com,
        Denys Vlasenko <vda.linux@googlemail.com>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
Subject: Re: [RFC] Proposal for ptrace improvements
References: <20110301152457.GE26074@htj.dyndns.org>
	<20110307204346.19557183C29@magilla.sf.frob.com>
	<20110309102855.GC27010@htj.dyndns.org>
From: fche@redhat.com (Frank Ch. Eigler)
Date: Sun, 13 Mar 2011 21:03:57 -0400
In-Reply-To: <20110309102855.GC27010@htj.dyndns.org> (Tejun Heo's message of "Wed, 9 Mar 2011 11:28:55 +0100")
Message-ID: <y0mtyf6wm0y.fsf@fche.csb>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi -

tj wrote:

> [...]
>> I've said before more than once what I think are the important
>> principles about compatibility that ought to be maintained [...]
> The biggest changes the current ptrace users are gonna see are
> probably the ones from P1 and those are really corner cases - /proc
> state, behavior change visible only to other thread in a multithreaded
> debugger [...]
> Also, ptrace is inherently a very heavy mechanism.  [...]
> If someone is looking for completely transparent light weight
> monitoring [look elsewhere...]
> I skipped a lot of parts but in general I think that you're trying
> to do too much with ptrace.  ptrace has its place which is called
> debugging.  [...]

Take care not to define your problems away by something close to a
false dichotomy: intrusive ptrace vs. transparent tracing.  One needs
transparent enough debugging too, so that the presence of the debugger
does not subvert the occurrence of complex or transient phenomena.
This hazard is especially acute for multithreaded programs.  While
ptrace is known to be an imperfect substrate for multithreaded
debugging, it would be nice not to make it any worse.

Note that I'm not claiming that your current proposals necessarily
would do so, but the argument for treating ptrace as machinery
appropriate only for "heavy-weight diddling" could lead that way.

- FChE

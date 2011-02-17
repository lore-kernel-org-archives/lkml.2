Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932215Ab1BQTlk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 14:41:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24191 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753123Ab1BQTli (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 14:41:38 -0500
Date: Thu, 17 Feb 2011 20:33:24 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: Jan Kratochvil <jan.kratochvil@redhat.com>,
        Denys Vlasenko <vda.linux@googlemail.com>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
Subject: Re: [PATCH 1/1] ptrace: make sure do_wait() won't hang after
	PTRACE_ATTACH
Message-ID: <20110217193324.GA13661@redhat.com>
References: <20110204105343.GA12133@htj.dyndns.org> <20110207174821.GA1237@redhat.com> <20110209141803.GH3770@htj.dyndns.org> <201102132325.55353.vda.linux@googlemail.com> <20110214151340.GP18742@htj.dyndns.org> <AANLkTi=Djwcf9YoUrGtTEOp8W_YhsefzrNhMxVhtw_Lp@mail.gmail.com> <20110216215157.GA6054@host1.dyn.jankratochvil.net> <20110217164906.GA5167@redhat.com> <20110217185847.5E9D31806EE@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110217185847.5E9D31806EE@magilla.sf.frob.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/17, Roland McGrath wrote:
>
> > OK... Yes, perhaps PTRACE_{DETACH,CONT}(SIGCONT) should override
> > SIGNAL_STOP_STOPPED too. This makes sense, and this connects to
> > the problem with SIGNAL_STOP_DEQUEUED I mentioned above.
>
> It's not at all clear this really does make sense.

Yes, I already changed my mind, see another email from me ;)

> I think this may
> reflect a (common) misunderstanding of what the SIGCONT semantics are
> (aside from ptrace).  Resuming the process is not the action of
> delivering SIGCONT.

Yes. I was confused by "for a naive/legacy debugger", somehow I missed
this doesn't work with the current code anyway, no need to add this
feature.

> So IMHO what makes most sense given what all the normal semantics are
> is that PTRACE_CONT,SIGCONT does nothing magical, and generating a
> fresh SIGCONT (i.e. kill) is the way you resume from job control stop.

Exactly.

All other things we discussed are "small details". This is the most
noticeable change.

Oleg.


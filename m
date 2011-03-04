Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759855Ab1CDQjU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 11:39:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:31839 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759785Ab1CDQjT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 11:39:19 -0500
Date: Fri, 4 Mar 2011 17:30:29 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Tejun Heo <tj@kernel.org>, Roland McGrath <roland@redhat.com>,
        jan.kratochvil@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
Subject: Re: [RFC] Proposal for ptrace improvements
Message-ID: <20110304163029.GB24871@redhat.com>
References: <20110301152457.GE26074@htj.dyndns.org> <20110303173422.GA27960@redhat.com> <20110303202246.GB32152@redhat.com> <AANLkTikeCzr-OGkmaaortS7_rR+JCM9B6aJV0c52EMbE@mail.gmail.com> <20110304134126.GL20499@htj.dyndns.org> <AANLkTikLd2Kg9Pz+5eLd_irdxoKdrR9qPj8yixeTfvaM@mail.gmail.com> <20110304140745.GP20499@htj.dyndns.org> <AANLkTina7D3QffUK7vYvc3aVTvbcJQqm8VgQP3xJKYdw@mail.gmail.com> <20110304161321.GB23553@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110304161321.GB23553@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/04, Oleg Nesterov wrote:
>
> On 03/04, Denys Vlasenko wrote:
> >
> > # time sh -c './strace -e trace=exit_group ls -lR /usr/share >/dev/null'
> > exit_group(0)                           = ?
> > real	0m47.695s
> > user	0m3.965s
> > sys	0m29.047s
> >
> > strace with PTRACE_GETSIGINFO:
> >
> > # time sh -c './strace -e trace=exit_group ls -lR /usr/share >/dev/null'
> > exit_group(0)                           = ?
> > real	0m51.958s
> > user	0m3.899s
> > sys	0m31.584s
>
> I am wondering how much ptrace_check_attach()->wait_task_inactive()
> contributes... it can sleep.
>
> And note that many ptrace requests do not really need this,
> PTRACE_GETSIGINFO in particular.

could you replace the extra PTRACE_GETSIGINFO by invalid request?

Oleg.


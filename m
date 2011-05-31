Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758198Ab1EaTKO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 15:10:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43442 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753160Ab1EaTKN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 15:10:13 -0400
Date: Tue, 31 May 2011 21:08:09 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Denys Vlasenko <vda.linux@googlemail.com>, indan@nul.nu,
        Tejun Heo <tj@kernel.org>, bdonlan@gmail.com,
        linux-kernel@vger.kernel.org, jan.kratochvil@redhat.com,
        akpm@linux-foundation.org
Subject: Re: [PATCH 03/10] ptrace: implement PTRACE_SEIZE
Message-ID: <20110531190809.GA20691@redhat.com>
References: <201105180240.56754.vda.linux@googlemail.com> <20110518095539.GU20624@htj.dyndns.org> <20110523124314.GA7232@redhat.com> <20110524102834.GC10334@htj.dyndns.org> <20110525182919.GB16575@redhat.com> <20110526091401.GD9715@htj.dyndns.org> <20110526150150.GD12525@redhat.com> <20110527182121.GA3212@mtj.dyndns.org> <20110530192255.GB20616@redhat.com> <BANLkTimupSd774N-VBoswOj+Dza=5ofvWQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTimupSd774N-VBoswOj+Dza=5ofvWQ@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/30, Linus Torvalds wrote:
>
> Guys, changing interfaces is not going to help user space. The current ones
> may not be wonderful, but they work.
>
> Making up some new "better" interface would be just worse for users, they
> still need to support the old one anyway.

IOW, you are starting to agree that ptrace is not fixable ;)

On a seriouse note, of course you are right, but what we should do?

Speaking of this particular problem, it is really annoying. The leader
exits, and it even notifies the tracer. For what? waitpid() returns 0
or hangs depending on WNOHANG, any ptrace() request fails with ESRCH.

Ironically, recently I got the bug-report which blaims this behaviour,
although it was mentioned many times during the previous discussions.

I agree, we can't change the current behaviour of WEXITED in this case.

I also agree that if we, say, add WPTRACE_EXITED or change the semantics
of WEXITED when the traced leader is PT_SEIZED, then probably this new
feature won't be used by gdb/etc in the forseeable future.

So what should we do?

OK, this particular problem is minor, perhaps we can simply ignore it
and do not try to help the userspace.

But the same objection applies to any new feature in this area. Say,
PTRACE_INTERRUPT. To me, this request is obviously good/useful and
nobody argued so far. But, will it ever be used by gdb? I am not sure,
but at least we add the possibility.

Oleg.


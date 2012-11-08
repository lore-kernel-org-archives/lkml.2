Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751867Ab2KHMgm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 07:36:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2027 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751118Ab2KHMgl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 07:36:41 -0500
Date: Thu, 8 Nov 2012 13:37:16 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Amnon Shiloh <u3557@miso.sublimeip.com>
Cc: Denys Vlasenko <dvlasenk@redhat.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Chris Evans <scarybeasts@gmail.com>,
        David Howells <dhowells@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>, u3557@dialix.com.au,
        security@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: PT_EXITKILL (Was: pdeath_signal)
Message-ID: <20121108123716.GA20917@redhat.com>
References: <20121107150934.GA27606@redhat.com> <20121108062935.BFF3A592024@miso.sublimeip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121108062935.BFF3A592024@miso.sublimeip.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Amnon,

On 11/08, Amnon Shiloh wrote:
>
> Thanks for the patch, I tried it and it works nicely!

OK, thanks. I'll wait for other comments a bit and then send
the patch to Andrew.

> Also, I just noticed that this new option (PTRACE_O_EXITKILL) is not
> safe with ptrace(PTRACE_TRACEME)+execve, because the parent may die
> before even having a chance to set PTRACE_O_EXITKILL!

Not safe? I guess you meant that PTRACE_O_EXITKILL can't prevent
this race? Yes sure. Or the parent can die before it does
PTRACE_O_EXITKILL.

> However, that's easy to fix by using PTRACE_ATTACH instead.

Or the child can check getppid() == saved_parent_pid after PTRACE_TRACEME.

But if you switch to PTRACE_ATTACH, I'd suggest to use PTRACE_SEIZE.
Note that, in particular, this allows you to specify the options at
attach.

As for PF_NO_SIGSTOP, I'll write another email.

Oleg.


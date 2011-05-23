Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754732Ab1EWMor (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 08:44:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55382 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754271Ab1EWMoq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 08:44:46 -0400
Date: Mon, 23 May 2011 14:43:14 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Denys Vlasenko <vda.linux@googlemail.com>, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, bdonlan@gmail.com
Subject: Re: [PATCH 03/10] ptrace: implement PTRACE_SEIZE
Message-ID: <20110523124314.GA7232@redhat.com>
References: <1305569849-10448-1-git-send-email-tj@kernel.org> <1305569849-10448-4-git-send-email-tj@kernel.org> <201105180240.56754.vda.linux@googlemail.com> <20110518095539.GU20624@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110518095539.GU20624@htj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/18, Tejun Heo wrote:
>
> I've been thinking about Jan's suggestion to make ATTACH and DETACH
> not require tracee to trap. We already have this for DETACH for cases
> where the tracer is killed

Yes, I still think that the new DETACH_XXX request which doesn't need
the stopped tracee makes sense. Yes, we have PTRACE_INTERRUPT. But please
recall the previous discussion, it is possible that the tracee can't
react to PTRACE_INTERRUPT and trap because it waits for other threads
we are tracing.

And. Currently there is no way to detach a zombie leader. Perhaps we
should change do_wait(), but it is not clear what should we do if the
tracer is the real parent (we already discussed this a bit).

> and it seems it wouldn't be too difficult
> to make that happen for ATTACH either

Yes, I think this is simple to do. Do we need this? I leave this up
to you and Jan.

To me personally attach-implies-trap looks more natural, but probably
gdb has another opinion.


Anyway. IIUC, gdb wants the auto-attach-on-clone without the trap,
this is more important but this opens a lot of problems.


> and for that to be truly useful
> I suppose PTRACE_SETOPTIONS shouldn't require trapped state either.

Hmm. Why? we could pass this options along with PTRACE_SEIZE?

> Jan, would that be enough for the use cases you have on mind?

Jan?

Oleg.


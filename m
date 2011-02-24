Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755540Ab1BXPkm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 10:40:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20779 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752477Ab1BXPkl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 10:40:41 -0500
Date: Thu, 24 Feb 2011 16:32:21 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Stas Sergeev <stsp@aknet.ru>
Cc: Linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [path][rfc] add PR_DETACH prctl command
Message-ID: <20110224153221.GA22770@redhat.com>
References: <4D6510A3.90905@aknet.ru> <20110223191442.GA717@redhat.com> <4D656F87.3090005@aknet.ru> <20110224132906.GA15733@redhat.com> <4D6675B0.2010700@aknet.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D6675B0.2010700@aknet.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/24, Stas Sergeev wrote:
>
> I am currently rewriting the patch to solve this all.
> What I am trying to do now, is to reparent directly in prctl(),
> but delay the list_move_tail(&p->sibling, &p->real_parent->children);
> to the wait() call.

Ooh... good luck ;) but I expect this won't be simple. In fact,
I do not understand how it is possible to do this correctly.

>> The problem is that ptrace uses this ->exit_code member as well.
>> Suppose that the (ptraced) task calls PR_DETACH and, say, recieves
>> a signal after that. See ptrace_signal().
> Also do_signal_stop() seems to alter it.

Yes. It is not immediately obvious but this is in fact for ptrace.
Even if this thread is not traced, the tracer can attach later.

> Do you mean right now it can't happen that multiple events
> alter the exit_code, and the parent notices only the last one?

Yes.

> In this case I need to add a separate variable.

I'd suggest you to always report 0 as the exit status. Much simpler.
Then you can do another patch if you really want to report arg2.

Oleg.


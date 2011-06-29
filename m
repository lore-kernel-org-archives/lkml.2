Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757189Ab1F2Q0V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 12:26:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24786 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755198Ab1F2Q0T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 12:26:19 -0400
Message-ID: <4E0B5216.4060403@redhat.com>
Date: Wed, 29 Jun 2011 19:25:58 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, a.p.zijlstra@chello.nl,
        acme@ghostprotocols.net, Will Deacon <will.deacon@arm.com>,
        Jason Wessel <jason.wessel@windriver.com>
Subject: Re: [PATCH 1/3] perf: add context field to perf_event
References: <1309362157-6596-1-git-send-email-avi@redhat.com> <1309362157-6596-2-git-send-email-avi@redhat.com> <20110629160841.GA2032@somewhere>
In-Reply-To: <20110629160841.GA2032@somewhere>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/29/2011 07:08 PM, Frederic Weisbecker wrote:
> On Wed, Jun 29, 2011 at 06:42:35PM +0300, Avi Kivity wrote:
> >  The perf_event overflow handler does not receive any caller-derived
> >  argument, so many callers need to resort to looking up the perf_event
> >  in their local data structure.  This is ugly and doesn't scale if a
> >  single callback services many perf_events.
> >
> >  Fix by adding a context parameter to perf_event_create_kernel_counter()
> >  (and derived hardware breakpoints APIs) and storing it in the perf_event.
> >  The field can be accessed from the callback as event->overflow_handler_context.
> >  All callers are updated.
> >
> >  Signed-off-by: Avi Kivity<avi@redhat.com>
>
> I believe it can micro-optimize ptrace through register_user_hw_breakpoint() because
> we could store the index of the breakpoint that way, instead of iterating through 4 slots.
>

Right, I noticed that while writing the patch.

> Perhaps it can help in arm too, adding Will in Cc.
>
> But for register_wide_hw_breakpoint, I'm not sure. kgdb is the main user, may be Jason
> could find some use of it.

I think an API should not require its users to iterate in their 
callbacks, even if it doesn't affect current users for some reason.

-- 
error compiling committee.c: too many arguments to function


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755232Ab1FEIIL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jun 2011 04:08:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28353 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754458Ab1FEIIG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jun 2011 04:08:06 -0400
Message-ID: <4DEB3952.2070605@redhat.com>
Date: Sun, 05 Jun 2011 11:07:46 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH v1 1/5] perf: add context parameter to perf_event overflow
 handler
References: <1305129333-7456-1-git-send-email-avi@redhat.com>	 <1305129333-7456-2-git-send-email-avi@redhat.com> <1307112115.2353.3392.camel@twins>
In-Reply-To: <1307112115.2353.3392.camel@twins>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/03/2011 05:41 PM, Peter Zijlstra wrote:
> On Wed, 2011-05-11 at 11:55 -0400, Avi Kivity wrote:
> >  +++ b/include/linux/perf_event.h
> >  @@ -709,7 +709,9 @@ struct perf_buffer {
> >
> >   struct perf_sample_data;
> >
> >  -typedef void (*perf_overflow_handler_t)(struct perf_event *, int,
> >  +typedef void (*perf_overflow_handler_t)(void *context,
> >  +                                       struct perf_event *event,
> >  +                                       int,
> >                                          struct perf_sample_data *,
> >                                          struct pt_regs *regs);
> >
> >  @@ -855,6 +857,7 @@ struct perf_event {
> >          u64                             id;
> >
> >          perf_overflow_handler_t         overflow_handler;
> >  +       void                            *overflow_handler_context;
> >
> >   #ifdef CONFIG_EVENT_TRACING
> >          struct ftrace_event_call        *tp_event;
>
> If you're adding a pointer here, then why pass it along in the callback
> thing if it already has the perf_event *?
>
> It seems to me the callback can easily do
> event->overflow_handler_context if it needs the thing.

Makes sense.  Will update.

(I would have preferred a caller-allocated perf_event with 
container_of(), but that's a huge change).

-- 
error compiling committee.c: too many arguments to function


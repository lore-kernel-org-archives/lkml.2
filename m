Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752252Ab1BUW3I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 17:29:08 -0500
Received: from mail-bw0-f51.google.com ([209.85.214.51]:62035 "EHLO
	mail-bw0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751351Ab1BUW3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 17:29:06 -0500
X-Greylist: delayed 474 seconds by postgrey-1.27 at vger.kernel.org; Mon, 21 Feb 2011 17:29:05 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=sIvXL4fbjsiv8jwBQfPRmI1Zn+D1BmJUN2c8UUfEyeVmfwo7XOBDMWwEirmHDOZ909
         QX+DgIVK01kxgkfzLOJMQphWkuArZAKTTl8rf2htM00lNRVHCV/CuIQlp8184TivB+J8
         7Yx6oZ8mHQNOB6pPK+bepDEk3c0e45uYo3mh0=
Date: Mon, 21 Feb 2011 23:21:06 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: David Ahern <daahern@cisco.com>
Cc: linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        acme@ghostprotocols.net, mingo@elte.hu, peterz@infradead.org,
        paulus@samba.org, tglx@linutronix.de
Subject: Re: [PATCH 0/4] perf events: Add realtime clock event and timehist
 option -v2
Message-ID: <20110221222104.GE3583@nowhere>
References: <1298322150-15505-1-git-send-email-daahern@cisco.com>
 <20110221213740.GC3583@nowhere>
 <4D62DC21.4070407@cisco.com>
 <20110221215533.GD3583@nowhere>
 <4D62E2B0.1070607@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D62E2B0.1070607@cisco.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 21, 2011 at 03:09:52PM -0700, David Ahern wrote:
> 
> 
> On 02/21/11 14:55, Frederic Weisbecker wrote:
> > On Mon, Feb 21, 2011 at 02:41:53PM -0700, David Ahern wrote:
> >>
> >>
> >> On 02/21/11 14:37, Frederic Weisbecker wrote:
> >>
> >>> The goal is actually to extend perf script to handle more than just raw data.
> >>> So that it can handle the rest of what we can find in an event: time, ip, stacktraces...
> >>>
> >>> You've added 200 lines in perf report to add the dump support. It wouldn't
> >>> require more to extend perf script to do that. And the result is going to be
> >>> much more powerful.
> >>>
> >>> Look at struct scripting_ops::process_event().
> >>
> >> I actually have a draft of perf-script - essentially duplicating sample
> >> processing done in perf-report. When it got to the point of having to
> >> add a lot of code -- other features essentially -- just to get it to the
> >> point of being ready for this feature I stopped.
> > 
> > 
> > I don't understand why it's harder to extend print_event() rather than
> > perf report.
> 
> All of the changes to perf-report are related strictly to this feature -
> generating the timestamp and printing the sample including walking the
> callchain.

This is the actual drawback: it's only useful for your feature. My wish
is to have something more broadly useful. And support for callchains or
other things like this in perf script is desired and has been requested
by the past.

> perf-script needs to have features added to it:
>   1. working with all samples,

Why do you need that? You seem to be only interested in tracepoint
events.

Sure I would appreciate that perf script can support any event as a bonus
but that doesn't seem mandatory here.

>   2. support for callchains,

What does it take more than what you did in perf report, namely
calling perf_session_resolve_callchain and walking the cursor?

>   3. more?

?

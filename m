Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754288Ab1HLTqz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 15:46:55 -0400
Received: from smtp-out.google.com ([216.239.44.51]:52928 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751666Ab1HLTqw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 15:46:52 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:sender:in-reply-to:references:date:
	x-google-sender-auth:message-id:subject:from:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=G19LlKInx27gvTCsijFzzL0CIkhoEd8pBmlPSZZE2MubezU3YYPyAbvREVOQH3bKg
	c+yKnDPhiTIolABvFZDiQ==
MIME-Version: 1.0
In-Reply-To: <20110812090607.GE28956@elte.hu>
References: <1312999364-21104-1-git-send-email-zakmagnus@chromium.org>
	<1312999364-21104-2-git-send-email-zakmagnus@chromium.org>
	<1313091323.8491.30.camel@twins>
	<20110812090607.GE28956@elte.hu>
Date: Fri, 12 Aug 2011 12:46:47 -0700
X-Google-Sender-Auth: CNyJa8_5haoT97zYKqG1lM9kFFI
Message-ID: <CAAuSN9256P3gYTgcFA9AQjZrBC_jX2miH2FrPLstY+Vu=pn1LA@mail.gmail.com>
Subject: Re: [PATCH v6 2/2] Output stall data in debugfs
From: Alex Neronskiy <zakmagnus@chromium.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Don Zickus <dzickus@redhat.com>,
        Mandeep Singh Baines <msb@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 12, 2011 at 2:06 AM, Ingo Molnar <mingo@elte.hu> wrote:
> Well, but there are conceptual problems at the higher levels: the
> concept of recording a worst-case (or best-case) latency is not
> limited to the comparatively minor usecase of soft-watchdog stalls.
>
> We have numerous tracers in ftrace that output their own kinds of
> min/max latencies, with associated stack trace signatures.
>
> So the right approach would *not* be to add yet another
> special-purpose debugfs variant for this, but to integrate this
> capability into perf tracing. That way it would be useful for:
>
>  - soft stalls
>  - irq service latencies
>  - irq disable latencies
>  - preempt disable latencies
>  - wakeup latencies
>  - and much more: it could be used for just about any event that
>   measures some sort of latency.
>
> To implement it i'd first suggest to add a TRACE_EVENT() for the
> softwatchdog latencies, and then look at how a stack-trace attached
> to the worst-case latency could be emitted via the perf ring-buffer.
>
> We do something very, very similar for callchains already, so all the
> low level machinery is already there.
>
> Alex, would you be interested in taking a stab at this approach? Such
> an approach looks a *lot* more palatable from an upstream merge point
> of view and it would give you all the functionality that the current
> patches are providing you (and more).
>
> Thanks,
>
>        Ingo
The best data comes from real-world use, so we want this used in
production. We felt that ftrace would add excessive overhead and bog
down performance, whereas this random sampling approach is basically
free, especially considering it's piggybacking on watchdogs which are
already running anyway. Is our approach misguided? Is this not as
cheap as we think? Is tracing not as expensive as we think?

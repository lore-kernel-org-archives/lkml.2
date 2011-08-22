Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756683Ab1HVI1s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 04:27:48 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47968 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756593Ab1HVI1i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 04:27:38 -0400
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Products GmbH
To: Ming Lei <tom.leiming@gmail.com>
Subject: Re: [PATCH 3/3] trace points: power: remove 'cpu_id' from trace_cpu_idle
Date: Mon, 22 Aug 2011 10:27:34 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.37.6-0.7-desktop; KDE/4.6.0; x86_64; ; )
Cc: rostedt@goodmis.org, fweisbec@gmail.com, jean.pihet@newoldbits.com,
        mingo@redhat.com, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, Len Brown <lenb@kernel.org>
References: <1313766244-22313-1-git-send-email-tom.leiming@gmail.com> <201108192231.02665.trenn@suse.de> <CACVXFVPeFyg7YoAsY63Mpy9HVR1y3ibg9R8HnUfLVe=hKf3ApA@mail.gmail.com>
In-Reply-To: <CACVXFVPeFyg7YoAsY63Mpy9HVR1y3ibg9R8HnUfLVe=hKf3ApA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201108221027.34441.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, August 20, 2011 04:40:09 AM Ming Lei wrote:
> Hi,
> 
> 2011/8/20 Thomas Renninger <trenn@suse.de>:
> > On Friday, August 19, 2011 05:04:04 PM tom.leiming@gmail.com wrote:
> >> From: Ming Lei <tom.leiming@gmail.com>
> >>
> >> This patch removes the 'cpu_id' parameter of the cpu_idle
> >> trace point, based on the ideas below:
> >>
> >> - the cpu_id which is passed to trace point is always the current
> >>   cpu
> > Are you sure this will always be true?
> 
> It is sure at least now,  the only place to pass 'dev->cpu' is inside
> cpuidle_idle_call,
It was known that cpu_id is always the current cpu with current 
implementation when this got introduced.
But the perf events API must not change back and forth for userspace 
compatibility. Therefore the cpu_id was added in case
that future implementations want to pass info where the current cpu
is not the cpu which is sent to the sleep state.

> smp_processor_id() can't be used safely in preemptible context.
I expect the only side effect that could happen is that if smp_process_id
is interrupted you get the wrong core id on a cpu idle trace event.
This only happens if cpuidle is not used and even then should happen
very rarely, nothing to worry for a debug tool like that.
And it should get fixed if these idle functions get fully integrated into
cpuidle at some point of time.

   Thomas

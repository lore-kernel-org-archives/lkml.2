Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933445Ab1CXASX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 20:18:23 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:56932 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933023Ab1CXASW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 20:18:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=cmapiinvBWoDeTRfF2Pm7zDSznEPp4But7jq8cZgK0i2/zoSy0G7bIYDGN9TqRH01I
         1O3/rBUHGzvgkD1SYVVUjDhybvnzwDo3xGpBtW3eHbgdT+dwfk0Tq221xLH1RFpA7uMe
         9ECIrgRfP6X8J4jXANKqS4s3BKEdakYM7Icsw=
Message-ID: <4D8A8DC9.1060502@suse.cz>
Date: Thu, 24 Mar 2011 01:18:17 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@kernel.org, lwn@lwn.net,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jiri Slaby <jirislaby@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: Re: Linux 2.6.32.34
References: <20110323203426.GC7709@kroah.com> <20110323203437.GD7709@kroah.com>
In-Reply-To: <20110323203437.GD7709@kroah.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/23/2011 09:34 PM, Greg KH wrote:
> --- a/kernel/perf_event.c
> +++ b/kernel/perf_event.c
> @@ -4167,6 +4167,8 @@ static void tp_perf_event_destroy(struct perf_event *event)
>  
>  static const struct pmu *tp_perf_event_init(struct perf_event *event)
>  {
> +	if (event->hw.state & PERF_HES_STOPPED)
> +		return 0;
>  	/*
>  	 * Raw tracepoint data is a severe data leak, only allow root to
>  	 * have these.

This causes build to fail:
/usr/src/packages/BUILD/kernel-vanilla-2.6.32.34/linux-2.6.32/kernel/perf_event.c:
 In function 'tp_perf_event_init':
/usr/src/packages/BUILD/kernel-vanilla-2.6.32.34/linux-2.6.32/kernel/perf_event.c:4170:
 error: 'struct hw_perf_event' has no member named 'state'
/usr/src/packages/BUILD/kernel-vanilla-2.6.32.34/linux-2.6.32/kernel/perf_event.c:4170:
 error: 'PERF_HES_STOPPED' undeclared (first use in this function)
/usr/src/packages/BUILD/kernel-vanilla-2.6.32.34/linux-2.6.32/kernel/perf_event.c:4170:
 error: (Each undeclared identifier is reported only once
/usr/src/packages/BUILD/kernel-vanilla-2.6.32.34/linux-2.6.32/kernel/perf_event.c:4170:
 error: for each function it appears in.)


The source:
commit 6f197b73304b3bd3d5a43b931383a5331d6b2987
Author: Frederic Weisbecker <fweisbec@gmail.com>
Date:   Mon Mar 7 21:27:09 2011 +0100

    perf: Handle stopped state with tracepoints

    commit a0f7d0f7fc02465bb9758501f611f63381792996 upstream.

    We toggle the state from start and stop callbacks but actually
    don't check it when the event triggers. Do it so that
    these callbacks actually work.

thanks,
-- 
js
suse labs

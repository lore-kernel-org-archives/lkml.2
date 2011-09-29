Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755129Ab1I2WGL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 18:06:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18383 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752062Ab1I2WGJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 18:06:09 -0400
Date: Thu, 29 Sep 2011 19:05:48 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf tools: Exit recording if events have non matching
	sample type
Message-ID: <20110929220548.GA17597@ghostprotocols.net>
References: <1317312068-10411-1-git-send-email-jolsa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317312068-10411-1-git-send-email-jolsa@redhat.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Sep 29, 2011 at 06:01:08PM +0200, Jiri Olsa escreveu:
> The event processing relies on all events having the same sample_type.
> 
> This is being checked when the session is being opened read only.
> It also needs to be checked when we do record, since events could be
> read during processing build IDs at the end of the record command.
> 
> If we process events with different sample_type the processing might
> skip some events or hang.
> 
> Following command hangs on my setup:
>   ./perf record -o perf.data -e ext4:ext4_mb_new_group_pa \
>    -e LLC-loads -- date '+%F'
> 
> because hardware and tracepoint events have different sample type.
> 
> With the patch applied the record command displays
> "Non matching sample_type" message and exits.

That is way too cryptic :-\

What is that makes the sample type not match in this case? Can we make
it match instead?

This is something to be properly fixed by _allowing_ non matching sample
types, the evsel/evlist abstractions are getting we close but not there
yet, multiple files in a perf.data/ directory are needed.

Till then can you check if we can make it match or else just say that
the mix of events is not yet supported, please collect them in different
sessions or something along those lines?

- Arnaldo

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756483Ab2F0JQA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 05:16:00 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:57110 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754383Ab2F0JP7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 05:15:59 -0400
Message-ID: <4FEACFD9.7020503@linaro.org>
Date: Wed, 27 Jun 2012 13:18:17 +0400
From: Dmitry Antipov <dmitry.antipov@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: Namhyung Kim <namhyung@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, Amit Kucheria <amit.kucheria@linaro.org>
Subject: Re: [PATCH] perf sched replay: fix event lookup
References: <1339232758-920-1-git-send-email-dmitry.antipov@linaro.org> <87pq96pfj9.fsf@sejong.aot.lge.com> <20120611140852.GB2202@infradead.org> <8739616pc9.fsf@sejong.aot.lge.com> <20120625232016.GA28525@infradead.org>
In-Reply-To: <20120625232016.GA28525@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/26/2012 03:20 AM, Arnaldo Carvalho de Melo wrote:
>
>> Fair enough. The method should be a simple wrapper to libtraceevent APIs
>> like this patch.
>
> The pevent thing is per perf.data file, so I made it stop being static
> and become a perf_session member, so tools processing perf.data files
> use perf_session and _there_ we read the event into session->pevent and
> then have to change everywhere to stop using that single global pevent
> variable and use the per session one.
>
> Dmitry, can you test the attached patch to check if it solves the
> problems you reported?

This looks good and works for my x86 <-> ARM tests.

> Note that it _doesn't_ fall backs to trace__event_id, as we're not
> interested at all in what is present in the
> /sys/kernel/debug/tracing/events in the workstation doing the analysis,
> just in what is in the perf.data file.

Agree.

Dmitry

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753798Ab0LCFpV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 00:45:21 -0500
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:35464 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751791Ab0LCFpT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 00:45:19 -0500
Content-Type: text/plain; charset=UTF-8
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 2/4] perf events: Make sample_type identity fields available in all PERF_RECORD_ events
From: Ian Munsie <imunsie@au1.ibm.com>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
In-reply-to: <1291318772-30880-3-git-send-email-acme@infradead.org>
References: <1291318772-30880-1-git-send-email-acme@infradead.org> <1291318772-30880-3-git-send-email-acme@infradead.org>
Date: Fri, 03 Dec 2010 16:45:10 +1100
Message-Id: <1291354847-sup-5582@au1.ibm.com>
User-Agent: Sup/0.11
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>      /*
> +     * If perf_event_attr.sample_id_all is set then all event types will
> +     * have the sample_type selected fields related to where/when
> +     * (identity) an event took place (TID, TIME, ID, CPU, STREAM_ID)
> +     * described in PERF_RECORD_SAMPLE below, it will be stashed just after
> +     * the perf_event_header and the fields already present for the existing
> +     * fields, i.e. at the end of the payload. That way a newer perf.data
> +     * file will be supported by older perf tools, with these new optional
> +     * fields being ignored.

I'd put a comment in each event to be clear, but this is fine too.

> @@ -3944,8 +3988,15 @@ static void perf_event_comm_output(struct perf_event *event,
>                       struct perf_comm_event *comm_event)
>  {
>      struct perf_output_handle handle;
> +    struct perf_sample_data sample;
>      int size = comm_event->event_id.header.size;
> -    int ret = perf_output_begin(&handle, event, size, 0, 0);
> +    int ret;

How about:

-    int size = comm_event->event_id.header.size;
-    int ret = perf_output_begin(&handle, event, size, 0, 0);
+    int size, ret;

Like you did for perf_event_mmap_output?


Other than that:

Acked-by: Ian Munsie <imunsie@au1.ibm.com>

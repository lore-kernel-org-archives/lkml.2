Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753249Ab1FNSmT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 14:42:19 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:54214 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752108Ab1FNSmQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 14:42:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=dxVIK8BnIu4JTFk/1wqTpnpe/xYWFB8vX2Pjg8UxrhuSVN6B0n94eNrti3C0npTD3N
         mCqOMwJpMUZlnF2Q/Y9+d40sZxJNUYvCYQ2Rg1iUaqQYuOBGWr+r2VgXw9IqU2QMJAxk
         h7sEt6eSJkb4on/qIo88eBmm8xku0idpTlJHo=
Message-ID: <4DF7AB84.3080000@gmail.com>
Date: Tue, 14 Jun 2011 12:42:12 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@elte.hu, peterz@infradead.org, fweisbec@gmail.com,
        tglx@linutronix.de
CC: acme@ghostprotocols.net, paulus@samba.org
Subject: Re: [PATCH 0/6] Add time-of-day option to perf events
References: <1307490806-24548-1-git-send-email-dsahern@gmail.com>
In-Reply-To: <1307490806-24548-1-git-send-email-dsahern@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ping?

On 06/07/2011 05:53 PM, David Ahern wrote:
> Another attempt at printing time-of-day strings on perf events - this
> time with tracepoints in the timekeeping code to catch updates to
> xtime.
> 
> David Ahern (6):
>   trace: add tracepoints to timekeeping code - xtime changes
>   perf utils: export parse_single_tracepoint_event
>   perf: add reference time event
>   perf record: add time-of-day option
>   perf script: pass trace event to print_trace_event
>   perf script: add time-of-day option for displaying events
> 
>  include/trace/events/timekeeping.h       |   43 ++++++++
>  kernel/time/timekeeping.c                |    8 ++
>  tools/perf/Documentation/perf-record.txt |    3 +
>  tools/perf/Documentation/perf-script.txt |    8 ++-
>  tools/perf/builtin-record.c              |  102 +++++++++++++++++++-
>  tools/perf/builtin-script.c              |  157 +++++++++++++++++++++++++++++-
>  tools/perf/util/event.c                  |    1 +
>  tools/perf/util/event.h                  |    8 ++
>  tools/perf/util/parse-events.c           |   13 +--
>  tools/perf/util/parse-events.h           |   12 +++
>  tools/perf/util/session.c                |    4 +
>  tools/perf/util/session.h                |    3 +-
>  tools/perf/util/trace-event-parse.c      |   12 +--
>  tools/perf/util/trace-event.h            |    2 +-
>  14 files changed, 350 insertions(+), 26 deletions(-)
>  create mode 100644 include/trace/events/timekeeping.h
> 

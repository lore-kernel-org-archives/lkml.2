Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750987Ab2FLGh1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 02:37:27 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:57541 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711Ab2FLGh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 02:37:27 -0400
X-AuditID: 9c930197-b7b5dae000004b23-ed-4fd6e3a1634d
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Dmitry Antipov <dmitry.antipov@linaro.org>, Ingo Molnar <mingo@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, patches@linaro.org
Subject: Re: [PATCH] perf report: fix event name reporting
References: <1339158207-20575-1-git-send-email-dmitry.antipov@linaro.org>
	<20120611141416.GC2202@infradead.org>
Date: Tue, 12 Jun 2012 15:34:22 +0900
In-Reply-To: <20120611141416.GC2202@infradead.org> (Arnaldo Carvalho de Melo's
	message of "Mon, 11 Jun 2012 11:14:16 -0300")
Message-ID: <87y5nt598x.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.95 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, 11 Jun 2012 11:14:16 -0300, Arnaldo Carvalho de Melo wrote:
> Em Fri, Jun 08, 2012 at 04:23:27PM +0400, Dmitry Antipov escreveu:
>> Use trace_find_event to find event name before looking through
>> /sys files. This helps 'perf report' to show real event names
>> instead of 'unknown:unknown' when processing perf.data recorded
>> on another machine.
>
> We have to somehow tell perf_evlist__tty_browse_hists that it should try
> to figure out the name of the event by looking at _either_ /sys (local
> events) or what came in the perf.data file.
>
> That is because 'perf top' and 'perf report' uses
> perf_evlist__tty_browse_hists. One is for local events (top) and the
> other for perf.data files, that may or not be for local (in the sense of
> running the same kernel for record + report) or for "remote" (running on
> the same machine but with a different kernel at record than the one used
> at report) or from a different machine altogether, perhaps even
> different arch.
>

I just thought that we should always consider the remote case first and
falls back to local case because if we looked for local events, the
remote events (perf.data) would not exist so that it can falls to the
local case safely.

Now I think that we need a session method to check whether the current
session is local or remote, and acts something based on that info.

Thanks,
Namhyung

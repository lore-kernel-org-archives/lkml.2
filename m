Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756106Ab2HUJ72 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 05:59:28 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:51234 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754245Ab2HUJ70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 05:59:26 -0400
Date: Tue, 21 Aug 2012 11:59:20 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Andrew Vagin <avagin@openvz.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH] perf: create a helper structure perf_event_context
Message-ID: <20120821095920.GA3241@gmail.com>
References: <1344957803-2635317-1-git-send-email-avagin@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344957803-2635317-1-git-send-email-avagin@openvz.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Vagin <avagin@openvz.org> wrote:

>  18 files changed, 222 insertions(+), 255 deletions(-)

> -static int process_sample_event(struct perf_tool *tool,
> -				union perf_event *event,
> -				struct perf_sample *sample,
> -				struct perf_evsel *evsel,
> -				struct machine *machine)
> +static int process_sample_event(struct perf_event_context *ectx)
>  {
> -	struct perf_annotate *ann = container_of(tool, struct perf_annotate, tool);
> +	struct perf_sample *sample = ectx->sample;
> +	struct perf_annotate *ann = container_of(ectx->tool, struct perf_annotate, tool);
>  	struct addr_location al;

that looks like a nice cleanliness win.

Acked-by: Ingo Molnar <mingo@kernel.org>

Thanks,

	Ingo

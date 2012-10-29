Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759497Ab2J2Pkf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 11:40:35 -0400
Received: from casper.infradead.org ([85.118.1.10]:42723 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753616Ab2J2Pke convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 11:40:34 -0400
Message-ID: <1351525219.24721.38.camel@twins>
Subject: Re: [Patch v1 06/10] perf/x86: add support for PEBS Precise Store
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, ak@linux.intel.com,
        acme@redhat.com, jolsa@redhat.com, ming.m.lin@intel.com
Date: Mon, 29 Oct 2012 16:40:19 +0100
In-Reply-To: <1351523752-4215-7-git-send-email-eranian@google.com>
References: <1351523752-4215-1-git-send-email-eranian@google.com>
	 <1351523752-4215-7-git-send-email-eranian@google.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-10-29 at 16:15 +0100, Stephane Eranian wrote:
> -       if (fll) {
> +       if (fll || fst) {
>                 if (sample_type & PERF_SAMPLE_ADDR)
>                         data.addr = pebs->dla;
>  
> @@ -688,6 +731,8 @@ static void __intel_pmu_pebs_event(struct perf_event *event,
>                 if (sample_type & PERF_SAMPLE_DSRC) {
>                         if (fll)
>                                 data.dsrc.val = load_latency_data(pebs->dse);
> +                       else if (fst)
> +                               data.dsrc.val = precise_store_data(pebs->dse);
>                 }
>         }
>   

Ah, this is why I guess.. hrm.. ok, n/m then.

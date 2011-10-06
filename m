Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965262Ab1JFRyk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 13:54:40 -0400
Received: from casper.infradead.org ([85.118.1.10]:44819 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751523Ab1JFRyi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 13:54:38 -0400
Subject: Re: [PATCH 06/12] perf_events: implement PERF_SAMPLE_BRANCH for
 Intel X86
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, acme@redhat.com,
        ming.m.lin@intel.com, andi@firstfloor.org, robert.richter@amd.com,
        ravitillo@lbl.gov
Date: Thu, 06 Oct 2011 19:54:24 +0200
In-Reply-To: <1317912555-9559-7-git-send-email-eranian@google.com>
References: <1317912555-9559-1-git-send-email-eranian@google.com>
	 <1317912555-9559-7-git-send-email-eranian@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1317923665.29658.18.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-10-06 at 16:49 +0200, Stephane Eranian wrote:
> @@ -876,6 +889,13 @@ static void intel_pmu_disable_event(struct perf_event *event)
>                 return;
>         }
>  
> +       /*
> +        * must disable before any actual event
> +        * because any event may be combined with LBR
> +        */
> +       if (intel_pmu_needs_lbr_smpl(event))
> +               intel_pmu_lbr_disable(event);
> +
>         if (unlikely(hwc->config_base == MSR_ARCH_PERFMON_FIXED_CTR_CTRL)) {
>                 intel_pmu_disable_fixed(hwc);
>                 return; 

I don't get that, since until you disable the counter a PMI could happen
(*) you'd need to disable the LBR after you disable the counters.

* doesn't actually happen since we likely have the whole pmu disabled
here, but that's another thing ;-)

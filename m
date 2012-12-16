Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752507Ab2LPJEW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2012 04:04:22 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:34237 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752271Ab2LPJEQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2012 04:04:16 -0500
Date: Sun, 16 Dec 2012 10:04:10 +0100
From: Ingo Molnar <mingo@kernel.org>
To: suravee.suthikulpanit@amd.com
Cc: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        acme@ghostprotocols.net, tglx@linutronix.de, hpa@zytor.com,
        rric@kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        jacob.shin@amd.com
Subject: Re: [PATCH 1/1] Change IBS PMU to use perf_hw_context
Message-ID: <20121216090410.GC21690@gmail.com>
References: <1355518662-32071-1-git-send-email-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1355518662-32071-1-git-send-email-suravee.suthikulpanit@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* suravee.suthikulpanit@amd.com <suravee.suthikulpanit@amd.com> wrote:

> From: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> 
> Currently, the AMD IBS PMU initialize pmu.task_ctx_nr to 
> perf_invalid_context which only allows IBS to be running only 
> in system-wide mode (e.g. perf record -a). IBS hardware is 
> available in each core and should be per-context.  This patch 
> modifies the task_ctx_nr to use the perf_hw_context (default) 
> instead.

I'm wondering how extensively was it tested/verified that it's 
safe to enable IBS in per context mode as well, and that the 
profiling results are precise and accurate?

We never used the IBS hardware in this fashion before, so some 
extra care is prudent - and traces of that extra care should be 
visible in the changelog as well.

Thanks,

	Ingo

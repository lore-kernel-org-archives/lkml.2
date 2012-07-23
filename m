Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754363Ab2GWQdi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 12:33:38 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:43635 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754339Ab2GWQdg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 12:33:36 -0400
MIME-Version: 1.0
In-Reply-To: <1343024611-4692-2-git-send-email-zheng.z.yan@intel.com>
References: <1343024611-4692-1-git-send-email-zheng.z.yan@intel.com>
	<1343024611-4692-2-git-send-email-zheng.z.yan@intel.com>
Date: Mon, 23 Jul 2012 18:33:35 +0200
Message-ID: <CABPqkBSLk_fCBEbVgNVc3iGsOFaSiKpPYF5krj_wymDP=SA6Cg@mail.gmail.com>
Subject: Re: [PATCH 2/4] perf/x86: Fix format definition of SNB-EP uncore QPI box
From: Stephane Eranian <eranian@google.com>
To: "Yan, Zheng" <zheng.z.yan@intel.com>
Cc: a.p.zijlstra@chello.nl, mingo@elte.hu, andi@firstfloor.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 23, 2012 at 8:23 AM, Yan, Zheng <zheng.z.yan@intel.com> wrote:
> From: "Yan, Zheng" <zheng.z.yan@intel.com>
>
> The event control register of SNB-EP uncore QPI box has a one bit
> extension at bit position 21.
>
> Reported-by: Stephane Eranian <eranian@google.com>
> Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
> ---
>  arch/x86/kernel/cpu/perf_event_intel_uncore.c |   23 ++++++++++++++++++++++-
>  arch/x86/kernel/cpu/perf_event_intel_uncore.h |    4 ++++
>  2 files changed, 26 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
> index a5de59f..305e603 100644
> --- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
> +++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
> @@ -21,6 +21,7 @@ DEFINE_UNCORE_FORMAT_ATTR(event, event, "config:0-7");
>  DEFINE_UNCORE_FORMAT_ATTR(umask, umask, "config:8-15");
>  DEFINE_UNCORE_FORMAT_ATTR(edge, edge, "config:18");
>  DEFINE_UNCORE_FORMAT_ATTR(tid_en, tid_en, "config:19");
> +DEFINE_UNCORE_FORMAT_ATTR(ev_sel_ext, ev_sel_ext, "config:21");

I would not have done it that way. I would have done:

DEFINE_UNCORE_FORMAT_ATTR(event, event, "config:0-7,21");

Assuming the event parser supports disjoint bits. For QPI, I think
the event code is actually 9 bits wide. I will check on this some more.

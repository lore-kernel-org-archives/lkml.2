Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755402Ab0KKRyt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 12:54:49 -0500
Received: from smtp-out.google.com ([74.125.121.35]:22166 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755357Ab0KKRyr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 12:54:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=NQhif/9CqX7bofuKEAYLHxzu1vKQlROIqaNj4kn5zgsZBDvCEmMhtNPwO4tm6NmfnS
         P1wTScTTmOE9jrEQJanA==
MIME-Version: 1.0
In-Reply-To: <8762w3pxuy.fsf@basil.nowhere.org>
References: <1289492117-18066-1-git-send-email-andi@firstfloor.org>
	<8762w3pxuy.fsf@basil.nowhere.org>
Date: Thu, 11 Nov 2010 18:54:42 +0100
Message-ID: <AANLkTi=-OjDaz9iDm1aNYzeFsHmewTNnGBS8pRx1vfJT@mail.gmail.com>
Subject: Re: [PATCH/FIX] perf-events: Put the per cpu state for intel_pmu too
From: Stephane Eranian <eranian@google.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, fweisbec@gmail.com, a.p.zijlstra@chello.nl,
        mingo@elte.hu, acme@redhat.com, Andi Kleen <ak@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 11, 2010 at 6:35 PM, Andi Kleen <andi@firstfloor.org> wrote:
>
> Small bug fix for the earlier offcore_response patch:
> need to put the events for intel_pmu too, not only core_pmu.
>

You don't need it for core pmu, this is for Core Duo/Solo
if I recall correctly.


> Signed-off-by: Andi Kleen <ak@linux.intel.com>
>
> diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
> index a06dae3..9a71ffd 100644
> --- a/arch/x86/kernel/cpu/perf_event_intel.c
> +++ b/arch/x86/kernel/cpu/perf_event_intel.c
> @@ -1031,6 +1031,7 @@ static __initconst const struct x86_pmu intel_pmu = {
>         */
>        .max_period             = (1ULL << 31) - 1,
>        .get_event_constraints  = intel_get_event_constraints,
> +       .put_event_constraints  = intel_put_event_constraints,
>
>        .cpu_starting           = intel_pmu_cpu_starting,
>        .cpu_dying              = intel_pmu_cpu_dying,
>
> --
> ak@linux.intel.com -- Speaking for myself only.
>

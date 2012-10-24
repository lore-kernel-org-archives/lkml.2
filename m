Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934105Ab2JXItN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 04:49:13 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:48473 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933623Ab2JXItK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 04:49:10 -0400
MIME-Version: 1.0
In-Reply-To: <1351058350-9159-1-git-send-email-zheng.z.yan@intel.com>
References: <1351058350-9159-1-git-send-email-zheng.z.yan@intel.com>
Date: Wed, 24 Oct 2012 10:49:08 +0200
Message-ID: <CABPqkBS320VrPL9CzDVMzQCkHb6sxC+d1d7f_J3Mp0UXmF=3XA@mail.gmail.com>
Subject: Re: [PATCH V2 0/7] perf, x86: Haswell LBR call stack support
From: Stephane Eranian <eranian@google.com>
To: "Yan, Zheng" <zheng.z.yan@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "ak@linux.intel.com" <ak@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2012 at 7:59 AM, Yan, Zheng <zheng.z.yan@intel.com> wrote:
> From: "Yan, Zheng" <zheng.z.yan@intel.com>
>
> Haswell has a new feature that utilizes the existing Last Branch Record
> facility to record call chains. When the feature is enabled, function
> call will be collected as normal, but as return instructions are executed
> the last captured branch record is popped from the on-chip LBR registers.
> The LBR call stack facility can help perf to get call chains of progam
> without frame pointer.
>
> The LBR call stack has following known limitations
>  1. Zero length calls are not filtered out by hardware
>  2. Exception handing such as setjmp/longjmp will have calls/returns not
>     match
>  3. Pushing different return address onto the stack will have calls/returns
>     not match
>
> The patch series depends on Andi's "perf PMU support for Haswel" patches
>
The part that is missing here is that you don't explain that you are now
fitting LBR cstack under PERF_SAMPLE_CALLCHAIN. It is dynamically
enabled based on users callstack request mode.

> ---
> Changes since v1
>  - not expose PERF_SAMPLE_BRANCH_CALL_STACK to user space
>  - save/restore LBR stack on context switch for all sampling branch modes
>  - reduce lbr_sel_map size

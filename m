Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753494Ab2JVLX2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 07:23:28 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:43497 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753188Ab2JVLXZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 07:23:25 -0400
MIME-Version: 1.0
In-Reply-To: <1350902016.2768.85.camel@twins>
References: <1350886279-6141-1-git-send-email-zheng.z.yan@intel.com>
	<1350886279-6141-2-git-send-email-zheng.z.yan@intel.com>
	<1350902016.2768.85.camel@twins>
Date: Mon, 22 Oct 2012 13:23:23 +0200
Message-ID: <CABPqkBQ8XCwONGvoXpu8kwwwcFPM9yJce4r9OJU4E7iY0_9ZUA@mail.gmail.com>
Subject: Re: [PATCH 1/6] perf, x86: Basic Haswell LBR call stack support
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: "Yan, Zheng" <zheng.z.yan@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        "ak@linux.intel.com" <ak@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 22, 2012 at 12:33 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>
> On Mon, 2012-10-22 at 14:11 +0800, Yan, Zheng wrote:
> > +       /* LBR callstack does not work well with FREEZE_LBRS_ON_PMI */
> > +       if (!cpuc->lbr_sel || !(cpuc->lbr_sel->config & LBR_CALL_STACK))
> > +               debugctl |= DEBUGCTLMSR_FREEZE_LBRS_ON_PMI;
>
Is this a bug or a feature?

>
> How useful it is without this? How many calls between PMI and us getting
> to intel_pmu_lbr_read()?

Agreed with Peter. Freeze on PMI is critical for LBR in general.

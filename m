Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754968Ab2IYKoE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 06:44:04 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:33417 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346Ab2IYKoC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 06:44:02 -0400
MIME-Version: 1.0
Date: Tue, 25 Sep 2012 12:44:00 +0200
Message-ID: <CABPqkBQkXtBKJUQX1czwyVAFMvro4akvfpAvLyStPLzntdZhuQ@mail.gmail.com>
Subject: [BUG] perf/x86: Intel uncore_pmu_to_box() local variable typo
From: Stephane Eranian <eranian@google.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: "Yan, Zheng" <zheng.z.yan@intel.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>, "mingo@elte.hu" <mingo@elte.hu>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I don't understand why the local variable box needs to
be declared static here:

static struct intel_uncore_box *
uncore_pmu_to_box(struct intel_uncore_pmu *pmu, int cpu)
{
        static struct intel_uncore_box *box;

        box = *per_cpu_ptr(pmu->box, cpu);
        if (box)
                return box;
        ....
}

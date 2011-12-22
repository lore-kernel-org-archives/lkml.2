Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755031Ab1LVJa7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 04:30:59 -0500
Received: from na3sys009aob106.obsmtp.com ([74.125.149.76]:41428 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754890Ab1LVJa4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 04:30:56 -0500
MIME-Version: 1.0
In-Reply-To: <4EF2F01E.8060307@linux.intel.com>
References: <1324426147-16735-1-git-send-email-ccross@android.com>
 <4EF1A0B4.5080307@linux.intel.com> <CAMbhsRRP7s9xsHqxhb=iMfHAJFcqAea-6CDORZS34RCPNo+UWw@mail.gmail.com>
 <4EF1AA8A.8060304@linux.intel.com> <CAMbhsRSNTUvou9Gf6T4Ggq=jfxsWUcn7M2yNsKQz6aNrt6gLDg@mail.gmail.com>
 <4EF1CD49.9020800@linux.intel.com> <CAMbhsRRnKoR3YPWrZzVynVe+dcuU5v0siYvmp2vbBcS1hquC7Q@mail.gmail.com>
 <4EF2352C.3060102@linux.intel.com> <CAMbhsRSPCo9MSGp57Fv0sRdYUFcdwx8jEz1-CfX8LdKf8X4MVg@mail.gmail.com>
 <CAMQu2gxws83BUdj_eMbF0xpA1Mo_OA_MswE7KUm5pvbn3YbMuQ@mail.gmail.com> <4EF2F01E.8060307@linux.intel.com>
From: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>
Date: Thu, 22 Dec 2011 15:00:34 +0530
Message-ID: <CAMQu2gxq26=pNA3L8aXUbLR4ZAT5RqyNawtm2qsPVc5cJCdOLg@mail.gmail.com>
Subject: Re: [linux-pm] [PATCH 0/3] coupled cpuidle state support
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Colin Cross <ccross@android.com>, Kevin Hilman <khilman@ti.com>,
        Len Brown <len.brown@intel.com>, linux-kernel@vger.kernel.org,
        Amit Kucheria <amit.kucheria@linaro.org>, linux-tegra@vger.kernel.org,
        linux-pm@lists.linux-foundation.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 22, 2011 at 2:23 PM, Arjan van de Ven <arjan@linux.intel.com> wrote:
> On 12/22/2011 9:35 AM, Shilimkar, Santosh wrote:
>
>> Indeed. The SOCs, Arch's which does support low power
>> state independently and doesn't need any co-ordination between CPU's
>> will continue to work same way as before with this series.
>
> btw I think you misunderstand; I don't object to a need for something
> like this,
I did. Thanks for clarification.

> I am just very concerned that this may not be possible to be
> done in a race-free way.
>
I agree to those races but may be they are harmless.
Also the safe state need not be just WFI and can be bit deeper
where the co-ordination between isn't necessary. So that should
still not burn the power that much.

For simplicity let's assume a two CPU scenario.
Ideal scenario:
CPU 1 has entered idle and incremented counter for the
co-ordinated C state. CPU0 also enter and increments the
counter and now the subsystem and interconnect can go
down along with CPU cluster.

Few of the race conditions will possibly lead to void
the above conditions  and in that case the counter would
reflect that and such a C-state won't be attempted and
a safe C-state would be attempted. That should still work
fine.

Some how this hardware/security restriction is bit stupid
and likely going against the existing CPUIDLE design
which expect that a CPUIDLE thread are per CPU and it should
be independent and local to that CPU.

Regards
Santosh

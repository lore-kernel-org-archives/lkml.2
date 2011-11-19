Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754916Ab1KSAgS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 19:36:18 -0500
Received: from na3sys009aog125.obsmtp.com ([74.125.149.153]:56536 "EHLO
	na3sys009aog125.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751744Ab1KSAgQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 19:36:16 -0500
MIME-Version: 1.0
In-Reply-To: <87vcqj62gd.fsf@ti.com>
References: <1321346765-16633-1-git-send-email-balbi@ti.com>
 <1321346765-16633-2-git-send-email-balbi@ti.com> <87vcqj62gd.fsf@ti.com>
From: "Menon, Nishanth" <nm@ti.com>
Date: Fri, 18 Nov 2011 18:35:53 -0600
Message-ID: <CAOMWX4egSeBfHdD4LHxtvvaQj+MK0ecRrQGdQ+ELDRUz5tFUEg@mail.gmail.com>
Subject: Re: [PATCH/RESEND #3 1/7] OMAP3+: PM: SR: add suspend/resume handlers
To: Kevin Hilman <khilman@ti.com>
Cc: Felipe Balbi <balbi@ti.com>, Tony Lindgren <tony@atomide.com>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 16, 2011 at 18:02, Kevin Hilman <khilman@ti.com> wrote:
> Felipe Balbi <balbi@ti.com> writes:
>
>> From: Nishanth Menon <nm@ti.com>
>>
>> SmartReflex should be disabled while entering low power mode due to
>> the following reasons:
> [...]
>
> Nishanth, in the end, didn't you decide to drop this patch?
>

Yes, I did eventually, once we implemented DVFS for GPU, Ducati, HSI,
and other drivers, there was no real way to ensure sequence of suspend
sequencing even after moving this to suspend_noirq. some of the other
reasons:

if I disabled Smartreflex and went to Nominal voltage on MPU, and say
MPU was at "performance" mode of 1.5GHz or so, thermal scenarios got
worse due on hot corner samples - these tend to have higher leakage
and thermal characteristics tend to be more pronounced. The option of
throttling frequency down while suspend was not really a good option
in comparison to switching off smart reflex in the last possible
moment - in pmxxx.c

Regards,
Nishanth Menon

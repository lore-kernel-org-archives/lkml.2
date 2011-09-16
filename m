Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752194Ab1IPEuh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 00:50:37 -0400
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:39920 "EHLO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752052Ab1IPEug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 00:50:36 -0400
Message-ID: <4E72D593.9020902@ti.com>
Date: Fri, 16 Sep 2011 10:20:27 +0530
From: Santosh <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux@arm.linux.org.uk, ccross@android.com, rjw@sisk.pl,
        khilman@ti.com
Subject: Re: [PATCH v2 0/5] CPU PM notifiers
References: <1315060755-4613-1-git-send-email-santosh.shilimkar@ti.com>
In-Reply-To: <1315060755-4613-1-git-send-email-santosh.shilimkar@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 03 September 2011 08:09 PM, Santosh Shilimkar wrote:
> Updates V2:
> - The CPU PM notifiers are moved to generic level instead of keeping
>   it ARM specific as per Rafael's comment.
> - To avoid every driver duplicating the sys-core ops and cpu pm notfiers,
>   the CPU PM common notifier is registering it in one place so that
>   suspend is taken care.
> - CPU COMPLEX events are renamed to more appropriate CPU CLUSTER.
> - GIC distributor is not disabled to avoid the live locks. This is
>   observed with CPUIDLE cases where at time CPU cluster fails to
>   transition to low power states. As such there was no need to
>   disable distributor in first place since on cluster reset, it
>   will get disabled anyways.
> - In VFP code, syscore ops are dropped in favour of CPU PM
>   notifiers since S2R is already handled in core CPU PM notifiers.
> - The last patch is an independent patch but can be pushed along with
>   the other GIC changes done here. 
>  
> V1: [http://lwn.net/Articles/447259/]
> 
> This patch set tries to address concerns with platform pm code
> calling into the driver for every block in the Cortex A9s
> during idle, hotplug, and suspend.  The first patch adds cpu pm
> notifiers that can be called by platform code, the second uses
> the notifier to save and restore the GIC state, and the third
> saves the VFP state.
> 
> The notifiers are used for two types of events, CPU PM events and
> CPU cluster PM events.  CPU PM events are used to save and restore
> per-cpu context when a single CPU is preparing to enter or has
> just exited a low power state.  For example, the VFP saves the
> last thread context, and the GIC saves banked CPU registers.
> 
> CPU cluster events are used after all the CPUs in a power domain
> have been prepared for the low power state.  The GIC uses these
> events to save global register state.
> 
> L2 cache is not covered by this patch set, as the determination
> of when the L2 is reset and when it is retained is
> platform-specific, and most of the APIs necessary are already
> 
> 
> The series is tested with OMAP4 with S2R and CPUIDLE. 
> 
> The following changes since commit c6a389f123b9f68d605bb7e0f9b32ec1e3e14132:
> 
>   Linux 3.1-rc4 (2011-08-28 21:16:01 -0700)
> 
> Colin Cross (5):
>       cpu_pm: Add cpu power management notifiers
>       cpu_pm: call notifiers during suspend
>       ARM: gic: Use cpu pm notifiers to save gic state
>       ARM: vfp: Use cpu pm notifiers to save vfp state
>       ARM: gic: Allow gic arch extensions to provide irqchip flags
> 

Thanks all for the reviews and testing of this series.
I am going to add these patches as part of my pull request
to Russell for the 3.2.

Regards
Santosh

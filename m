Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934186Ab3AIUqX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 15:46:23 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:54218 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932465Ab3AIUqU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 15:46:20 -0500
X-IronPort-AV: E=Sophos;i="4.84,440,1355126400"; 
   d="scan'208";a="18812854"
Message-ID: <50EDD71A.5030406@codeaurora.org>
Date: Wed, 09 Jan 2013 12:46:18 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Mark Rutland <mark.rutland@arm.com>
CC: linux-kernel@vger.kernel.org, nico@linaro.org, marc.zyngier@arm.com,
        will.deacon@arm.com, john.stultz@linaro.org, tglx@linutronix.de,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCHv2 0/4] clockevents: decouple broadcast mechanism from
 drivers
References: <1357742770-15028-1-git-send-email-mark.rutland@arm.com>
In-Reply-To: <1357742770-15028-1-git-send-email-mark.rutland@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/09/13 06:46, Mark Rutland wrote:
> This is an updated version of the series I posted back in December:
> http://lists.infradead.org/pipermail/linux-arm-kernel/2012-December/137929.html
>
> Changes since v1:
> * Drop removal of guards in smp.c
> * Removed useless evt->evt_handler check in tick_receive_broadcast
> * Fix up tick_receive_broadcast when !GENERIC_CLOCKEVENTS_BROADCAST
> * Fix checkpatch issues (multi-line strings)
>
> Thanks go to Stephen Boyd and Santosh Shilimkar for their commments.
>
> In some SMP systems, cpu-local timers may stop delivering interrupts
> when in low power states, or not all CPUs may have local timers. To
> support these systems we have a mechanism for broadcasting timer ticks
> to other CPUs. This mechanism relies on the struct
> clock_event_device::broadcast function pointer, which is a
> driver-specific mechanism for broadcasting ticks to other CPUs.
>
> As the broadcast mechanism is architecture-specific, placing the
> broadcast function on struct clock_event_device ties each driver to a
> single architecture. Additionally the driver or architecture backend
> must handle the routing of broadcast ticks to the correct
> clock_event_device, leading to duplication of the list of active
> clock_event_devices.
>
> These patches introduce a generic mechanism for handling the receipt of
> timer broadcasts, and an optional architecture-specific broadcast
> function which allows drivers to be decoupled from a particular
> architecture will retaining support for timer tick broadcasts. These
> mechanisms are wired up for the arm port, and have been boot-tested on a
> pandaboard.
>

For the series:

Reviewed-by: Stephen Boyd <sboyd@codeaurora.org>

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation


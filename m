Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751599Ab3AJJox (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 04:44:53 -0500
Received: from service87.mimecast.com ([91.220.42.44]:33212 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041Ab3AJJou convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 04:44:50 -0500
Date: Thu, 10 Jan 2013 09:44:44 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "nico@linaro.org" <nico@linaro.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>, Will Deacon <Will.Deacon@arm.com>,
        "john.stultz@linaro.org" <john.stultz@linaro.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCHv2 0/4] clockevents: decouple broadcast mechanism from
 drivers
Message-ID: <20130110094435.GA17741@e106331-lin.cambridge.arm.com>
References: <1357742770-15028-1-git-send-email-mark.rutland@arm.com>
 <50EDD71A.5030406@codeaurora.org>
MIME-Version: 1.0
In-Reply-To: <50EDD71A.5030406@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 10 Jan 2013 09:44:47.0702 (UTC) FILETIME=[20CA2F60:01CDEF17]
X-MC-Unique: 113011009444903001
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 09, 2013 at 08:46:18PM +0000, Stephen Boyd wrote:
> On 01/09/13 06:46, Mark Rutland wrote:
> > This is an updated version of the series I posted back in December:
> > http://lists.infradead.org/pipermail/linux-arm-kernel/2012-December/137929.html
> >
> > Changes since v1:
> > * Drop removal of guards in smp.c
> > * Removed useless evt->evt_handler check in tick_receive_broadcast
> > * Fix up tick_receive_broadcast when !GENERIC_CLOCKEVENTS_BROADCAST
> > * Fix checkpatch issues (multi-line strings)
> >
> > Thanks go to Stephen Boyd and Santosh Shilimkar for their commments.
> >
> > In some SMP systems, cpu-local timers may stop delivering interrupts
> > when in low power states, or not all CPUs may have local timers. To
> > support these systems we have a mechanism for broadcasting timer ticks
> > to other CPUs. This mechanism relies on the struct
> > clock_event_device::broadcast function pointer, which is a
> > driver-specific mechanism for broadcasting ticks to other CPUs.
> >
> > As the broadcast mechanism is architecture-specific, placing the
> > broadcast function on struct clock_event_device ties each driver to a
> > single architecture. Additionally the driver or architecture backend
> > must handle the routing of broadcast ticks to the correct
> > clock_event_device, leading to duplication of the list of active
> > clock_event_devices.
> >
> > These patches introduce a generic mechanism for handling the receipt of
> > timer broadcasts, and an optional architecture-specific broadcast
> > function which allows drivers to be decoupled from a particular
> > architecture will retaining support for timer tick broadcasts. These
> > mechanisms are wired up for the arm port, and have been boot-tested on a
> > pandaboard.
> >
> 
> For the series:
> 
> Reviewed-by: Stephen Boyd <sboyd@codeaurora.org>

Thanks!

> 
> -- 
> Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
> hosted by The Linux Foundation
> 
> 

Mark.


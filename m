Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752674Ab3ABLl4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 06:41:56 -0500
Received: from service87.mimecast.com ([91.220.42.44]:35603 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752090Ab3ABLlx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 06:41:53 -0500
Date: Wed, 2 Jan 2013 11:41:48 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "nico@linaro.org" <nico@linaro.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>, Will Deacon <Will.Deacon@arm.com>,
        "john.stultz@linaro.org" <john.stultz@linaro.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC PATCH 0/5] clockevents: decouple broadcast mechanism from
 drivers
Message-ID: <20130102114148.GB25907@e106331-lin.cambridge.arm.com>
References: <1355832418-31692-1-git-send-email-mark.rutland@arm.com>
 <50D43502.1070402@ti.com>
MIME-Version: 1.0
In-Reply-To: <50D43502.1070402@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 02 Jan 2013 11:41:49.0361 (UTC) FILETIME=[26B85210:01CDE8DE]
X-MC-Unique: 113010211415100701
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 21, 2012 at 10:08:02AM +0000, Santosh Shilimkar wrote:
> Mark,
> 
> On Tuesday 18 December 2012 05:36 PM, Mark Rutland wrote:
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
> Apart from the relevant comments given against couple of patches and
> Stephen's printk string comment, the series looks pretty good to me.
> 
> I have tested the series with CPUIdle where the broadcast is actually
> used actively.

Great!

> So feel free to add,
> Reviewed-tested-by: Santosh Shilimkar <santosh.shilimkar@ti.com>

Thanks!

Mark.


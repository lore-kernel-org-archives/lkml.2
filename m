Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752694Ab3ABLOO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 06:14:14 -0500
Received: from service87.mimecast.com ([91.220.42.44]:44790 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752546Ab3ABLON convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 06:14:13 -0500
Date: Wed, 2 Jan 2013 11:14:05 +0000
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
Subject: Re: [RFC PATCH 1/5] ARM: remove useless guard in smp.c
Message-ID: <20130102111405.GA25907@e106331-lin.cambridge.arm.com>
References: <1355832418-31692-1-git-send-email-mark.rutland@arm.com>
 <1355832418-31692-2-git-send-email-mark.rutland@arm.com>
 <50D43399.7010705@ti.com>
MIME-Version: 1.0
In-Reply-To: <50D43399.7010705@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 02 Jan 2013 11:14:09.0867 (UTC) FILETIME=[4995A1B0:01CDE8DA]
X-MC-Unique: 113010211141103401
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 21, 2012 at 10:02:01AM +0000, Santosh Shilimkar wrote:
> On Tuesday 18 December 2012 05:36 PM, Mark Rutland wrote:
> > Currently we only provide an implementation of smp_timer_broadcast in
> > smp.c if GENERIC_CLOCKEVENTS_BROADCAST is selected. As
> > smp_timer_broadcast is only used in smp.c, smp.c depends on SMP, and
> > GENERIC_CLOCKEVENTS_BROADCAST is selected by SMP, this is unnecessary.
> >
> > This patch removes the redundant guard.
> >
> > Signed-off-by: Mark Rutland <mark.rutland@arm.com>
> > ---
> CONFIG_GENERIC_CLOCKEVENTS_BROADCAST isn't mandatory to
> have SMP kernel working so the below select in ARM arch
> kconfig not seems to entirely accurate. SMP kernel will
> still boot with !GENERIC_CLOCKEVENTS_BROADCAST.
> 
> select GENERIC_CLOCKEVENTS_BROADCAST if SMP

Agreed, the selection is not entirely accurate. I'd be happy to see it made
more fine-grained (i.e. selected by platforms) instead.

If people want that I'm happy to drop this patch.

> The issue comes only for deeper CPU power C-states.
> Anyway, you patch is correct from the current code point of
> view.
> 
> Regards
> Santosh

Thanks,
Mark.


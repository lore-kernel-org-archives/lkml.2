Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757459Ab0JSUn6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 16:43:58 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:54153 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757424Ab0JSUn4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 16:43:56 -0400
MIME-Version: 1.0
X-Originating-IP: [109.186.69.160]
In-Reply-To: <AANLkTimDdPUjo+65vBL0PTQ3b=5NpeVT28XrdkYqx3Ex@mail.gmail.com>
References: <1287387875-14168-1-git-send-email-ohad@wizery.com>
 <1287387875-14168-2-git-send-email-ohad@wizery.com> <AANLkTimDdPUjo+65vBL0PTQ3b=5NpeVT28XrdkYqx3Ex@mail.gmail.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Tue, 19 Oct 2010 22:43:34 +0200
Message-ID: <AANLkTinNfERyi_bTWc7LOKR1uRLC3E612ubFKBLxWB1E@mail.gmail.com>
Subject: Re: [PATCH 1/3] drivers: misc: add omap_hwspinlock driver
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, akpm@linux-foundation.org,
        Greg KH <greg@kroah.com>, Tony Lindgren <tony@atomide.com>,
        Benoit Cousson <b-cousson@ti.com>, Hari Kanigeri <h-kanigeri2@ti.com>,
        Suman Anna <s-anna@ti.com>, Simon Que <sque@ti.com>,
        "Krishnamoorthy, Balaji T" <balajitk@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 19, 2010 at 7:01 PM, Grant Likely <grant.likely@secretlab.ca> wrote:
>> +  struct omap_hwspinlock *omap_hwspinlock_request(void);
...
> ERR_PTR() is only appropriate when the caller actually cares about the
> failure code and has different behaviour depending on the result.

Agree; the hwspinlock users can surely live without an explicit error
code from the _request APIs, and some extra robustness can only do
good.

I'll remove it.

> Disabling irqs *might* be a concern as a source of RT latency.  It
> might be better to make the caller responsible for managing local spin
> locks and irq disable/enable.

This a coming from an hardware requirement, rather than a choice the
user should take.

If a hwspinlock is taken over a long period of time, its other user
(with which we try to achieve synchronization) might be polling the
OMAP interconnect for too long (trying to take the hwspinlock) and
thus preventing it to be used for other transactions.

To prevent such lengthy polling on the interconnect, the hwspinlock
should only be used for very short period of times, with preemption
and interrupts disabled.

That's why we don't give users the choice whether to disable
interrupts or not - it's simply not a decision they should take.

Thanks,
Ohad.

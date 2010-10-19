Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757243Ab0JSUVf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 16:21:35 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:49530 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757170Ab0JSUVd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 16:21:33 -0400
MIME-Version: 1.0
X-Originating-IP: [109.186.69.160]
In-Reply-To: <8762wyyv99.fsf@deeprootsystems.com>
References: <1287387875-14168-1-git-send-email-ohad@wizery.com>
 <1287387875-14168-2-git-send-email-ohad@wizery.com> <8762wyyv99.fsf@deeprootsystems.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Tue, 19 Oct 2010 22:21:10 +0200
Message-ID: <AANLkTi=4hYRJheBBLJARJr_s5RbMs3APFTKD-pk1VJEy@mail.gmail.com>
Subject: Re: [PATCH 1/3] drivers: misc: add omap_hwspinlock driver
To: Kevin Hilman <khilman@deeprootsystems.com>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, akpm@linux-foundation.org,
        Greg KH <greg@kroah.com>, Tony Lindgren <tony@atomide.com>,
        Benoit Cousson <b-cousson@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Hari Kanigeri <h-kanigeri2@ti.com>, Suman Anna <s-anna@ti.com>,
        Simon Que <sque@ti.com>, "Krishnamoorthy, Balaji T" <balajitk@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 19, 2010 at 6:58 PM, Kevin Hilman
<khilman@deeprootsystems.com> wrote:
>> +      * This spin_trylock_irqsave serves two purposes:
>> +
>> +      * 1. Disable local interrupts and preemption, in order to
>> +      *    minimize the period of time in which the hwspinlock
>> +      *    is taken (so caller will not preempted). This is
>> +      *    important in order to minimize the possible polling on
>> +      *    the hardware interconnect by a remote user of this lock.
>> +      *
>> +      * 2. Make this hwspinlock primitive SMP-safe (so we can try to
>> +      *    take it from additional contexts on the local cpu)
>> +      */
>
> 3. Ensures that in_atomic/might_sleep checks catch potential problems
>   with hwspinlock usage (e.g. scheduler checks like 'scheduling while
>   atomic' etc.)

Nice one. Added.

>> +/**
>> + * omap_hwspinlock_unlock() - unlock a specific hwspinlock
>
> minor nit: s/lock_unlock/_unlock/  to match name below

Thanks.

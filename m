Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760445Ab1D1OQn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 10:16:43 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:5564 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759730Ab1D1OQl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 10:16:41 -0400
Date: Thu, 28 Apr 2011 16:16:25 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Eric Miao <eric.y.miao@gmail.com>
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, ben-linux@fluff.org,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] i2c: append hardware lock with bus lock
Message-ID: <20110428161625.5eaacb85@endymion.delvare>
In-Reply-To: <BANLkTin6jguQue_0Y74jGPnmhCcvWLBjHg@mail.gmail.com>
References: <1303963358-4652-1-git-send-email-haojian.zhuang@gmail.com>
	<20110428102212.2d8d607c@endymion.delvare>
	<BANLkTin6jguQue_0Y74jGPnmhCcvWLBjHg@mail.gmail.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eric,

On Thu, 28 Apr 2011 16:36:02 +0800, Eric Miao wrote:
> On Thu, Apr 28, 2011 at 4:22 PM, Jean Delvare <khali@linux-fr.org> wrote:
> > Hi Haojian,
> >
> > On Thu, 28 Apr 2011 12:02:36 +0800, Haojian Zhuang wrote:
> >> Both AP and CP are contained in Marvell PXA910 silicon. These two ARM
> >> cores are sharing one pair of I2C pins.
> >>
> >> In order to keep I2C transaction operated with atomic, hardware lock
> >> (RIPC) is required. Because of this, bus lock in AP side can't afford
> >> this requirement. Now hardware lock is appended.
> >
> > I have no objection to the idea, but one question: when using the
> > hardware lock, isn't the software mutex redundant? I would expect that
> > you call the hardware_lock/unlock functions _instead_ of
> > rt_mutex_lock/unlock, rather than in addition to it. Or do you still
> > need the rt_mutex to prevent priority inversion?
> >
> 
> Jean,
> 
> It's actually not redundant. The hardware lock is used to protect
> access to the same register regions between two processors (AP
> and CP so called), while the software lock is used to protect
> access from within the AP side.

Are you suggesting that the hardware lock wouldn't mind being taken
twice by the AP side? If it is the case, then indeed the software mutex
is still needed to prevent it from happening.

That being said... I guess that avoiding a priority inversion is a good
enough reason to always take the rt_mutex, regardless of the hardware
lock implementation.

So, this patch is

Acked-by: Jean Delvare <khali@linux-fr.org>

I guess it makes more sense for me to let Ben apply it, as the other
two patches in the series are for him too. This will avoid a dependency
between our trees.

-- 
Jean Delvare

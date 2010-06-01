Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752139Ab0FAFVk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 01:21:40 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:56889 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751585Ab0FAFVi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 01:21:38 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1005312343290.2933@localhost.localdomain>
References: <20100527222514.0a1710bf@lxorguk.ukuu.org.uk>
	<Pine.LNX.4.44L0.1005271730180.3239-100000@iolanthe.rowland.org>
	<20100527230806.4deb6de3@lxorguk.ukuu.org.uk>
	<20100527220949.GB10602@srcf.ucam.org>
	<20100527232357.6d14fdb2@lxorguk.ukuu.org.uk>
	<20100527223605.GB11364@srcf.ucam.org>
	<20100527235546.09f3ce8a@lxorguk.ukuu.org.uk>
	<20100528043114.GC26177@thunk.org>
	<1275030704.32462.11.camel@laptop>
	<AANLkTikEtlbkT4Ws3H2YGt_9QC46B5dr-b1oxJOcG4GN@mail.gmail.com>
	<1275120618.27810.12699.camel@twins>
	<1275149418.4503.128.camel@mulgrave.site>
	<alpine.LFD.2.00.1005312231120.2933@localhost.localdomain>
	<1275340869.2823.344.camel@mulgrave.site>
	<alpine.LFD.2.00.1005312343290.2933@localhost.localdomain>
Date: Mon, 31 May 2010 22:21:38 -0700
Message-ID: <AANLkTinwvkJRU0JjJdNrGfXWYpQMIr8bO3BZxcXubt_Z@mail.gmail.com>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: James Bottomley <James.Bottomley@suse.de>,
       Peter Zijlstra <peterz@infradead.org>, tytso@mit.edu,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       felipe.balbi@nokia.com, Alan Cox <alan@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 31, 2010 at 2:46 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Mon, 31 May 2010, James Bottomley wrote:
>>
>> For MSM hardware, it looks possible to unify the S and C states by doing
>> suspend to ram from idle but I'm not sure how much work that is.
>
> On ARM, it's not rocket science and we have in tree support for this
> already (OMAP). I have done the same thing on a Samsung part as a
> prove of concept two years ago and it's really easy as the hardware is
> sane. Hint: It's designed for mobile devices :)
>

We already enter the same power state from idle and suspend on msm. In
the absence of misbehaving apps, the difference in power consumption
is entirely caused by periodic timers in the user-space framework
_and_ kernel. It only takes a few timers triggering per second (I
think 3 if they do no work) to double the average power consumption on
the G1 if the radio is off. We originally added wakelocks because the
hardware we had at the time had much lower power consumption in
suspend then idle, but we still use suspend because it saves power.

-- 
Arve Hjønnevåg

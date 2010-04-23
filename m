Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756254Ab0DWNaV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 09:30:21 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:47198 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754209Ab0DWNaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 09:30:16 -0400
Date: Fri, 23 Apr 2010 14:30:12 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Will Newton <will.newton@gmail.com>
Cc: Yong Zhang <yong.zhang@windriver.com>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Threaded irq handler question
Message-ID: <20100423133012.GC28132@sirena.org.uk>
References: <l2u87a5b0801004210935wf6ca2991ua777c39c737391f8@mail.gmail.com> <20100422013721.GC8938@windriver.com> <r2l87a5b0801004220351h4ba2d1ect49c33893a30806e9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <r2l87a5b0801004220351h4ba2d1ect49c33893a30806e9@mail.gmail.com>
X-Cookie: Reapply as necessary.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 22, 2010 at 11:51:06AM +0100, Will Newton wrote:
> On Thu, Apr 22, 2010 at 2:37 AM, Yong Zhang <yong.zhang@windriver.com> wrote:

> > Does IRQF_ONESHOT meet your need?

> Almost I think, but I believe if my check handler does not wake the
> thread then I don't get another interrupt ever. I can fix this by
> making my check handler always return WAKE_THREAD, which is slightly
> sub-optimal, but not a big problem.

You shouldn't have a primary IRQ handler at all for I2C type devices
where there's no ability to interact with the chip.

[Sorry, hadn't noticed this subthread.]

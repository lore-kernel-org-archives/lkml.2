Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752448Ab1LLLAX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 06:00:23 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:47594 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751710Ab1LLLAW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 06:00:22 -0500
Message-ID: <1323687592.16450.0.camel@lappy>
Subject: Re: [patch 0/3] kvm tool: Serial emulation overhaul
From: Sasha Levin <levinsasha928@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Pekka Enberg <penberg@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Date: Mon, 12 Dec 2011 12:59:52 +0200
In-Reply-To: <20111212102750.469f0d9f@pyramind.ukuu.org.uk>
References: <20111210132220.083204833@linutronix.de>
	 <alpine.LFD.2.02.1112101715500.10936@tux.localdomain>
	 <alpine.LFD.2.02.1112102144370.3020@ionos>
	 <alpine.LFD.2.02.1112111014500.1663@tux.localdomain>
	 <20111211103047.GA19299@elte.hu> <alpine.LFD.2.02.1112111459270.3020@ionos>
	 <20111212102750.469f0d9f@pyramind.ukuu.org.uk>
Content-Type: text/plain; charset="us-ascii"
X-Mailer: Evolution 3.2.2 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-12-12 at 10:27 +0000, Alan Cox wrote:
> > Well, the difference between ssh and serial is, that ssh can pack 1.5k
> > worth of data into one frame, while serial has to send it
> > piecewise. And the emulation has to trap into kvm tool for each tx
> > byte, which doesnt help either. We cannot do much with buffering on
> > the kvm tool side as we have no clue how much consecutive data will
> > come in. That's why there is a virtual console, which has the
> > disadvantage that you cant see the early boot messages.
> 
> You can emulate a chip with a 64byte or so FIFO. You can do I/O cycle
> prediction in the kernel part and you can use the empty bit as a clue
> (which is what most serial<->ethernet widgetry does).

The performance problems here aren't the same performance problems you
have on real hardware. The problem here is that it costs 40k cycles for
the guest to access the emulated chip.

-- 

Sasha.



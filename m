Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753466Ab1LLSWN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 13:22:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20675 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753398Ab1LLSWI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 13:22:08 -0500
Message-ID: <4EE6463A.2010007@redhat.com>
Date: Mon, 12 Dec 2011 20:21:46 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Sasha Levin <levinsasha928@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Pekka Enberg <penberg@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch 0/3] kvm tool: Serial emulation overhaul
References: <20111210132220.083204833@linutronix.de> <alpine.LFD.2.02.1112101715500.10936@tux.localdomain> <alpine.LFD.2.02.1112102144370.3020@ionos> <alpine.LFD.2.02.1112111014500.1663@tux.localdomain> <20111211103047.GA19299@elte.hu> <alpine.LFD.2.02.1112111459270.3020@ionos> <20111212102750.469f0d9f@pyramind.ukuu.org.uk> <1323687592.16450.0.camel@lappy> <20111212110236.755eda81@pyramind.ukuu.org.uk>
In-Reply-To: <20111212110236.755eda81@pyramind.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/2011 01:02 PM, Alan Cox wrote:
> > > You can emulate a chip with a 64byte or so FIFO. You can do I/O cycle
> > > prediction in the kernel part and you can use the empty bit as a clue
> > > (which is what most serial<->ethernet widgetry does).
> > 
> > The performance problems here aren't the same performance problems you
> > have on real hardware. The problem here is that it costs 40k cycles for
> > the guest to access the emulated chip.
>
> How much of that 40K cycles is bouncing back and forth into emulation
> layers and how much of it is the kernel trap ?
>  

30K of those cycles are only in Sasha's mind, the real figure is 10K
(and likely lower with newer hardware).

-- 
error compiling committee.c: too many arguments to function


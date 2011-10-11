Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754057Ab1JKKJT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 06:09:19 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:47983 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752010Ab1JKKJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 06:09:18 -0400
Date: Tue, 11 Oct 2011 11:07:28 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ming Lei <tom.leiming@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, mark gross <mgross@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PM List <linux-pm@vger.kernel.org>
Subject: Re: [Question] PM-QoS: PM_QOS_CPU_DMA_LATENCY == interrupt latency?
Message-ID: <20111011110728.13004b1c@lxorguk.ukuu.org.uk>
In-Reply-To: <CACVXFVNAFTpZEOnH+6LxUk=dXtNKvmYVx5NtuJJ1bri4XEyt5Q@mail.gmail.com>
References: <CACVXFVOkwX+974=eEY5UPysXN-t9Adg6=Wn0Ts4m0vT5zQaw3g@mail.gmail.com>
	<20111010172557.332bfe30@lxorguk.ukuu.org.uk>
	<CACVXFVNAFTpZEOnH+6LxUk=dXtNKvmYVx5NtuJJ1bri4XEyt5Q@mail.gmail.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > No. Well it may be on some platforms but it isn't the same thing. On some
> > devices a DMA transfer doesn't need the CPU involved but needs the CPU to
> > respond within a set timescale (eg for coherency or bus arbitration). It
> 
> I understand only the CPU can respond after it is notified by a
> interrupt event, don't I?

The instruction stream being executed maybe, but not things like the cache

> Also could you give a example about how the CPU responds to a DMA transfer
> within a set timescale if it is required?

The kind of thing you are dealing with is

	DMA engine requests a cache line of data
	CPU wakes out of sleep, completes bus transaction
	CPU goes back to sleep
	DMA engine starts outputting data bits over SPI bus or similar

	repeat until done

so it's not instruction level stuff, merely bus traffic.

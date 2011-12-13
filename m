Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754178Ab1LMLFk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 06:05:40 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:56583 "EHLO
	pyramind.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751548Ab1LMLFg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 06:05:36 -0500
Date: Tue, 13 Dec 2011 11:05:56 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Pekka Enberg <penberg@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>,
        Sasha Levin <levinsasha928@gmail.com>
Subject: Re: [patch 0/3] kvm tool: Serial emulation overhaul
Message-ID: <20111213110556.529176e6@pyramind.ukuu.org.uk>
In-Reply-To: <alpine.LFD.2.02.1112130859530.2138@tux.localdomain>
References: <20111210132220.083204833@linutronix.de>
	<alpine.LFD.2.02.1112101715500.10936@tux.localdomain>
	<alpine.LFD.2.02.1112102144370.3020@ionos>
	<alpine.LFD.2.02.1112111014500.1663@tux.localdomain>
	<20111211103047.GA19299@elte.hu>
	<alpine.LFD.2.02.1112111459270.3020@ionos>
	<20111211155347.GA1297@elte.hu>
	<CAOJsxLHTuN43AGA7C02MtETzJU87y9cRaWRg6e9ER7NxOK2w-Q@mail.gmail.com>
	<20111212172059.GC23870@elte.hu>
	<CAOJsxLFk9Af+b4PAx_j+1QhApBsFdXyZY1aK08fb_6_dTiBEDQ@mail.gmail.com>
	<20111212192135.GA18876@elte.hu>
	<alpine.LFD.2.02.1112130056370.3020@ionos>
	<alpine.LFD.2.02.1112130859530.2138@tux.localdomain>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I assume '16' here is the 16550A FIFO size? Is there any reason we can't 
> cheat and use a deeper FIFO internally?

Providing you emulate the fifo itself the guest has no idea how many bits
are leaving the fifo and at what rate in normal use. However you need to
be a bit cleverer to handle fifo sizing.

More generically there are a wide range of 8250 derived UART devices with
larger FIFOs if probed. The extra logic to emulate those isn't that much
and will take you to 64byte FIFO trivally enough and in a way that should
work with random guests.

Alan

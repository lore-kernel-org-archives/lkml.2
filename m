Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753240Ab1LBXVb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 18:21:31 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:41613 "EHLO
	earthlight.etchedpixels.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752118Ab1LBXVa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 18:21:30 -0500
Date: Fri, 2 Dec 2011 23:22:43 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Dave Martin <dave.martin@linaro.org>
Cc: Anton Vorontsov <cbouatmailru@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        devicetree-discuss@lists.ozlabs.org,
        LKML <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
        Randy Dunlap <rdunlap@xenotime.net>, linux-next@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jeff Garzik <jgarzik@redhat.com>
Subject: Re: [PATCH] ata: Don't use NO_IRQ in pata_of_platform driver
Message-ID: <20111202232243.6af6f1e2@lxorguk.ukuu.org.uk>
In-Reply-To: <20111202191917.GB3037@localhost.localdomain>
References: <20111110151852.GA7465@oksana.dev.rtsoft.ru>
	<20111110152606.GB3207@oksana.dev.rtsoft.ru>
	<20111110153816.239af1d7@lxorguk.ukuu.org.uk>
	<20111110162859.GA7088@oksana.dev.rtsoft.ru>
	<20111202191917.GB3037@localhost.localdomain>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.7; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This is now broken on ARM where, for good or bad, NO_IRQ currently is
> used and is -1.

Good.

ARM developers have been told to change this for several years. The nice
approach hasn't worked, the patient approach hasn't worked so now finally
ARM is going to be dragged kicking and screaming into doing the work
everyone else did several years ago.

I have so little sympathy over this that you'll need a quantum physicist
to measure it.

> Half-removing NO_IRQ is going to be problematic, though...
> I really don't care whether the "no irq" value is 0 or -1, but it is
> abundantly clear that choosing different values to mean the same thing
> on opposite sides of an interface does not work.

You've had years to fix it. If I were you I'd delete NO_IRQ from your
tree, type make and get it done. It's not even a big job to clean it out.

At that point various other drivers will also start working properly on
ARM because they use 0 for polled mode.

Alan

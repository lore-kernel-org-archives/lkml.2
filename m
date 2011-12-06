Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933318Ab1LFKe1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 05:34:27 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:49264 "EHLO
	earthlight.etchedpixels.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933276Ab1LFKeW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 05:34:22 -0500
Date: Tue, 6 Dec 2011 10:34:57 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Dave Martin <dave.martin@linaro.org>
Cc: Rob Herring <robherring2@gmail.com>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Pawel Moll <pawel.moll@arm.com>, devicetree-discuss@lists.ozlabs.org,
        LKML <linux-kernel@vger.kernel.org>, Jeff Garzik <jgarzik@redhat.com>,
        linux-ide@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>,
        linux-next@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Jonas Bonn <jonas@southpole.se>,
        Michal Simek <monstr@monstr.eu>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] ata: Don't use NO_IRQ in pata_of_platform driver
Message-ID: <20111206103457.1c662b6d@lxorguk.ukuu.org.uk>
In-Reply-To: <20111206093000.GA2274@linaro.org>
References: <20111202192618.GC3037@localhost.localdomain>
	<CA+55aFwekNWz+V4440f=2iu_BfOxSg0NjVogv4cZZDFbJBNoAQ@mail.gmail.com>
	<1322867573.11728.22.camel@pasglop>
	<20111205161157.GA27550@localhost.localdomain>
	<alpine.LFD.2.02.1112051236350.2357@xanadu.home>
	<20111205180253.GB29812@localhost.localdomain>
	<alpine.LFD.2.02.1112051310150.2357@xanadu.home>
	<4EDD1897.4030208@gmail.com>
	<20111205202125.GA32592@oksana.dev.rtsoft.ru>
	<4EDD2DE1.1050606@gmail.com>
	<20111206093000.GA2274@linaro.org>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.7; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Otherwise, it feels like we might need a strategy for migrating pretty
> much everything if we don't want to end up in a mess.

You really do anyway - lots of generic driver code knows !dev->irq is a
valid test. That covers things like 8250 based UART hardware, network phy
layer code and vast amounts more.

The bugs will already be there because ARM isn't using 0, they just
aren't getting seen or aren't getting hit.

Alan

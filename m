Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964811Ab1KJPf1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 10:35:27 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:60456 "EHLO
	earthlight.etchedpixels.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751465Ab1KJPfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 10:35:24 -0500
Date: Thu, 10 Nov 2011 15:35:50 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Jeff Garzik <jgarzik@redhat.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH] ata: Fix build error in pata_of_platform (NO_IRQ usage)
Message-ID: <20111110153550.6274179d@lxorguk.ukuu.org.uk>
In-Reply-To: <20111110151852.GA7465@oksana.dev.rtsoft.ru>
References: <20111011201127.455df266dcbffb1d621f8576@canb.auug.org.au>
	<4E94A920.40503@xenotime.net>
	<4E987829.3080104@xenotime.net>
	<20111110135703.GA23609@elte.hu>
	<20111110151852.GA7465@oksana.dev.rtsoft.ru>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.7; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The proper fix (stop OF code from returning NO_IRQ values) is pending.

Please just apply the proper fix.

> - The NO_IRQ disease spreads despite our willingness, even within
>   the new OF code.

Then it can stop right here, because if the arch people don't fix their
code to use zero their ATA port won't work.

> +/* For archs that don't support NO_IRQ (such as x86), provide a dummy value */
> +#ifndef NO_IRQ
> +#define NO_IRQ 0
> +#endif

NAK - just test against zero. They've been complained at about this for
over two years. Enough is enough.

Alan

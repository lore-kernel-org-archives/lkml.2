Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757091Ab2ADWBL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 17:01:11 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:37694 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757035Ab2ADWBK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 17:01:10 -0500
Date: Wed, 4 Jan 2012 22:01:58 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: alan@linux.intel.com, gregkh@suse.de, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] serial: relocate remaining serial drivers from tty/ to
 tty/serial/
Message-ID: <20120104220158.3300d65b@pyramind.ukuu.org.uk>
In-Reply-To: <1325707287-31038-1-git-send-email-paul.gortmaker@windriver.com>
References: <1325707287-31038-1-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  4 Jan 2012 15:01:27 -0500
Paul Gortmaker <paul.gortmaker@windriver.com> wrote:

> The commit ab4382d27412e7e3e7c936e8d50d8888dfac3df8,
> 
>    "tty: move drivers/serial/ to drivers/tty/serial/"
> 
> put most of the serial drivers together in one place, but the ones
> that were hiding in drivers/char didn't get picked up in that change.
> 
> They did get moved in commit a6afd9f3e819de4795fcd356e5bfad446e4323f2
> 
>    "tty: move a number of tty drivers from drivers/char/ to drivers/tty/"
> 
> but there was no distinction of serial vs. non-serial in the above.
> 
> Here we take the remaining serial drivers (mostly legacy multiport
> drivers) and put them alongside all the others in tty/serial/ dir.
> 
> We can drop SERIAL_NONSTANDARD's dependency on HAS_IOMEM, since the
> encompassing menu block already has that dependency called out.

NAK

The tty/serial directory is the stuff using serial_core. I'm not averse
to moving the others down a layer into more appropriate places but its
already too crowded and in need of re-ordering (eg tty/serial/8250/...
might be an improvement)


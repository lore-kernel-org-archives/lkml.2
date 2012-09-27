Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754671Ab2I0PIX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 11:08:23 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:46416 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754380Ab2I0PIV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 11:08:21 -0400
Date: Thu, 27 Sep 2012 16:13:12 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@parallels.com>, Jiri Slaby <jslaby@suse.cz>
Subject: Re: [RFC] tty: Add get- ioctls to fetch tty status
Message-ID: <20120927161312.1eadd5d6@pyramind.ukuu.org.uk>
In-Reply-To: <20120927142149.GH6618@moon>
References: <20120922201144.GD11610@moon>
	<20120922215232.GA25778@moon>
	<20120923010953.GA17663@kroah.com>
	<20120923064007.GA2994@moon>
	<34f6ba7b-2c50-492e-9267-52d328a8d37f@email.android.com>
	<20120924141441.GD16532@moon>
	<20120927140502.GB12552@moon>
	<20120927151447.2460ce44@pyramind.ukuu.org.uk>
	<20120927141425.GG6618@moon>
	<5064600D.1090506@zytor.com>
	<20120927142149.GH6618@moon>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Well, sure inside our tool before doing checkpoint we stop all
> tasks which are part of dumpee process tree. This unfortunatly
> doesn't apply to these ioctl calls. Peter, any idea how to deal
> with that?

I suspect you can't deal with that. Which isn't to say you can't still
build something useful. The query interfaces are trivial enough and
beyond that it's simply a case of documenting that they are not intended
to be generically "safe" but provide a spot sample.

Otherwise - TICOGPKT is specific to pty devices. Please therefore put it
in the pty.c code and note that not all platforms use asm-geneic TTY
ioctls so check carefully they all build.

Alan


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754463Ab1LBLsF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 06:48:05 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:39305 "EHLO
	earthlight.etchedpixels.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754231Ab1LBLsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 06:48:03 -0500
Date: Fri, 2 Dec 2011 11:49:30 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Alan Cox <alan@linux.intel.com>, gregkh@suse.de, galak@kernel.crashing.org,
        scottwood@freescale.com, linux-serial@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] serial: make bugs field not specific to 8250 type
 uarts.
Message-ID: <20111202114930.74b65569@lxorguk.ukuu.org.uk>
In-Reply-To: <CAP=VYLpn7kJJ6we3diqhCR+QzjQtzTmkEzSP-uw07=udJKYK6g@mail.gmail.com>
References: <1322783258-20443-1-git-send-email-paul.gortmaker@windriver.com>
	<1322783258-20443-2-git-send-email-paul.gortmaker@windriver.com>
	<20111202005150.2e9fde43@bob.linux.org.uk>
	<CAP=VYLpn7kJJ6we3diqhCR+QzjQtzTmkEzSP-uw07=udJKYK6g@mail.gmail.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.7; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> If you have an idea in mind how arch/platform code should cleanly
> pass data about known uart bugs to the uart driver, then let me know
> what you have in mind.  I've no real attachment to what I proposed
> here -- it just happened to be the solution I thought would be the least
> offensive.  If there is a better idea floating around, I'll go ahead and
> try to implement it.

My first guess is that "the uart driver" is our first historical mistake.
Non standard 8250ish uarts should be their own platform driver which uses
8250.c for support.

Things like 8250_dw.c is perhaps more the style we want to be looking at
for other devices and adjusting 8250.c as needed to export or split
methods up so they can be used as helpers.

Alan

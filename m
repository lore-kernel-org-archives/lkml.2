Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423000Ab2LGQ5X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 11:57:23 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:56685 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422976Ab2LGQ5W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 11:57:22 -0500
Date: Fri, 7 Dec 2012 17:02:15 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Roland Stigge <stigge@antcom.de>
Cc: gregkh@linuxfoundation.org, grant.likely@secretlab.ca,
        linus.walleij@linaro.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, w.sang@pengutronix.de,
        jbe@pengutronix.de, plagnioj@jcrosoft.com, highguy@gmail.com,
        broonie@opensource.wolfsonmicro.com, daniel-gl@gmx.net,
        rmallon@gmail.com, tru@work-microwave.de, sr@denx.de,
        wg@grandegger.com
Subject: Re: [PATCH 0/6 v10] gpio: Add block GPIO
Message-ID: <20121207170215.0057f791@pyramind.ukuu.org.uk>
In-Reply-To: <50C1DE21.8050709@antcom.de>
References: <1354830456-17590-1-git-send-email-stigge@antcom.de>
	<20121207103643.34ca6dc5@pyramind.ukuu.org.uk>
	<50C1DBD4.1040007@antcom.de>
	<50C1DE21.8050709@antcom.de>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 07 Dec 2012 13:16:33 +0100
Roland Stigge <stigge@antcom.de> wrote:

> On 12/07/2012 01:06 PM, Roland Stigge wrote:
> > On 12/07/2012 11:36 AM, Alan Cox wrote:
> >>> * Device interface for userland access (alternative to sysfs)
> >>
> >> Currently we can set different permissions on different GPIO lines. Your
> >> driver change drives a truck through this facility.
> 
> What I maybe misread in your concern: The dev interface is actually an
> "alternative to sysfs for block GPIO", not considered as a replacement
> for the current sysfs interface for _single_ GPIOs.

That is the problem. If you add the driver then you can no longer
implement the same permissions per node. If I've got a typical hardened
embedded device running something like SMACK I can tie a few gpio lines
to specific tasks in the security model.

The moment there is another driver anyone who can open that driver can
bypass all the security rules being imposed.

The basic problem is that right now our mapping is

"gpio line is a file system object"

you change it to

"all gpio lines are a single file system object"

Thats a bit like moving from "each document has permissions" to "allo my
documents have one permission set between them"

That makes it a very big step backwards and a fundamental change to the
entire auth model. It's not too horrendous in the case that the block
GPIO interface is the least restrictive case, but its very bad the
other way around.

The problem isn't the block API, the problem is changing the entire file
system level view of what a GPIO is and how it is access controlled.

Alan

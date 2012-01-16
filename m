Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756512Ab2APTlN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 14:41:13 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:44616 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755565Ab2APTlL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 14:41:11 -0500
Date: Mon, 16 Jan 2012 19:42:11 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Lin Ming <ming.m.lin@intel.com>, Jeff Garzik <jeff@garzik.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-ide@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git patches] libata updates for 3.3
Message-ID: <20120116194211.2cd09fb3@pyramind.ukuu.org.uk>
In-Reply-To: <CA+55aFzqECJjbtgyOXy_H1smh09SsfgrAuVY7hK2sC-xj1GZHg@mail.gmail.com>
References: <20120109003255.GA6598@havoc.gtf.org>
	<CA+55aFwcBQSoWfqdT9CxV=GAr5ex0=RnqtBDFty+=_Lua2VXGw@mail.gmail.com>
	<4F12E57E.3090805@garzik.org>
	<1326676534.13517.3.camel@minggr>
	<1326691403.13517.21.camel@minggr>
	<CA+55aFzqECJjbtgyOXy_H1smh09SsfgrAuVY7hK2sC-xj1GZHg@mail.gmail.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The IO ports are all there, the *only* reason we don't use AHCI seems
> to be that the firmware didn't turn off the legacy bit, so it doesn't
> show as an AHCI interface. That's kind of sad.

There are two sets of problems with that

The first is that quite a few machines crap themselves if you do this
because nobody has ever tested things like the IRQ routing or the
firmware on suspend/resume when they find the hardwared controller has
gone for a walk.

Putting it back on suspend might help in some cases but then you get to
pick your way through the documentation minefield, deal with device
changes while in non AHCI mode, figure out how to set up registers the
BIOS didn't etc.

Would be a good project for someone with a lot of patience anyway as the
AHCI mode is also 64bit capable and *much* faster overall as it doesn't
keep stalling the CPU poking imaginary registers and turning them into
messages on the SATA bus.

Alan
